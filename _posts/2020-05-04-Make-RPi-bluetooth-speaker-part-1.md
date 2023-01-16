---
title: Make a Raspberry Pi a Bluetooth speaker (part 1)
layout: post
tags:
  - raspberry pi
  - bluetooth
  - "Series : Make a Raspberry Pi a Bluetooth speaker"
maturity: good
last_modified_at: 2023-01-15
---

![Bluetooth logo](/assets/blog/3rdparty/logos/Bluetooth_FM_Color.png){:height="128px"}

In this two-part article I describe the steps I had to take to make a *headless Raspberry Pi 4* a Bluetooth [A2DP](https://www.howtogeek.com/338750/whats-the-difference-between-bluetooth-a2dp-and-aptx/) speaker.

My goal was to offer a user-friendly way for anyone in the same room to **pair its Bluetooth smartphone with the Raspberry Pi and play music through it**, while making sure the **neighbors won't be able to connect without approval**.

To output music, you can **connect a Hi-Fi system to the Raspberry Pi** using the Jack plug or an audio add-on card : this part depends on your setup.

{% plantuml %}
@startuml

!include <tupadr3/common>
!include <tupadr3/devicons/raspberry_pi>
!include <tupadr3/material/phone_android.puml>
!include <tupadr3/material/speaker.puml>

rectangle "Home <&home>" as Home {
  MATERIAL_PHONE_ANDROID(Guest,Guest smartphone)
  DEV_RASPBERRY_PI(RPi,Raspberry Pi)
  MATERIAL_SPEAKER(Speaker,Speaker)
}

RPi - Speaker : Audio cable
Guest .[#Blue].> RPi : Broadcasts music\nthrough Bluetooth A2DP <&bluetooth>

@enduml
{% endplantuml %}

Allright, let's dive into how Bluetooth works.

>*This is a two-part article :*
>1. *How Bluetooth pairing works (this part)*
>2. *Raspberry Pi as a Bluetooth A2DP receiver (soon available)*


## How Bluetooth pairing works

Bluetooth is quite a complex thing. Really. I haven't realized before I started this mini project. Beside its original goal to be a wireless replacement for cables, Bluetooth actually includes [a myriad of features](https://en.wikipedia.org/wiki/Bluetooth#List_of_applications).

In order to understand how we should connect to our Raspberry Pi (*RPi*), let's focus on some core aspects of Bluetooth.


### Bluetooth security models

Being tightly coupled with hardware, Bluetooth has evolved a lot since its beginnings, following industry's technical enhancements over the years.
This is why it has so many *security models* ; let's try to understand how they compare.


#### There are two distinct "branches" in Bluetooth.

The legacy Bluetooth branch, **"Basic Rate" (BR)** was the first and only protocol in the beginning. It was quickly complemented with *EDR (Enhanced Data Rate)* in Bluetooth 2.0, hence the name **BR/EDR**.

Bluetooth 4.0 introduced another, not backward-compatible protocol  : **"Bluetooth Low Energy" (abbreviated LE, or BLE)**. This new Bluetooth "branch" requires less energy and fits smartphones and *IoT* better.

Althought *BR/EDR* and *BLE* are not compatible with each other, Bluetooth devices can actually implement both.

For the record there is also an additional "AMP" specification to achieve Wi-Fi class transfer rates, usually implemented by a secondary electronic chip.

Each branch has its own security and association models, even though they all follow the same logic :

{% plantuml %}
@startuml

title
    Bluetooth association models & security history
end title

(BR/EDR Legacy Pairing) as bredr_legacy_pairing
    note right of bredr_legacy_pairing
        Since the beginning

        Lowest security (based on SAFER+ algorithms)
        There is only **one pairing workflow**.
    end note
(Secure Simple Pairing) as secure_simple_pairing
    note right of secure_simple_pairing
        Since 2.1 + EDR

        Enhances security with stronger (FIPS) algorithms,
        passive eavesdropping & MITM protections,
        and **4 possible pairing workflows**.
        Some security is still at the level of <i>BR/EDR legacy</i>.
    end note
(BR/EDR Secure Connections) as bredr_legacy_secure_connections
    note right of bredr_legacy_secure_connections
        Since 4.1

        Fills the remaining security gaps.
    end note
(LE Legacy Pairing) as le_legacy_pairing
    note left of le_legacy_pairing
        Since 4.0

        Similar to BR/EDR's <i>Secure Simple Pairing</i>
        but with only **3 pairing workflows**
        (misses <i>Numeric Comparison</i>)
        and trades some security for usability.
    end note
(LE Secure Connections) as le_secure_connections
    note left of le_secure_connections
        Since 4.2

        Similar to <i>BR/EDR Secure Connections</i>,
        with the same **4 pairing workflows**.
    end note

bredr_legacy_pairing -up-> secure_simple_pairing
secure_simple_pairing -up-> bredr_legacy_secure_connections : Security upgrade through\n<i>Secure Connections</i>
le_legacy_pairing -up-> le_secure_connections : Security upgrade through\n<i>Secure Connections</i>

@enduml
{% endplantuml %}


#### Which security level to choose ?

The Bluetooth Core Specification[^1] makes it clear that :

> Secure Connections Only Mode is sometimes called a "FIPS Mode".
> This mode should be used when it is more important for a device to have high security than it is for it to maintain backwards compatibility with devices that do not support Secure Connections.

My feeling reading the specifications is that Bluetooth was not made with high expectations on security from the beginning. It has so many trade-offs at the benefit of usability that *Secure Connections*, whether for BR/EDR or LE, just looks to me like the bare minimum to have.

*BR/EDR Legacy Pairing*'s security for instance *unavoidably depends* on the length of the PIN (which is often a small four-digit number, or even a fixed value) and provide little-to-none protection against [eavesdropping](https://en.wikipedia.org/wiki/Eavesdropping) or [man-in-the-middle (MITM) attacks](https://en.wikipedia.org/wiki/Man-in-the-middle_attack).
*Secure Simple Pairing* for its part only *"protects the user from MITM attacks with a goal of offering a 1 in 1,000,000 chance that a MITM could mount a successful attack[^2]"*. **It strongly relies on human decision (based on warning messages in case of an attack) to mitigate risks and allows for configurations that *can* make it unsecure**.
In short, it's easy to configure it wrong and let the neighbors accidentally connect to your Bluetooth device and maybe gather personal informations.

Also, "LE is the new BR/EDR". Indeed, most efforts seem to be put on Bluetooth LE as Bluetooh BR/EDR lacks behind, not keeping up with today's requirements. For instance : with BR/EDR, cryptographic key generation is being made in lower, often hardware, layers, making it difficult to upgrade security algorithms.
**This leaves us with a plethora of insecure devices in the wild.**

**👉 Wrapping up, this gives the "LE Secure Connections" mode my preference.**


### Bluetooth association models

As advertised in the above diagram, each security model allows a number of *association models*.
There are four of them available since *Secure Simple Pairing* :

- **Numeric Comparison** (since Bluetooth 4.2 for BLE)
- **Just Works**
- **Passkey entry**
- **Out-of-Band (OOB)**

For the sake of completeness we will also talk about **BR/EDR Legacy pairing**.

Let's see how they work, and how well they would fit our use case.


#### Numeric comparison

The Bluetooth Core Specification[^3] has a very neat way to describe the *Numeric Comparison* model :

> The user is shown a six digit number (from "000000" to "999999") on both
displays and then asked whether the numbers are the same on both devices. If
"yes" is entered on both devices, the pairing is successful.

It is important to understand that *this number is not chosen* by any party : it is randomly computed on each connection attempt, as part of the pairing algorithm[^4]. *It is not a passcode* either : it just helps users check that they pair to the expected device by showing the same value on both sides. A malicious user trying to penetrate our home would just have to initiate pairing, hit "Yes" on its side and hope we would do the same, not really looking at the number.

The *Numeric Comparison* protocol also allows devices to skip user confirmation[^4], implementing automatic pairing. In this case anyone within reach of such a device can connect. End.

As we'll see later, you may not have a choice and be forced into a model due to devices limitations. In our case we will need to make sure the Raspberry Pi will not offer this kind of bypass.


#### Just works

The *Just Works* model is a specific case of *Numeric Comparison* designed for the case where at least one device in the pair has no human interface at all.
Therefore, it does not enforce any confirmation whatsoever.

Here is an excerpt from the specifications[^3] :

> The Just Works association model uses the Numeric Comparison protocol but
the user is never shown a number and the application may simply ask the user
to accept the connection (exact implementation is up to the end product
manufacturer).

As for *Numeric Comparison*, it may still be a good candidate for our use case, provided that we add a mandatory confirmation step, as allowed.


#### Passkey Entry

*Passkey Entry* is used when one of the devices has input capabilities but no display (e.g. a keyboard).

A six-digit number is displayed on the device that can display and must be entered on the other one for the pairing to be successful.

At the difference of *Numeric Comparison*, this number is not only here to check that the devices are the ones we intend to pair, but it also serves as an input data *required* to authenticate and validate the association[^4] [^5].

In contrast with *Numeric Comparison*, this model does not allow automatic connection because each side has to prove they know the *passkey* :

- the *display device* is the only one to know the number in the beginning ; it decides the way the *passkey* is revealed to the other one
- the *input-only device* must enter the (supposedly secret) *passkey*

In the case of a headless Raspberry Pi :

- if it were the *display device*, we could plug a mini display on it, or make it *speak* the code through the Hi-Fi system, to provide it to the user
- if it were the *input-only device*, we should find a way to get the number displayed on the other device entered into the RPi (maybe letting the user type it)

This may not look trivial ; we'll see what can be done later on...


#### Out of Band (OOB)

With [Out of Band](https://www.bluetooth.com/blog/bluetooth-pairing-part-5-legacy-pairing-out-of-band/), the devices first discover (and optionally authenticate) themselves with a different mechanism than Bluetooth. It can be any protocol, like NFC or Wi-Fi for instance.

This fits well when both devices are known to share a common mechanism and are explicitly set up to work in this way. For instance a camera and its manufacturer's mobile application will both be programmed to connect with NFC first, then share their "services" through Bluetooth.

But this does not fit our use case, as we want to allow most smartphones - with only standard applications - to connect.
Furthermore, we want to leverage on existing Bluetooth capabilites, not invent new ones...


#### BR/EDR models

The four previous models also apply to the BR/EDR side, with some subtle differences in their implementation (not covered here)...

The last model, **BR/EDR Legacy pairing**, only applies to BR/EDR. It is outdated but was the only association model before Bluetooth 2.1 and therefore is very probably still there because of older devices.

It requires the two devices to enter the same, 16-character maximum, secret PIN code.

Although it looks similar to *Passkey Entry*, it is far less secure because, here, the connection's encryption directly depends on the complexity of the PIN. [Nowadays, passwords less than 7 characters (including special ones) can be cracked instantly, it requires a maximum of 4 hours and 100$ for a 16-*digit* PIN](https://thesecurityfactory.be/password-cracking-speed/)...

What sounds like a practical idea to implement on headless devices with a static PIN, unfortunately reveals to be largely insecure. The underlying cryptography is just not strong enough to compensate weak PIN codes that have been hardcoded on existing devices...

It is therefore not considered a potential solution in this article.


### Choosing the right association model

I've chosen the three following factors to compare BLE association models regarding my use case :

1. User authentication but with simple interaction (e.g. no SSH login to type a passkey)
2. Must be able to control who can connect to the Raspberry Pi (i.e. only known device or manually approved ones)
3. Secure enough (as much as Bluetooth can)

Let's summarize what we've asserted in the previous chapter :

|-----------------------------+--------------------------+---------------+----------------------------+---------------+-----------------------|
|                             |  Numeric comparison\*    |  Just Works   |  Passkey Entry             |  Out of Band  | BR/EDR Legacy Pairing |
|-----------------------------|--------------------------|---------------|----------------------------|---------------|-----------------------|
| User interaction needed     | yes ✅                   | no ❌         | yes ✅                     | possible ✅   | yes ✅                |
| Control who can connect     | no ❌<br>(random number) | no ❌         | yes ✅<br>(shared passkey) | possible ✅   | yes ✅                |
| Secure-enough protocol      | yes ✅                   | yes ✅        | yes ✅                     | yes\*\* ✅    | no ❌                 |
|-----------------------------+--------------------------+---------------+----------------------------+---------------+-----------------------|

*\* without automatic pairing*
*\*\* possibly more than others[^6]*

This tables depicts the fact that the only way to *control who can connect* is by requiring the user to enter some - not random - key. Cells indicating "no user interaction" imply that there is no approval.

As discussed before, *Out of Band* is eliminated because it requires an additional protocol and *BR/EDR Legacy Pairing* is irrelevant for security reasons.

👉 In order to get all our three requirements statisfied we may therefore use :

- **Numeric Comparison, but with a custom headless validation step**
- **Just Works, but with additional custom authorization**
- **Passkey Entry** by implementing a headless mechanism to display and validate a 6-digit number

Unfortunately, except for *BR/EDR Legacy Pairing* **one cannot directly *choose* the association model : it is automatically asserted from the devices' [*Input and Output capabilities (IO capabilities)*](https://www.bluetooth.com/blog/bluetooth-pairing-part-1-pairing-feature-exchange/)[^7]**.

In order to make sure only approved workflows can be used, our RPi device must therefore advertise only the corresponding IO capabilites.

How ? There are full-blown tables[^3] mapping the available IO capabilities to the matching association models.

The **input capabilites** are :
- **No input** : Device does not have the ability to indicate 'yes' or 'no'
- **Yes / No** : Device provides the user a way to indicate either 'yes' or 'no'
- **Keyboard** : Device allows the user to input numbers *and* to indicate 'yes' or 'no'

And the **output capabilities** are :
- **No output** : Device does not have the ability to display or communicate a
6 digit decimal number
- **Numeric output** : Device has the ability to display or communicate a 6 digit decimal number

Here is an overview of the **IO capabilities mapping to the matching association models** :

<table>
    <caption>Mapping of IO capabilities to key generation method (simplified)</caption>
    <colgroup>
        <col class="col-header" />
        <col class="col-header" />
    </colgroup>
    <tr>
        <td colspan="2" class="empty"/>
        <th colspan="5">Device A (Initiator)</th>
    </tr>
    <tr>
        <td colspan="2" class="empty"/>
        <th>
            Display Only                        <br><span class="small">
            (No input + Numeric output)         </span></th>
        <th class="cell-selected">
            Display YesNo                        <br><span class="small">
            (Yes/No + Numeric output)           </span></th>
        <th>
            Keyboard Only                        <br><span class="small">
            (Keyboard + No output)              </span></th>
        <th class="cell-noinputnooutput">
            NoInput NoOutput                     <br><span class="small">
            (No input or Yes/No + No output)       </span></th>
        <th class="cell-selected">
            Keyboard Display                     <br><span class="small">
            (Keyboard + Numeric output)         </span></th>
    </tr>
    <!-- Row for DisplayOnly -->
    <tr>
        <th class="vertical" rowspan="5"><span>Device B (Responder)</span></th>
        <th class="vertical"><span>Display Only</span></th>
        <td>Just Works</td>
        <td class="cell-selected">Just Works</td>
        <td>Passkey Entry : responder displays, initiator inputs</td>
        <td class="cell-noinputnooutput">Just Works</td>
        <td class="cell-selected">Passkey Entry : responder displays, initiator inputs</td>
    </tr>
    <!-- Row for DisplayYesNo -->
    <tr>
        <th class="vertical"><span>Display YesNo</span></th>
        <td>Just Works</td>
        <td class="cell-selected">Numeric Comparison</td>
        <td>Passkey Entry : responder displays, initiator inputs</td>
        <td class="cell-noinputnooutput">Just Works</td>
        <td class="cell-selected">Numeric Comparison</td>
    </tr>
    <!-- Row for KeyboardOnly -->
    <tr>
        <th class="vertical"><span>Keyboard Only</span></th>
        <td>Passkey Entry: initiator displays, responder inputs</td>
        <td class="cell-selected">Passkey Entry: initiator displays, responder inputs</td>
        <td>Passkey Entry: both input</td>
        <td class="cell-noinputnooutput">Just Works</td>
        <td class="cell-selected">Passkey Entry: initiator displays, responder inputs</td>
    </tr>
    <!-- Row for NoInputNoOutput -->
    <tr>
        <th class="vertical"><span>NoInput NoOutput</span></th>
        <td class="cell-noinputnooutput">Just Works</td>
        <td class="cell-selected cell-noinputnooutput">Just Works</td>
        <td class="cell-noinputnooutput">Just Works</td>
        <td class="cell-noinputnooutput">Just Works</td>
        <td class="cell-selected cell-noinputnooutput">Just Works</td>
    </tr>
    <!-- Row for KeyboardDisplay -->
    <tr>
        <th class="vertical"><span>Keyboard Display</span></th>
        <td>Passkey Entry: initiator displays, responder inputs</td>
        <td class="cell-selected">Numeric Comparison</td>
        <td>Passkey Entry: responder displays, initiator inputs</td>
        <td class="cell-noinputnooutput">Just Works</td>
        <td class="cell-selected">Numeric Comparison</td>
    </tr>
</table>
*Source : Mapping of IO capabilities to key generation method[^7] (without OOB nor LE Legacy Pairing)*

Assuming smartphones would advertise themselves either as *DisplayYesNo* or *KeyboardDisplay* (highlighted cells), the above matrix shows that we should prepare to connect using any association model of "Numeric Comparison", "Just works" or "Passkey entry".

Additionally, this table emphasizes that **a device may enforce the *Just Works* model** simply by advertising itself as *NoInputNoOutput*. Although this makes it easier for the Industry to build devices with limited or no interface, this is also a leverage for pirates ☠ to force our system into a lower security.

We have the possibility to deny any pairing in the *Just Works* workflow, but this may prevent some genuine devices to connect : we should rather enforce a validation step. The main difference between "Just Works + validation" and other workflows would be the use of a custom authentication mechanism instead of a six-digit number verification.


### Putting it altogether with BlueZ

Now that we know *what* we should do in our solution, let's have an overiew of *how* to implement it.

Linux systems (which we will use for our Raspberry Pi) have a complex Bluetooth stack, but we will only need to focus on the following parts :

- the [BlueZ](http://www.bluez.org/) system daemon will handle core Bluetooth features
- modules will allow us to connect with specialized services : ALSA/PulseAudio in our case in order to receive and play sound from paired devices
- a registration **agent** will handle the pairing part as we like **=> this is where we will put any custom authorization step**

Having the Bluez daemon and the audio modules work together is only a matter of configuration (which is already not trivial).

However I could not find a bluetooth agent matching my use case :
- the default agent [`bt-agent` has been deprecated](https://unix.stackexchange.com/questions/352494/alternative-to-the-now-deprecated-rfcomm-binary-in-bluez#463502)
- the `bluetoothctl` command cannot easily be used in scripts
- the quite common `simple-agent` sample script does not implement the right features...


#### Conclusion

Bluetooth does not provide a secure and automatic way to pair with headless devices out of the box.

The existence of several association models with complex selection rules make it easy to get it wrong.

We will use the *bluez* Linux stack to implement the basis of our solution and will need to create a custom agent to add secure-enough authorization to the existing pairing workflows.

**Part 1 is over, let's see how to set up the whole thing in part 2 : "Raspberry Pi as a Bluetooth A2DP receiver" (soon available).**


## References

- Top illustration : [Bluetooth.svg by Skarr21](https://commons.wikimedia.org/wiki/File:Bluetooth_FM_Color.png) / [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0)
- [Bluetooth Pairing Part 1 – Pairing Feature Exchange](https://www.bluetooth.com/blog/bluetooth-pairing-part-1-pairing-feature-exchange/)
- [Bluetooth Pairing Part 2 Key Generation Methods](https://www.bluetooth.com/blog/bluetooth-pairing-part-2-key-generation-methods/)
- [Bluetooth Pairing Part 3 – Low Energy Legacy Pairing Passkey Entry](https://www.bluetooth.com/blog/bluetooth-pairing-passkey-entry/?utm_campaign=developer&utm_source=internal&utm_medium=blog&utm_content=bluetooth-pairing-part-4-LE-secure-connections-numeric-comparison)
- [Bluetooth Pairing Part 4: Bluetooth Low Energy Secure Connections – Numeric Comparison](https://www.bluetooth.com/blog/bluetooth-pairing-part-4/?utm_campaign=developer&utm_source=internal&utm_medium=blog&utm_content=bluetooth-pairing-part-3-low-energy-legacy-pairing-passkey-entry)
- [Bluetooth Core Specification v5.2](https://www.bluetooth.com/specifications/bluetooth-core-specification/)
- [en.wikipedia.org/wiki/Bluetooth](https://en.wikipedia.org/wiki/Bluetooth#Pairing_and_bonding), 2020-04-10

### Bluetooth Core specification inline references

[^1]: Bluetooth Core specification Vol 1, Part A, §5.3 "SECURE CONNECTIONS ONLY MODE"
[^2]: Bluetooth Core specification Vol 1, Part A, §5.2 "BR/EDR SECURE SIMPLE PAIRING"
[^3]: Bluetooth Core specification Vol 3, Part C, §5.2.2.4 "IO capabilities"
[^4]: Bluetooth Core specification Vol 2, Part F, §4.2 "SIMPLE PAIRING MESSAGE SEQUENCE CHARTS"
[^5]: Bluetooth Core specification Vol 2, Part H, §7.2.3 "Authentication stage 1: Passkey Entry protocol"
[^6]: Bluetooth Core specification Vol 3, Part H, §2.3.5.4 "Out of band"
[^7]: Bluetooth Core specification Vol 3, Part H, §2.3.2 "IO capabilities"
