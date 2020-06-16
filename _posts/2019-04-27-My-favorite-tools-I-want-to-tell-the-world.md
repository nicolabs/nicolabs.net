---
layout: post
title: My favorite tools I want to tell the world about
tags:
  - android
  - cloud
  - diagrams
  - mastodon
  - uml
  - social
  - tooling
  - twitter
last_modified_at: 2020-03-31
maturity: good
---

This page lists some tools I've been using with success for a while : they may fit your needs as well !


## NextCloud

![NextCloud logo](/assets/blog/3rdparty/logos/nextcloud.108x72.png)

[NextCloud](https://nextcloud.com/) (a fork of [OwnCloud](https://owncloud.org/)) is a very promising software that aims to bring usual cloud services to the home.

However, it's based on pluggable features that are not always stable. Here are the ones I'm using on a day-to-day basis :

- web interface to **access my own files** (however synchronization, backup and other features on files are not yet usable in my opinion)
- **share files** with others
- **calendar** (coupled with DAVDroid and any Android calendar it has all features Google Calendar has, except event import from/sharing to email)
- **contacts** (really excellent)
- **news** (use with a RSS/Atom reader on your mobile)

## PlantUML

![PlantUML logo](/assets/blog/3rdparty/logos/plantuml.116x112.png)

[PlantUML](https://plantuml.com/) is a very simple **textual language to create diagrams**.
You describe your diagram as plain text and use any of the provided tool to automatically render a picture.

It is very easy to learn and has integrations with [A LOT](https://plantuml.com/fr/running) of tools.
As the diagrams are simple text blocks, you can save them in a version control system, diff' them, embed them in other documents, copy/paste them in online tools to view and edit, ...
It has several renderers out of the box like PNG, SVG, LaTeX ; you can even generate ASCII art sequence diagrams !

I use it at work in *maven* builds to generate technical or inline documentation, in *Atom* or *Visual Studio Code* for writing specifications, you can live-code architectures with colleagues, build deployment diagrams on the fly within a web page, ...
You will also find several other tools not referenced from the main site but using the same language.

The main drawback is that you don't control the way figures are laid out.
Even with the few tweaks available you may not be able to get a clear view with the biggest diagrams.


## Twidere

![Twidere logo](/assets/blog/3rdparty/logos/twidere.512x512.png){:height="128px"}

[Twidere](https://github.com/TwidereProject/Twidere-Android) is definitely the only one, perfect, **Twitter** Android client for me (and I've been searching a lot).
It's open source. It handles every single feature I need (disclaimer : I'm only a casual Twitter user).

I've been using it for years... And since it happens to be very good also at **Mastodon** I do continue to use it every day.


## Wallabag

![Wallabag logo](/assets/blog/3rdparty/logos/wallabag.200x69.png)

[Wallabag](https://wallabag.org) is an open source alternative to *Pocket*, *Instapaper*, ... to save articles from the web and **read them later**.
There are integrations with web browsers and smartphones.
I've been adding and reading articles with wallabag for years : you don't need another tool !


## More tools

The following ones are part of my toolbox, they will get a small description each in the future :

- Passwordstore
  - warning ! [The f-droid version is far out of date](https://github.com/android-password-store/Android-Password-Store/issues/648). It's kind of tough to get a seamless integration with all tools (e.g. you have to get the very latest Android to benefit from Firefox mobile integration) but the simplicity of the mechanism (it's nothing else than GPG-encrypted files possibly versioned with git) make it universal. I'm only doubtful about the community looking smaller than the one of the more graphical KeePass, which is a risk to see it unsupported in the future.
  - it can use git to pull & push changes to remote devices (the safest and most portable way I've found : it works in all clients I've tested : qtpass, Android, iOS), but not all apps provide the same user experience (e.g. *passforios* does not pull/push automatically, it's just a button but still annoying). The best option here - because we talk about critical data like passwords - is to use a private git repository, which unfortunately requires setting up a server
  - or you can use SyncThing for a seamless synchronization, with its (see below)
  - Available apps are not official and therefore suffer from a different maturity ; e.g. *passforios* cannot generate SSH nor PGP keys by itself : it must import them (and [PGPro](https://pgpro.app/) only works on iOS 13+)
- SyncThing is a very useful and generic decentralized (server-less) synchronization system for all your devices. However I couldn't install it on iPhone and you can't go without conflict files on a regular basis (which are just ok to delete 99% of the time however, so it's fine in the end because it could not be done better after thinking about it)
- ForceDoze (Android)
- K-9 Mail
- Silence
- VLC
- Markor (Android) / Bear (iOS)
- FastHub-Libre
- RadioDroid
- AntennaPod
- F-Droid
