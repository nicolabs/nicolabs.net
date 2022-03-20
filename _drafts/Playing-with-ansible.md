---
title: "Ansible : love and hate"
layout: post
tags:
  - raspberry pi
  - bluetooth
  - "Series : your own cloud"
---

[Ansible](https://ansible.com) is a very good tool : with only a SSH connection and Python installed on remote machines you can automate the deployment of a whole pool of machines. However I've encountered that may be of some interest for newcomers.

## How to use tags

The possibility to *tag* tasks is a very good thing but the documentation is not clear on what can be achieved.

TODO always, never, all, setup, cleanup

When using `--tags foo` it disables all tasks and only runs those tagged with *foo*.
This seems actually logical but may be counter-intuitive for instance if you wanted to use it for a one-time activation of some tasks tagged with *never*, **in addition** to the usual ones it will fail : if they're not tagged with *foo* or *always*, usual tasks will not be run.
You then may tag all usual/default tasks with *always* to make sure they are run with or without `--tags` by default, but then how will you run **just a selection** of tasks with a given tag (e.g. `--tags bluetooth` to run only the roles/tasks that configure bluetooth) ?

What if a task has both *always* and *never* ? This can happen with inheritance (e.g. a block is tagged with *always* but a task inside this block is tagged with *never* so it's not executed by default). The documentation does not say it explicitely, but *always* wins (so in my example will not work).

What happens with `--all,never` ? Are tasks tagged with *never* run since they **do** have a tag ?

No user-friendly way to run only a (set of) role(s) in a playbook. The official recommended way is to use tags. One can run [`ansible localhost -m include_role -a name=<role_name>`](https://stackoverflow.com/questions/38350674/ansible-can-i-execute-role-from-command-line) but the syntax is not appealing... Maybe [ansible-toolbox](https://github.com/larsks/ansible-toolbox) ?

Let's now say that you have tagged all the tasks of a role "myrole" inside the `myrole/tasks/main.yml` using inheritance.
If you use `--tags myrole` in order to run only the tasks related to this role within a playbook, be aware that it will still run tasks tagged with **always**, which you probably didn't want to enable under such circumstances ! You would have to use `--tags myrole --skip-tags always`, which is counter-intuitive ! =>  cannot use a tag for selecting a role if others contain 'always' tags (which is often the case in third-party roles).
This can also be counter-intuitive with **never** : if you tagged all steps of your role with *myrole* and some of them with *never* so they should only be called with `--tags never`, then you can only achieve this with `--tags myrole --skip-tags never` ! But this is incompatible with the previous behaviour described with *always* !!! =>  cannot use a tag for selecting a role if it contains also 'never' tags

What if you want to run only the tasks that have several tags at the same time (e.g. *nextcloud* AND *docker*, which together designates the 'docker' version of the 'nextcloud' task/role) ? I could not find a way other than creating a third *nextcloud-docker* tag... Ansible misses here *operations* on tags (basic boolean operations would be great although many similar systems have also complex *glob* or *regex* filtering)

I've run into the following problem : if you include a third-party role that does not use the same tagging conventions, then you can just forget about using tags to select which roles to run...

## TODO

Nom des variables avec underscore est la convention (mais écrit nulle part ?). En termes de conception c'est null : tout est mis à plat plutôt que de regrouper en 'namespaces', ce qui donnerait une isolation plus claire.

Impossible de définir des structures yaml à spécialiser dans les variables des rôles : il faut mettre une liste de variables à plat.

Je regarde presque à chaque fois le manuel des tâches => prouve que ce n'est pas intuitif ; ou encore copier-coller

Avantage : force à bien découper et dissocier les dépendances

Inconvénient : parfois force à trop découper (difficile de trouver le juste milieu entre le découpage absolu qui est incompréhensible, complexe et du coup difficile à maintenir alors que c'est censé aider à la maintenance et trop de duplications / parties en dur)

Sometimes (it happened several times to me already, I cannot count the hours I lost because of this) dependencies are needed at runtime for **ansible** modules or filters (e.g. docker, json_query, ...). The task will just fail and there is not clean way to make sure the dependencies are there other than installing them yourself using a task. So your playbooks/roles become cluttered with those meta-dependencies you should not deal with and it won't let you run with -C until you installed them once or run the task without -C first !!!
E.g. https://github.com/ansible/ansible/issues/24319

Error messages are not clear because there is too many levels of indirection. It's even stated in error messages : `The error appears to have been in '/root/ansible/setup.yaml': line 9, column 12, but may be elsewhere in the file depending on the exact syntax problem.`.
The first time I mistyped the root password when ansible asked me I've just lost 1 or 2 hours finding the cause because the error was on an (apparently) unrelated task...

Bug des loop imbriquées :
> Attention, en plus de nécessiter 3 (!) fichiers pour imbriquer 2 boucles,
> si la variable 'item' est utilisée dans des boucles imbriquées cela fait
> planter avec un message ~ "incompatible type dict au lieu de string" !!!
> --> utiliser des loop_var distincts !


## Passwordstore integration

Using password store to automate SSH / sudo.

## Order is important

e.g.

    - command:
      loop:
      - "agent off"
      - "scan on"
          cmd: "bluetoothctl -- {{ item }}"

is not working but :

    - loop:
      - "agent off"
      - "scan on"
      command:
          cmd: "bluetoothctl -- {{ item }}"

does. YAML syntax.

Same for tags that I had to put to the end in blocks.

## The bad : demonstration

Here is a simple use case :

You need to *fetch* public keys from a file on each remote hosts and save them together in a directory on the local host.
On each host, the key is located at the same place : `/home/me/.keys/me.pub`.
You want it to be to stored locally at `/var/keys/{{ inventory_hostname }}.pub`.

Fortunately, ansible **does** have a *[fetch](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/fetch_module.html)* module :

```yaml
  name: Fetch the remote public key
  fetch:
    src: /home/me/.keys/me.pub
    dest: /var/keys/{{ inventory_hostname }}.pub
    flat: yes
```

Well, according to the docs, it will just not work.

First, you have to specify `flat: yes` otherwise the file will be saved into :

    /var/keys/{{ inventory_hostname }}.pub/{{ inventory_hostname }}/home/me/.keys/me.pub

What ? 🤔

Ok, they've chosen a weird default behavior... But even with `flat: yes`, according to the docs, you will end up with the file copied into the wrong place :

    /var/keys/{{ inventory_hostname }}.pub/me.pub

What. The. Hell. 🙄

Fortunately, the doc is wrong and this will work as expected. 😅

However it reveals a lack of design that I've found in many modules. It looks cumbersome to introduce some very opinionated default behaviour like creating a whole file tree by default, rather than simply leaving the user specify the exact destination path.

In many other modules, this ends up restricting the use cases so much that the user will have to craft the feature herself, making the playbook much more complicated.

It happens very often to me.

## TL;DR

- Very easy to use and deploy : only SSH and Python is required on the target machine. This is the reason why I stick to it, still.
- Not universal, though : mainly runs on Linux (Windows modules are separate ones, so you need to craft roles that include the 2 logics : one for Linux and one for Windows) ; there are other devices (like network routers) addressed through specific modules but I haven't tested
- There is a lot of existing modules in *galaxy*, but you usually don't use them because you don't trust the code to be safe or it's not doing exactly what you need, or it's not documented.
- It's slow : playbooks can very quickly take dozen of minutes with only a dozen of roles. This is because, to get them clean & evolutive, modules are quite independent of each others and run in sequence. The result is that plays are not globally optimized and ansible seems to execute each task one after the other, each time cumulating the time to transfer, unzip and prepare the code to the remote host...
- A LOT of modules don't have a *check mode*, and ansible does not make it easy to provide one. So you will basically capitulate and don't test fully your playbooks.
- I find many core features, modules, lookups, to have design flaws, making it sooo complex to do simple things... Quite often I end up with a (not-so-portable) `command` instead of crafting 3-4 tasks together, that would have made the play undreadable.

## Also

- no way to declare a requirement inside a role (I have to use requirements.yml and install by hand with galaxy ?)
- cannot order in all parts (find the example ; was it with pre/post within roles ?)
- it's SLOW ! For instance looping on a list makes (apparently ?) ansible trigger one connection for each item ! For instance if you include the *haxorof.docker_ce* role in each role that needs docker installed, you just add several minutes to each one of them !

- Check mode was a good idea but since it's only implemented in half of the modules it's unuseable.
The playbook will fail because a prerequisite will not be done by some previous task (e.g. set a fact, create a file, ...)
or just return inconsistent results, making the test useless...
It may be useful to test a single task or small group of task but cannot be used to get confidence that a playbook will work.
In order to change this, one would need to apply strict development rules (making sure every task has an (actually useful) check mode), but ansible does not make it easy by providing little to nothing to allow this. For instance, there is no simple way to provide an alternate command to the 'command' module, that would execute in check mode (it's just one drop in the ocean, however).

- globally counter-intuitive behaviors, which often lead to bugs or does not compile :
  - variables are global, and cannot be redefined in a role if already set, but it's silent so you will not get the intended value ! -> you need to prefix variables in roles with the name of the role (or maybe it's the purpose of collections, but it came a bit late now I have to redesign all my roles...). See https://stackoverflow.com/questions/22522985/how-can-i-write-variables-inside-the-tasks-file-in-ansible => there is no simple way to cleanly define 'local' variables, which makes the "code" cluttered with copy-pasted texts and makes it less evolutive
  - include_role and other similar "modules" don't propagate their properties (e.g. 'ignore_errors'), you have to use 'apply' or stick with import_role...
  - cannot loop inside a loop (you have to put in an external file) ; it makes the code heavy
  - cannot loop blocks...
  - I'm not the only one : https://medium.com/opsops/ansible-anti-pattern-import-role-task-with-task-level-vars-a9f5c752c9c3
  - they have so many issues (over 1k !) that I don't see how they can possibly go through... And it's almost impossible to find one (try to search an issue for `is file` test on paths...)


## References

- [Use Ansible Tags to Organise your Plays & Tasks](http://www.oznetnerd.com/use-ansible-tags-organise-plays-tasks/)
