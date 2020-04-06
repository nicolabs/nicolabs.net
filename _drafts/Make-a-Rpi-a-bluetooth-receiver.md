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

More precisely, the goal is to allow user friendly pairing for anyone in the room with a Bluetooth smartphone, while making sure the neighbors won't be able to connect without approval.

## How BlueZ pairing works

Bluetooth is quite a complicated thing. Really. I didn't thought it would be that complicated when I started this mini project.
Let's dive a little bit into the way it works.

First, the following pairing workflows (or *association models*) [are available for Bluetooth Low Energy](https://www.bluetooth.com/blog/bluetooth-pairing-part-2-key-generation-methods/) compatible devices :

- Just Works
- Passkey entry
- Out-of-Band (OOB)
- Numeric Comparison

*Numeric comparison* exists since Bluetooth 4.2 (as part of *Bluetooth LE Secure Connection* specification) ; the others are available for all devices implementing *Bluetooth LE Legacy Pairing* (Bluetooth 4.0).

TODO What about the pre BT 4.0 (PIN, etc.)?

Unfortunately, the devices cannot choose the association model by themselves : it is [deduced from the devices *input and output capabilities*](https://www.bluetooth.com/blog/bluetooth-pairing-part-1-pairing-feature-exchange/).
In order to make sure only workflows compatible with our headless use case are enabled, our RPi device must therefore advertise only the matching *IO capabilites*.

Here is a short description of the available IO capabilities, taken from the core Bluetooth specification (Vol 3, Part C, §5.2.2.4 "IO capabilities").

Input capabilites :
- **No input** : Device does not have the ability to indicate 'yes' or 'no'
- **Yes / No** : Device provides the user a way to indicate either 'yes' or 'no'
- **Keyboard** : Device allows the user to input numbers to indicate 'yes' or 'no'

Output capabilities :
- **No output** : Device does not have the ability to display or communicate a
6 digit decimal number
- **Numeric output** : Device has the ability to display or communicate a 6 digit decimal number

<table>
    <caption>IO capability mapping to authentication stage 1</caption>
    <colgroup>
        <col class="col-header" />
        <col class="col-header" />
    </colgroup>
    <tr>
        <td colspan="2" class="empty"/>
        <th colspan="4">Device A (Initiator)</th>
    </tr>
    <tr>
        <td colspan="2" class="empty"/>
        <th>Display Only</th>
        <th>DisplayYesNo</th>
        <th>KeyboardOnly</th>
        <th>NoInputNoOutput</th>
    </tr>
    <tr>
        <th class="vertical" rowspan="4"><span>Device B (Responder)</span></th>
        <th class="vertical"><span>DisplayOnly</span></th>
        <td>Numeric Comparison with automatic confirmation on both devices.<br/><br/>Unauthenticated</td>
        <td>Numeric Comparison with automatic confirmation on device B only.<br/><br/>Unauthenticated</td>
        <td>Passkey Entry: Responder Display, Initiator Input.<br/><br/>Authenticated</td>
        <td>Numeric Comparison with automatic confirmation on both devices.<br/><br/>Unauthenticated</td>
    </tr>
    <tr>
        <th class="vertical"><span>DisplayYesNo</span></th>
        <td>Numeric Comparison with automatic confirmation on device A only.<br/><br/>Unauthenticated</td>
        <td>Numeric
Comparison: Both Display, Both Confirm.<br/><br/>Authenticated</td>
        <td>Passkey Entry: Responder Display, Initiator Input.<br/><br/>Authenticated</td>
        <td>Numeric Comparison with automatic confirmation on device A only and Yes/No confirmation whether to pair on device B.<br/>Device B does not show the confirmation value.<br/><br/>Unauthenticated</td>
    </tr>
    <tr>
        <th class="vertical"><span>KeyboardOnly</span></th>
        <td>Passkey Entry: Initiator Display, Responder Input.<br/><br/>Authenticated</td>
        <td>Passkey Entry: Initiator Display, Responder Input.<br/><br/>Authenticated</td>
        <td>Passkey Entry: Initiator and Responder Input.<br/><br/>Authenticated</td>
        <td>Numeric Comparison with automatic confirmation on both devices.<br/><br/>Unauthenticated</td>
    </tr>
    <tr>
        <th class="vertical"><span>NoInputNoOutput</span></th>
        <td>Numeric Comparison with automatic confirmation on both devices.<br/><br/>Unauthenticated</td>
        <td>Numeric Comparison with automatic confirmation on device B only and Yes/No confirmation on whether to pair on device A.<br/>Device A does not show the confirmation value.<br/><br/>Unauthenticated</td>
        <td>Numeric Comparison with automatic confirmation on both devices.<br/><br/>Unauthenticated</td>
        <td>Numeric Comparison with automatic confirmation on both devices.<br/><br/>Unauthenticated</td>
    </tr>
</table>

Finally, Linux systems have a complex Bluetooth stack, from which we will focus on the following components :

- a system daemon (from BlueZ implementation) handling the core Bluetooth stack
- modules to connect with specialized services (we will use ALSA/PulseAudio in order to receive sound from paired devices)
- registration agents, handling devices pairing in *our* headless-way

The Bluez daemon and the audio modules will only need to be configured correctly (which is already not trivial).
However I could not find a bluetooth agent matching my use case : the default agent has been deprecated ; the `bluetoothctl` command is not scriptable ; the `simple-agent` sample script does not implement the right capabilities. Some agent implementations I found around seemed to do the job but their code was not clear enough so while I introspected them to understand what they were doing and why, I ended up writing a new one, matching my use case.

Now let's identify which association model(s) fits our use case.

### Association models

#### Just works

This association mode has been thought when at least one device in the pair has no human interface.
Therefore, it does not enforce any confirmation whatsoever.

The Bluetooth Core Specification has a very neat way to describe it :
> The Just Works association model uses the Numeric Comparison protocol but
the user is never shown a number and the application may simply ask the user
to accept the connection (exact implementation is up to the end product
manufacturer).

If a *Just Works* model is triggered, the bluetooth agent may automatically pair with devices without a confirmation, or it may ask by some "headless" way a confirmation.
In the first case, although data exchange can be strongly secured, it cannot prevent an unknown device to pair.
In the latter case, it may require a fair amount of work to build such a confirmation mechanism.

Depending on the capabilities the *agent* declared, it may never be called in this association model.

#### Conclusion

The Bluetooth specifications don't provide a secure way use a fixed PIN code for headless devices.
A headless device may then adopt one of the following options :

- simply allow any device to connect ; data exchanges can still be secured, but will not protect against a MITM attack
- use a program (a *bot* actually) to simulate a user input, making sure no random number would need to be input
- develop advanced headless inputs (like audio speak / voice recognition)
- leverage on Out-of-Band protocol ?



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
- [Bluetooth Pairing Part 1 – Pairing Feature Exchange](https://www.bluetooth.com/blog/bluetooth-pairing-part-1-pairing-feature-exchange/)
- [Bluetooth Pairing Part 2 Key Generation Methods](https://www.bluetooth.com/blog/bluetooth-pairing-part-2-key-generation-methods/)
- [Bluetooth Pairing Part 3 – Low Energy Legacy Pairing Passkey Entry](https://www.bluetooth.com/blog/bluetooth-pairing-passkey-entry/?utm_campaign=developer&utm_source=internal&utm_medium=blog&utm_content=bluetooth-pairing-part-4-LE-secure-connections-numeric-comparison)
- [Bluetooth Pairing Part 4: Bluetooth Low Energy Secure Connections – Numeric Comparison](https://www.bluetooth.com/blog/bluetooth-pairing-part-4/?utm_campaign=developer&utm_source=internal&utm_medium=blog&utm_content=bluetooth-pairing-part-3-low-energy-legacy-pairing-passkey-entry)
- [Bluetooth Core Specification v5.2](https://www.bluetooth.com/specifications/bluetooth-core-specification/)
