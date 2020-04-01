---
layout: post
title: Where Android Market stores the downloaded .apk
date: 2011-12-22 07:12:17 +0100
tags:
  - android
  - apk
permalink: articles/where-android-market-stores-downloaded-apk
maturity: stable
---
Today I ran into a small problem that might happen sometimes : trying to benefit from a 2 day-only offer to download for free [Duke Nukem 3d](https://market.android.com/details?id=com.machineworksnorthwest.duke3d) (just for fun, I don't think it's going to be the killer app this year ;-), I found out that my phone had not enough free memory to install it (Market told me : 56MB required).

After having removed several apps from the memory to free enough space to install the game - and after a first failed attempt to download the 28MB archive - I was able to download the _.apk_ from the Market (that was "phase 1 : download").

Immediately after the file was downloaded, I started up my [Open Advanced Task Killer](https://market.android.com/details?id=com.rechild.advancedtaskkiller&hl=en) to free more memory for the installation process.

Unfortunately I got the very bad idea to kill the Android Market process, _while it was already installing the app_ ("phase 2 : installation").

From there, even though Duke Nukem 3d was listed in my installed apps, I only had the option to install it, not to launch nor uninstall it. Even launching the Market again was not triggering the installation anymore.

S**t happens.



Luckily, after a short introspection into the SD card and device filesystem, I was able to get the downloaded .apk file and start the app without using more (of my limited) bandwith.

Here is what I could observe :

- the original downloaded .apk was stored as `/cache/downloadfile-2.apk`, and fully functional
- there was `/data/app/com.machineworksnorthwest.duke3d.zip`, probably interrupted reconstruction or copy of the apk into its final destination
And the procedure I used to get it working (type the given commands) :

1. `adb shell` (*adb* is a command from the [Android sdk](http://developer.android.com/sdk/index.html), which is therefore required)
2. `su` (root access is required, look for it on [xda forums](http://forum.xda-developers.com/))
3. `cat /cache/downloadfile-2.apk > /sdcard/com.machineworksnorthwest.duke3d.apk` (this simply copies from cache to SD card)
4. Finally, use any file browser like [Astro](https://market.android.com/details?id=com.metago.astro) to go to the root of the SD card and click on the .apk to uninstall/install/start it


I didn't look for more details, as I already got what I wanted, but this event made me curious about the internals of the Android Market app, and I might come back later to add more to this article...

![Duke Nukem 3d app icon](/assets/blog/dn3d.png?style=centerme)
