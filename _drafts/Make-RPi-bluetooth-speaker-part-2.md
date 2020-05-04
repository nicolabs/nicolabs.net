---
title: Make a Raspberry Pi a Bluetooth speaker (part 2)
layout: post
tags:
  - raspberry pi
  - bluetooth
  - "Series : Make a Raspberry Pi a Bluetooth speaker"
---

![Raspberry Pi 4 - https://www.raspberrypi.org / CC BY-SA (https://creativecommons.org/licenses/by-sa/4.0)](/assets/blog/3rdparty/pictures/800px-Raspberry_Pi_4.jpg)

In this two-part article I describe the steps I had to take to make a *headless Raspberry Pi 4* a Bluetooth A2DP speaker.

The exact goal was to offer a user-friendly way for anyone in the room to pair its Bluetooth smartphone with the Raspberry Pi and play music through it, while making sure the neighbors won't be able to connect without approval.

---

*This is a two-part article :*
1. *[How Bluetooth pairing works](Make-RPi-bluetooth-speaker-part-1) (part 1)*
2. *Raspberry Pi as a Bluetooth A2DP receiver (this part)*

---

Now that we've seen how Bluetooth pairing works, what does it take to make a Raspberry Pi a Bluetooth A2DP receiver ?

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

## Custom agent

Some crafted implementations I found around seemed to do the job but their code was not clear enough so while I introspected them to understand what they were doing and why, I ended up writing a new one, matching my use case.

Now let's identify which association model(s) fits our use case.


### Implementing a headless validation mechanism

In any of *Numeric Comparison*, *Just Works* and *Passkey Entry* we've seen that to fulfill our requirements we will need to implement some way to confirm that the device trying to connect is authorized. Bluetooth specifies this as "displaying" a number but they really mean "communicate to the device's owner".

This could be done in several ways.

Whitelist

Bluetooth MAC address : it may probably be spoofed

a Yes/No validation mechanism to validate any connection attempt.

Concretely, it would be possible by make the RPi speak aloud the code or send it to a human "admin" (e.g. via instant messaging), then have him validate with some external mechanism (e.g. answering back "Yes" aloud or through his own smartphone).
This could be an application on the admin's smartphone (chat, custom one, ...) or a custom agent on the RPi listening to the admin's vocal "OK", but it looks like there is no solution out of the box today...


A headless device may then adopt one of the following options :

- simply allow any device to connect ; data exchanges can still be secured, but will not protect against a MITM attack
- use a program (a *bot* actually) to simulate a user input, making sure no random number would need to be input
- develop advanced headless inputs (like audio speak / voice recognition)
- leverage on Out-of-Band protocol ?


#### Just works with BlueZ

If a *Just Works* model is triggered, the bluetooth agent may automatically pair with devices without a confirmation, or it may ask by some "headless" way a confirmation.
In the first case, although data exchange can be strongly secured, it cannot prevent an unknown device to pair.
In the latter case, it may require a fair amount of work to build such a confirmation mechanism.

Depending on the capabilities the *agent* advertised, it may never be called in this association model.


## References

- Top illustration : [Raspberry Pi 4 by https://www.raspberrypi.org/](https://commons.wikimedia.org/wiki/File:Raspberry_Pi_4.jpg) / [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0)
- [nicokaiser/rpi-audio-receiver @ github](https://github.com/nicokaiser/rpi-audio-receiver/blob/master/README.md) : I've tried it on my RPi 4 : althought it looks promising it doesn't work ootb
- [Turn Your Raspberry Pi Into a Wireless Portable Bluetooth Audio System A2DP](https://www.instructables.com/id/Turn-your-Raspberry-Pi-into-a-Portable-Bluetooth-A/)
- [How To Connect Bluetooth Headset Or Speaker To Raspberry Pi 3](http://youness.net/raspberry-pi/how-to-connect-bluetooth-headset-or-speaker-to-raspberry-pi-3)
