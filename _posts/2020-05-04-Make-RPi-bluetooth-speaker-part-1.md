---
title: Make a Raspberry Pi a Bluetooth speaker (part 1)
layout: post
tags:
  - raspberry pi
  - bluetooth
  - "Series : Make a Raspberry Pi a Bluetooth speaker"
maturity: draft
---

![Bluetooth logo](/assets/blog/3rdparty/logos/Bluetooth_FM_Color.png){:height="128px"}

In this two-part article I describe the steps I had to take to make a *headless Raspberry Pi 4* a Bluetooth [A2DP](https://www.howtogeek.com/338750/whats-the-difference-between-bluetooth-a2dp-and-aptx/) speaker.

My goal was to offer a user-friendly way for anyone in the same room to pair its Bluetooth smartphone with the Raspberry Pi and play music through it, while making sure the neighbors won't be able to connect without approval.

To output music, the Raspberry Pi audio Jack can simply be plugged into a Hi-Fi system or have an audio add-on card : this part depends on your setup and wishes.

Allright, let's dive into how Bluetooth works.

>*This is a two-part article :*
>1. *How Bluetooth pairing works (this part)*
>2. *Raspberry Pi as a Bluetooth A2DP receiver (soon available)*


## How Bluetooth pairing works

Bluetooth is quite a complex thing. Really. I didn't thought it was that much complicated before I started this mini project. Beside the original goal to be a wireless replacement for cables, Bluetooth actually includes [a myriad of features](https://en.wikipedia.org/wiki/Bluetooth#List_of_applications).
In order to understand how we should connect to our Raspberry Pi (abbreviated *RPi*), let's focus on some core aspects of Bluetooth.


### Bluetooth security models

Being tightly coupled with hardware, Bluetooth has evolved a lot since its beginnings, following industry's technical enhancements over the years.
This is why it has so many *security models* ; let's try to understand how they compare.


#### There are two distinct "families" of Bluetooth.

The legacy, **Basic Rate (BR)** was the first and only protocol in the beginning. It was quickly complemented with *EDR (Enhanced Data Rate)* in Bluetooth 2.0, hence the name **BR/EDR**.

Bluetooth 4.0 came with another protocol, with no backward compatibility : **Bluetooth Low Energy (abbreviated LE, or BLE)**. This new Bluetooth "family" requires less energy and fits better to smartphones and *IoT*.

Althought *BR/EDR* and *BLE* are not compatible, Bluetooth devices can implement one or the other, or even both. For the record there is also an *AMP* specification, usually implemented in a secondary controller, in order to achieve Wi-Fi class transfer rates.

Each protocol "family" have their own security and association models, even though they follow the same logic :

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
        passive eavesdropping and MITM protections,
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


#### Which security level to chose ?

The Bluetooth Core Specification[^1] makes it clear that :

> Secure Connections Only Mode is sometimes called a "FIPS Mode".
> This mode should be used when it is more important for a device to have high security than it is for it to maintain backwards compatibility with devices that do not support Secure Connections.

My feeling reading the specifications is that Bluetooth was not made with high expectations on security from the beginning. It has so many trade-offs at the benefit of usability that *Secure Connections*, whether for BR/EDR or LE, just looks to me like the bare minimum to have.

*BR/EDR Legacy Pairing*'s security for instance *unavoidably depends* on the length of the PIN (which is often a small four-digit number, or even a fixed value) and provide little-to-none protection against eavesdropping or man-in-the-middle (MITM) attacks.
*Secure Simple Pairing* for its part only *"protects the user from MITM attacks with a goal of offering a 1 in 1,000,000 chance that a MITM could mount a successful attack[^2]"*. It leverages the failure alerts end users would receive to mitigate the risk and allows for configurations that *may* make it unsecure.
Without going on with further examples : I just don't want my neighbors to accidentally connect to my RPi or any passing-by hacker to gather any personal information.

Also, "LE is the new BR/EDR". Most efforts seem to be put on Bluetooth LE and Bluetooh BR/EDR suffers from not being up-to-date with today's requirements. For instance : in BR/EDR, cryptographic key generation is being made in lower, often hardware, layers, making it difficult to upgrade security algorithms.
This is probably the fate of a very pragmatic specification that didn't intend to foresee the future of technology ; unfortunately this leaves us with a plethora of unsecure devices in the wild.

Wrapping up, this gives the "LE Secure Connections" mode my preference and I will try to make it rule my configuration.


### Bluetooth association models

The above diagram states that there are several *association models* ; here are the four ones that apply to *Bluetooth Low Energy* :

- **Numeric Comparison** (only since Bluetooth 4.2 for BLE)
- **Just Works**
- **Passkey entry**
- **Out-of-Band (OOB)**

For the sake of completeness we will also talk about :

- **BR/EDR Legacy pairing**

Let's see how they work, and how well they would fit our use case.


#### Numeric comparison

The Bluetooth Core Specification[^3] has a very neat way to describe the *Numeric Comparison* model :

> The user is shown a six digit number (from "000000" to "999999") on both
displays and then asked whether the numbers are the same on both devices. If
"yes" is entered on both devices, the pairing is successful.

It is important to understand that *this number is not chosen* by any party : it is randomly computed on each connection attempt, as part of the pairing algorithm[^4]. *It is not a passcode* either : it just helps users check that they pair to the expected device by showing the same value on both sides. If a malicious user were trying to penetrate our home he would just have to hit "Yes" on its side, whatever the value of this 6-digit number.

The *Numeric Comparison* protocol also allows devices to skip this user confirmation[^4] to automatically pair, but in order to preserve control over who can connect, we should not make this possible and enforce a confirmation on the RPi side.


#### Just works

The *Just Works* model is a specific case of *Numeric Comparison* designed for the case where at least one device in the pair has no human interface at all.
Therefore, it does not enforce any confirmation whatsoever.

Here is an excerpt from the specifications[^3] :

> The Just Works association model uses the Numeric Comparison protocol but
the user is never shown a number and the application may simply ask the user
to accept the connection (exact implementation is up to the end product
manufacturer).

As for *Numeric Comparison*, it looks like a good candidate for our use case, provided that we add a confirmation step as allowed.


#### Passkey Entry

*Passkey Entry* is used when one of the devices has input capabilities but no display (e.g. a keyboard).

A six-digit number is displayed on the device that can display and must be entered on the other one for the pairing to be successful.

At the difference of *Numeric Comparison*, this number is not only here to check that the devices are the ones we intend to pair, but it also serves as an input data *required* to authenticate and validate the association[^4] [^5].

In contrast with *Numeric Comparison*, this model does not allow automatic connection because each side has to prove they know the *passkey* :

- the *display device* is the only one to know the number in the beginning ; it decides the way the *passkey* is revealed to the other one
- the *input-only device* must enter the (supposedly secret) *passkey*

With some tweaks, a headless Raspberry Pi might be on one side or the other :

- if it were the *display device*, we should replace the display step with an equivalent, headless mechanism that allows the other user to obtain the number
- if it were the *input-only device*, we should find a way to get the number displayed on the other device entered into the RPi

This may not look trivial ; we'll see what can be done later on...


#### Out of Band (OOB)

With [Out of Band](https://www.bluetooth.com/blog/bluetooth-pairing-part-5-legacy-pairing-out-of-band/), the devices first discover (and optionally authenticate) themselves with a different mechanism than Bluetooth. It can be any protocol, like NFC or Wi-Fi for instance.

This fits well when both devices are known to share a common mechanism and are explicitly set up to work in this way. For instance a camera and its manufacturer's mobile application will both be programmed to connect with NFC first, then share their "services" through Bluetooth.

But this seemingly won't work for us, as we want to allow common smartphones - with only standard applications - to connect.
Furthermore, adding another mechanism than Bluetooth as a requirement looks superfluous...


#### BR/EDR models

The four previous models also apply to the BR/EDR side but with some subtle differences in their implementation, which we will not cover...

Finally, there is one more model that apply only to the BR/EDR family : **BR/EDR Legacy pairing**, which was the only association model before Bluetooth 2.1 (see the diagram above).

It requires the two devices to enter the same, 16-character maximum, secret PIN code.

Although it looks similar to *Passkey Entry*, it is far less secure because, here, the connection's encryption directly depends on the complexity of the PIN code.

What sounds like a practical idea that could be easily implemented on headless devices by simply setting up a static PIN code, unfortunately reveals to be largely unsecure, because the underlying cryptography is not strong enough to compensate weak/short/static/numeric only PIN codes that can be seen on many devices in the wild...

It is therefore not considered a potential solution in this article.

>TODO Compare the security of a four-digit vs a really long PIN code in this model vs in other models


### Choosing the right association model

I've chosen the three following factors to compare BLE association models regarding my use case :

1. Should not require complex user interaction on the Raspberry Pi's side (e.g. no SSH login to type a passkey)
2. Must be able to control who can connect to the Raspberry Pi (i.e. only known device or manually approved ones)
3. Secure enough (as much as Bluetooth can)

Let's summarize what we've asserted in the previous chapter :

|                                         |  Numeric comparison\* |  Just Works                        |  Passkey Entry |  Out of Band                       | BR/EDR Legacy Pairing |
|-----------------------------------------|---------------------|------------------------------------|----------------|------------------------------------|-----------------|
| No user interaction                     | no ❌                | yes ✅                              | no ❌          | assumed yes ✅         | yes ✅           |
| Control who can connect                 | no ❌                | no ❌                               | yes ✅         | assumed yes ✅                      | yes ✅           |
| Secure                                  | yes ✅               | yes ✅                             | yes ✅         | yes\*\* ✅ | no ❌            |

*\* without automatic pairing*
*\*\* even more than others[^6]*

This table shows, in a way, that authorization in Bluetooth expects either no approval or a manual one, which makes it hard to get good security with headless devices...

As discussed before, *Out of Band* is eliminated because it requires another protocol and *BR/EDR Legacy Pairing* is irrelevant for security reasons.

In order to get all three requirements met we therefore may use :

- **Just Works** with additional authorization
- **Numeric Comparison** with a headless validation step
- **Passkey Entry** with a headless mechanism to display and validate a 6-digit number

Unfortunately, except for *BR/EDR Legacy Pairing* **one cannot *choose* the association model : it is asserted from the devices' capabilities**, called [*Input and Output capabilities (IO capabilities)*](https://www.bluetooth.com/blog/bluetooth-pairing-part-1-pairing-feature-exchange/)[^7].

In order to make sure only approved workflows can be selected, our RPi device must therefore advertise only the matching IO capabilites.

How ? There are full-blown tables[^3] describing the available IO capabilities and the mapping to the matching association models.

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

Assuming smartphones would advertise themselves either as *DisplayYesNo* or *KeyboardDisplay* (highlighted cells), the above matrix shows that we should prepare to connect using any association model.

Additionally, this table emphasizes that **a device may enforce the *Just Works* model** simply by advertising itself as *NoInputNoOutput*. Although this makes it easier for the Industry to build devices with limited or no interface, this is also a leverage for pirates to force our system into a lower security.

We have the possibility to deny any pairing with the *Just Works* workflow, but this may prevent some genuine devices to connect : we should rather enforce a validation step. The main difference between "Just Works + validation" and other workflows would be the use of a custom authentication mechanism instead of a six-digit number verification.


### Putting it altogether with BlueZ

Now that we know *what* we should do in our solution, let's have an overiew of *how* to implement it.

Linux systems (which we will use for our Raspberry Pi) have a complex Bluetooth stack, but we will only need to focus on the following parts :

- the [BlueZ](http://www.bluez.org/) system daemon will handle core Bluetooth features
- modules will allow us to connect with specialized services : ALSA/PulseAudio in our case in order to receive and play sound from paired devices
- a registration **agent** will handle the pairing part as we like

Having the Bluez daemon and the audio modules work together is only a matter of configuration (which is already not trivial).

However I could not find a bluetooth agent matching my use case : the default agent [`bt-agent` has been deprecated](https://unix.stackexchange.com/questions/352494/alternative-to-the-now-deprecated-rfcomm-binary-in-bluez#463502) ; the `bluetoothctl` command is not really scriptable ; the quite common `simple-agent` sample script does not implement the right features.


#### Conclusion

Bluetooth does not provide a secure and automatic way to pair with headless devices out of the box.

The existence of several association models with complex selection rules make it easy to get it wrong.

We will use the *bluez* Linux stack to implement the basis of our solution and will need to create a custom agent to handle pairing in the exact way we want.

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
