---
layout: post
title: Pinned PortableApps on Windows 7
date: 2014-05-20 08:10:45 +0100
permalink: articles/pinned-portableapps-windows-7
tags:
  - portable
  - PortableApps
  - windows
---
If you are using _PortableApps_, you might have noticed that some programs like _Firefox_ or _PuTTY_ launched from Windows 7's task bar starts the system wide installation instead of the PortableApps's one.

This is because when you pin a program to the task bar, it uses the executable of the current process, and with PortableApps this executable is not the same as the launcher, which takes care of loading the portable configuration.

![Putty shortcut](/assets/blog/win7_taskbar_pinned_putty.png)

=> edit the shortcut to use the parent executable, like `C:\Tools\PortablePuTTY\PortablePuTTY.exe` for instance.

See [answers.microsoft.com/en-us/windows/forum/windows_7-desktop/windows-7-taskbar-pinned-items-have-disappeared/a978bf01-e4ce-4a53-ac42-cfcef1aca00](http://answers.microsoft.com/en-us/windows/forum/windows_7-desktop/windows-7-taskbar-pinned-items-have-disappeared/a978bf01-e4ce-4a53-ac42-cfcef1aca00)
