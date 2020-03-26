---
title: Make a Raspberry Pi a A2DP Bluetooth receiver
layout: post
tags:
  - raspberry pi
  - bluetooth
  - "Series : your own cloud"
---

In this article I gather the steps I had to take to :

- make a *Raspberry Pi 4* play music as a Bluetooh AD2P receiver
- without a GUI (it's a headless RPi with only SSH access)

# The basis

First, there are several solutions to enable Bluetooth A2DP in linux : it takes at least a bluetooth listener, an audio driver and a way to forward the first to the last.

I've found the following solution working :

1. [This article](https://thecodeninja.net/2016/06/bluetooth-audio-receiver-a2dp-sink-with-raspberry-pi/) explains the generic way to do it with *bluez* and *pulseaudio* but is for *xbian* and uses a GUI
2. This one gives specific instructions for the Raspberry Pi
3. This one adds headless instructions
4. This one adds automatic pairing instructions
5. [This one](http://bluetooth-pentest.narod.ru/software/bluetooth_class_of_device-service_generator.html) allow to find the best bluetooth class depending on the hardware

# References

- [nicokaiser/rpi-audio-receiver @ github](https://github.com/nicokaiser/rpi-audio-receiver/blob/master/README.md) : I've tried it on my RPi 4 : althought it looks promising it doesn't work ootb
