---
title: Docker on Raspberry Pi 3 & 4
layout: post
tags:
  - docker
  - raspberry pi
maturity: draft
---

## Why Docker is not working out-of-the-box on Raspberry Pi 3 & 4

Docker is a virtualization technology, made to allow applications to be independent from the underlying system.
However because it is not a full-fledge virtual machine but rather a proxy to system resources leveraging on Linux kernel's virtualization features, it does not provide a total independance from the system's CPU architecture.

This is a problem with Raspberry Pi because most of the Docker images around are built for *amd64* architectures (x86 64 bits) and therefore will not run as-is on a RPi, which is *armhf*.

There are some registries providing Raspberry Pi Docker images (e.g. [linuxserver.io](https://www.linuxserver.io/)) but there are not plenty.
For instance, you will not find an XMPP server (*ejabberd* or *Prosody*) image on *linuxserver.io*.

For instance, [try to run OpenEats](https://github.com/open-eats/OpenEats/blob/master/docs/Running_the_App.md) (which provides a user-friendly script that pulls then runs a few docker images using *docker-compose*), on a Raspberry Pi :

    Pulling db (mariadb:5.5.64)...
    5.5.64: Pulling from library/mariadb
    ERROR: no matching manifest for linux/arm/v7 in the manifest list entries

Very frustrating...

https://hub.docker.com/u/balenalib/ : images balena.io (ex resin.io), surtout des images de base ?


## Raspberry Pi 3 & 4 CPU architecture

Raspberry Pi 3 and [4 have a 64 bits CPU (ARM v8)](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/specifications/) **but** there is no official OS with 64 bits support.

For instance the default *Raspbian* flavor is based on Debian *armhf*, which has a 32 bits kernel enhanced with Hardware Floating point ('hf' in 'armhf') support.
When running `cat /proc/cpuinfo` on a RPi 4 you get `armv71` and `BCM2835`, where you should get `armv8` and `BCM2711`, according to the specs. Therefore I assume this is because the *BMC2835* driver is used, with *armhf* kernel supporting only for *armv71*.

Fortunately it seems that recent versions can be tweaked to enable 64 bits support :

https://github.com/raspberrypi/firmware/issues/550#issuecomment-536453126 :

> Recent kernel releases include a trial 64-bit build. It hasn't made its way into the Raspbian kernel package yet, but you can install using `sudo rpi-update`. You will need to add `arm_64bit=1` to config.txt because the firmware prefers the 32-bit build.
>
> A 64-bit userland is not currently planned.

Questions :

- what is the level of compatibility of this 64 bits flavor ?
- would the effort to get a full 64 bits OS be worth it on the RPi ?


## So what ?

There are two alternatives I can think of :

1. Only run 32 bits images.
As I understand this means running **armhf**/[arm32v7](https://hub.docker.com/u/arm32v7/) images : this does not solve my problem because those images are not widely seen on the net. I would have to build my own images, which sometimes can become cumbersome because of build dependencies not compiled for the host OS (Raspbian).

2. Use a 64 bits OS.
This is risky as it may not be stable and many applications / libraries may not work yet. Docker would probably work since it mainly needs the kernel but that might mean running applications only as Docker containers, which is sometimes a lot of work...



## References

- [What is difference between arm64 and armhf? @ stackoverflow](https://stackoverflow.com/questions/37790029/what-is-difference-between-arm64-and-armhf)
- [AArch64 support #550 @ github.com/raspberrypi/firmware](https://github.com/raspberrypi/firmware/issues/550)
- [Operating System for Raspberry pi 4 (32/64 bit)](https://www.techiebouncer.com/2019/08/operating-system-for-raspberry-pi-4.html)
- [64-bit OS on Raspberry Pi 4](https://raspberrypi.stackexchange.com/questions/100926/64-bit-os-on-raspberry-pi-4)
