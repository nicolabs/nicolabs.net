---
title: Version control integration for Ubuntu 12.04
date: 2012-09-22 13:28:15 +0100
tags:
  - hg
  - Ubuntu
  - eclipse
---

I've been used to great *Eclipse* plugins to deal with SVN-versionned projects for a long time.

Nowadays I'm using **Mercurial** (a.k.a. *Hg*) a lot and it became more handy to me to use *Tortoise*-like products, which integrate directly into the OS' file manager.

I've come to use the following solutions for the different platforms I'm working with (on Ubuntu 12.04).


### Mercurial for Nautilus

*TortoiseHg* works fine, but I had to add a script to have the corresponding "Actions" menu with a right click on a file : [hg.ice-os.com/nautilus_mercurial_scripts](http://hg.ice-os.com/nautilus_mercurial_scripts/)


### Mercurial for Dolphin

After some problems copying big files through USB and others, I realized that Nautilus was prone to copy errors so I decided to get back to Konqueror / Dolphin.

Unfortunately, Dolphin is not as much advanced as Konqueror was in KDE 3.x, so I also had to find a way to add a "Service Menu" for TortoiseHg : [bitbucket.org/tortoisehg/hgtk/issue/1270/better-integration-in-kde4](https://bitbucket.org/tortoisehg/hgtk/issue/1270/better-integration-in-kde4)


### Git for Nautilus

*RabbitVCS* looks nice, but I've not tested it a lot : [www.rabbitvcs.org](http://www.rabbitvcs.org/)


## Links

- Dolphin service menu for Tortoise HG - [gist.github.com/3765877](https://gist.github.com/3765877)
- Nautilus actions menu for Tortoise HG - [hg.ice-os.com/nautilus_mercurial_scripts/](http://hg.ice-os.com/nautilus_mercurial_scripts/)
