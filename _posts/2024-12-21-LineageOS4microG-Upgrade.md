---
title: Install LineageOS with Google Services and root
layout: post
maturity: draft
tags:
  - Android
  - Fairphone
  - Google
  - gapps
  - LineageOS
  - Magisk
  - microG
  - root
---

LineageOS does not ship with Google apps ("gapps"), which are unfortunately required for some usages (localization, push notifications, Maps API) and by few apps which depend directly on it (which is actually a bad practice).
Although LineageOS provides [a procedure to install gapps](https://wiki.lineageos.org/gapps/), they DO NOT support it.

[LineageOS of microG](https://lineage.microg.org/) provides LineageOS images for your phone, *directly shipping with microG*, which is an implementation of gapps.
shipping

This short tutorial gives some details about the **upgrade** procedure, which were not clear to me.
There is no per-device specific documentation for *LineageOS for microG*, so it is based on [the official LineageOS one](https://wiki.lineageos.org/devices/).

## The easy way

1. Download the new image from : https://lineage.microg.org/
The image to install is named something like [lineage-20.0-20230604-microG-FP3.zip](https://download.lineage.microg.org/FP3/lineage-20.0-20230604-microG-FP3.zip).

2. Copy the image onto your smartphone.
You can just plug your phone as an USB disk.

3. Use the "Local update" menu from the LineageOS installer app (Android admin menu > System > System updates > expand menu button).
**Do not use the images proposed by the LineageOS updater app** as it would install the official LineageOS image, not the microG one.
You can just ignore the items proposed for download, they will disappear at the next reboot after the upgrade.

4. Reboot the phone.

## The not-so-easy way

1. Download the new image as above.

2. Make sure you have a custom *recovery* on your smartphone.
This is a whole procedure to do if you don't have it already, but afterwards you will keep it for future upgrades. There are indications on how to do it *somewhere...*

3. Reboot into recovery and "just" flash the .zip image
Read detailed instructions for your device ; it's something like : `fastboot [...]`, then `adb sideload [...]` (e.g. [for Fairphone3](https://wiki.lineageos.org/devices/FP3/install/variant1))

4. To (re)get *root*, [install Magisk](https://topjohnwu.github.io/Magisk/install.html) :
    - Even if installing from the app, you have to download the zip (and select it from the app or install it from recovery)
    - Magisk installs itself into the ROM of your phone, for this :
      1. it needs the current image of the boot/recovery partition (either `boot.img`, `init_boot.img` or `recovery.img` depending on your device). So you must give it the exact image that you've just installed so it can patch it : e.g. for LineageOS for microG the boot.img of FP3 is in the same folder as other images to download : [lineage-20.0-20230601-microG-FP3-boot.img](https://download.lineage.microg.org/FP3/lineage-20.0-20230601-microG-FP3-boot.img)
      2. Then you patch it (from the app)
      3. Once done, download the patched image (it's in the Downloads directory on your phone ; e.g. `/sdcard/Download/magisk_patched-26100_c1Cdy.img`) to your PC
      4. Finally flash back this image on your phone (`fastboot [...]`)