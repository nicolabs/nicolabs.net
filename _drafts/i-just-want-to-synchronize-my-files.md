---
title: I just want to synchronize my files
layout: post
tags:
  - security
  - cloud
  - "Series : your own cloud"
---

What does it mean to "just synchronize my files" ?

At first it seems simple but behind the scene it has complex implications that cannot be solved by the machine alone.

# NextCloud / OwnCloud

Although they advertise *synchronization* features both on the server and mobile applications, they actually lack one huge commonly requested feature : automatic file synchronization. The "synchronize" feature in the Android app actually just synchronizes a file or directory once, when clicked by the user : there is no automatic handling of that. A deal-breaker.

Also : most features are not (or very badly) documented so it's very time-consuming to just understand what can be done and how.

# Syncthing

# Samba

Use samba for its performance (vs NFS) and to access files directly when you're on your home network.
