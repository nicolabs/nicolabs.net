---
title: Make a Raspberry Pi a A2DP Bluetooth receiver (part 2)
layout: post
tags:
  - raspberry pi
  - bluetooth
  - "Series : your own cloud"
  - "Series : Make a Raspberry Pi a A2DP Bluetooth receiver"
---

In this two-part article I describe the steps I had to take to make a *Raspberry Pi 4* play music as a Bluetooh AD2P receiver without a GUI (it's a headless RPi with only SSH access).

More precisely, the goal is to allow user friendly pairing for anyone in the room with a Bluetooth smartphone, while making sure the neighbors won't be able to connect without approval.

*This is a two-part article :*
1. *[How Bluetooth pairing works](Make-RPi-bluetooth-receiver-part-1) (part 1)*
2. *Raspberry Pi as a Bluetooth A2DP receiver (this part)*

## The basis

First, there are several solutions to enable Bluetooth A2DP in linux : it takes at least a bluetooth listener, an audio driver and a way to forward the first to the last.

I've found the following solution working :

1. [This article](https://thecodeninja.net/2016/06/bluetooth-audio-receiver-a2dp-sink-with-raspberry-pi/) explains the generic way to do it with *bluez* and *pulseaudio* but is for *xbian* and uses a GUI
2. This one gives specific instructions for the Raspberry Pi
3. This one adds headless instructions
4. This one adds automatic pairing instructions
5. [This one](http://bluetooth-pentest.narod.ru/software/bluetooth_class_of_device-service_generator.html) allow to find the best bluetooth class depending on the hardware

## Audio / Volume tuning

- `amixer set Master 100%` since the Rpi's audio output is not loud enough (I have to set the volume of my Hi-Fi to the maximum). It also sets the volume of the *sink* in PulseAudio ; see more audio tuning here : https://www.instructables.com/id/Turn-your-Raspberry-Pi-into-a-Portable-Bluetooth-A/
- amixer only displays a 'Mono' channel : how to make sure it sources & sinks stereo from the BT devices ?
- It is also possible to set sink volume through PulseAudio with pacmd command. In my experience both amixer and pacmd correctly set the volume for ALSA and PulseAudio. However *source* volume might not be set to its maximum by default (?) : `pacmd set-source-volume 0 65537` (and optionally `pacmd set-sink-volume 0 65537`). Run `pacmd dump-volumes` to print current PA volumes.

## TODO

The problems described [here](http://youness.net/raspberry-pi/bluetooth-headset-raspberry-pi-3-ad2p-hsp) might not apply to Rpi 4 as it seems to have a *bcm2835* ?


Why turning discovery off while a device is already connected ?

    # Turn off BT discover mode before connecting existing BT device to audio
    hciconfig hci0 noscan


## References

- [nicokaiser/rpi-audio-receiver @ github](https://github.com/nicokaiser/rpi-audio-receiver/blob/master/README.md) : I've tried it on my RPi 4 : althought it looks promising it doesn't work ootb
- [Turn Your Raspberry Pi Into a Wireless Portable Bluetooth Audio System A2DP](https://www.instructables.com/id/Turn-your-Raspberry-Pi-into-a-Portable-Bluetooth-A/)
- [How To Connect Bluetooth Headset Or Speaker To Raspberry Pi 3](http://youness.net/raspberry-pi/how-to-connect-bluetooth-headset-or-speaker-to-raspberry-pi-3)
