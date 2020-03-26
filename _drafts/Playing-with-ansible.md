---
title: Make a Raspberry Pi a A2DP Bluetooth receiver
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
If you use `--tags myrole` in order to run only the tasks related to this role within a playbook, be aware that it will still run tasks tagged with **always**, which you probably didn't want to enable under such circumstances ! You would have to use `--tags myrole --skip-tags always`, which is counter-intuitive ! =>  cannot use a tag for selecting a role if others contain 'always' tags
This can also be counter-intuitive with **never** : if you tagged all steps of your role with *myrole* and some of them with *never* so they should only be called with `--tags never`, then you can only achieve this with `--tags myrole --skip-tags never` ! But this is incompatible with the previous behaviour described with *always* !!! =>  cannot use a tag for selecting a role if it contains also 'never' tags

What if you want to run only the tasks that have several tags at the same time (e.g. *nextcloud* AND *docker*, which together designates the 'docker' version of the 'nextcloud' task/role) ? I could not find a way other than creating a third *nextcloud-docker* tag... Ansible misses here *operations* on tags (basic boolean operations would be great although many similar systems have also complex *glob* or *regex* filtering)


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


## References

- [Use Ansible Tags to Organise your Plays & Tasks](http://www.oznetnerd.com/use-ansible-tags-organise-plays-tasks/)
