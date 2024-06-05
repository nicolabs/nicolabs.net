---
title: Introduction to Home Automation
layout: post
tags:
  - smart home
  - home-assistant
  - zigbee
  - mqtt
  - IoT
maturity: draft
---

Recently, I have been looking for a way to measure the typical energy consumption of the electric equipments I have at home.
I only wanted to buy a simple plug-in energy monitor but I ended up spending several days to understand what were the possible options (and about 6 more hours to write this article...) !

Here is what I've learned.


## The watt-meter buying guide

What you need to measure electric power consumption is called a *watt-meter*.
Depending on what kind of equipment you want to monitor, there are different form factors.


### Clamp

A *clamp meter*[^clamp-meter] is simply closed around the *phase wire* you want to measure.
Therefore it can only be used when you have the phase wire apart, not for molded cables.
Still, it seems to be a very versatile tool and you may build a custom extension cord with a separate phase wire to make it work with any plugable electric device.

### Electric plug

A power meter in the form of a *plug*[^power-plug] is probably the most convenient device to measure the consumption of individual electrical devices.
You just put it between the mains and the device's plug.

Make sure to check what is the maximum power supported ; a lot of devices are not able to measure high power equipments like ovens for instance.

### Home power supply

There are also monitors made as modules to plug into the home power supply panel[^shelly], or interfacing with a dedicated connection[^zlinky] or even by hacking the visual signals of the home energy counter.

Many power companies nowadays have them installed by default, so you may just need to request access to your dashboard.

This kind of monitor allows to follow the power consumption of the whole house or a given circuit.

### Smart meters

Although you will find those devices with embedded screens and keypad to monitor the power consumption, most of the stores just don't describe if they keep an history of the measures, during how long and at what pace.
It is also almost impossible to know, before buying, if / how to download the data to a computer, and in which format.

Electric plugs and power supply monitors also exist as so-called "smart"[^nous-plug], reporting to a central "smart home gateway".
As far as I've seen, there are no "smart" clamps.


### Conclusion

If you want to get a detailed overview of your home consumption, you will probably need several kind of power meters.

**For my "simple" needs, I decided to monitor the global consumption of the house by the means of my power provider, and one or few plugs that I could move from one device to another, in order to drill down to the individual suspects[^hass-energy-full-approach].**

Since I was not confident *at all* that I could extract the data from any autonomous watt-meter to Linux out of the box, I chose to buy smart plugs instead.
Even though it requires an additional infrastructure (the gateway, a local network, a computer to exploit the measures), the ones I chose makes use of open protocols, which I consider more durable.

Reminder of the attention points, in short :
- form factor
- maximum power supported
- history keeping and extraction
- protocol / standard (for smart meters)



## Standards, in short

[![xkcd : How standards proliferate](https://imgs.xkcd.com/comics/standards.png)](https://xkcd.com/927)


### Zigbee

[Zigbee](https://csa-iot.org/all-solutions/zigbee/) is currently the most widespread *open* standard communication protocol.
It works on specific radio frequencies and therefore, **as most home automation protocols, requires physical devices with the right radio hardware.**
As most home automation network protocols, it's made to be low-energy.


Devices are nodes in a *mesh network* : they act as repeaters ("routers" is the term) in order to extend the network (well, most mains-powered devices do).
Within all devices, there must be one with *coordinator* capabilities to orchestrate all others.
This coordinator may be an all-in-one appliance (often a 'gateway' implementing other protocols as well) or an extension to an existing machine (for instance an USB dongle with zigbee chipsets & radio antenna).

One thing to notice : zigbee devices may use the [same radio bandwidth as Wi-Fi](https://www.metageek.com/training/resources/zigbee-wifi-coexistence/) and Bluetooth (2.4 GHz) and therefore you may need to [take care of interferences](https://community.home-assistant.io/t/zigbee-networks-how-to-guide-for-avoiding-interference-optimizing-using-zigbee-router-devices-repeaters-extenders-to-get-best-possible-range-and-coverage/515752).

**For the sake of clarity : I've chosen Zigbee for my own installation so other protocols are not detailed as much.**


### Z-Wave

In short, [Z-wave](https://z-wavealliance.org/) is the ancestor of Zigbee.
Overall it is almost as much efficient, but has a few more limits like a maximum network depth and number of devices ([maximum 4 hops and 232 devices](https://www.spiceworks.com/tech/iot/articles/zigbee-vs-z-wave/) - which is probably enough for a smart home but maybe not for industrial use cases).

The historic driver to invent Zigbee was apparently the fact that Z-Wave is a proprietary protocol (read : it has fees).


### Matter

[Matter](https://csa-iot.org/all-solutions/matter/) is new.
But does not really bring any novelty.

Matter simply aims to provide users with a single protocol for all their smart home devices, and is compatible with existing protocols.

It is announced as a marketing success because of the participation (takeover ?) of major mass market industry players like Google, Samsung, Amazon, Apple.
As I write this article there are still NOT a lot of compatible devices : think twice if you have existing devices or need to build something up quickly.


### IO and RTS

[IO](https://www.somfy.co.uk/about-somfy/brand-partners-and-compatibilities/technologies-and-protocols) is a proprietary protocol by Somfy.
You will get it with professional-grade shutters for instance.

It is considered higher-grade than [RTS](https://www.somfy.co.uk/about-somfy/brand-partners-and-compatibilities/technologies-and-protocols), another Somfy proprietary protocol.
One difference is that RTS devices do not provide feedback about their state while IO does (e.g. is the shutters closed, closing, etc.).

While *IO* is newer and requires an expensive proprietary gateway, [*RTS* has been reverse-engineered](https://somfy-rts.readthedocs.io/en/latest/) and open source components now exist.

Unfortunately, Somfy pushes towards IO products by deprecating others, and all IO gateways require Internet access at least to configure them.
With this kind of product you will absolutely depend on the vendor's will to support it (except if you are an electronics-ninja to build your own, using spare Somfy remotes).

Nowadays the only two available gateways for IO are the *connectivity kit* (costs ~70€), which is fully orchestrated through Somfy's Internet services, or the full *Tahoma Switch* gateway (~200€), which absolutely needs Somfy's web services at least each time you need to configure it.


### Wi-Fi and Bluetooth

**Wi-Fi** is also used for many smart devices in the mass market.
This works, from a business point of view, because most customers already have a Wi-Fi router, releasing them from having to buy a gateway.

**However** this is a quite [power-consuming](https://www.smarthomepoint.com/zigbee-zwave-wifi-bluetooth-comparison/) protocol, which does not really makes sense when you have many devices running all the time, and even less if you do this in order to fine tune your power usage !

**Bluetooth** consumes a bit less energy and Bluetooth Low Energy (BLE) even more, so it might compete with home automation dedicated protocols, but I have only found few smart meters with bluetooth support...


### Zigbee2MQTT

[Zigbee2MQTT](https://www.zigbee2mqtt.io/) is not a *real* home automation protocol, but is a complementary tool.

It simply exports metrics from Zigbee devices to a MQTT server[^mosquitto].
[MQTT](https://mqtt.org/) is a very efficient publish/subscribe protocol for IoT.
It is very well known in the IoT world so you will probably come across it.

Apart from the technical differences in the protocols, it is known that Zigbee2MQTT exports more metrics and is faster that native Zigbee plugins/vendors to support new devices.
So if you need to get all the potential of your devices and can afford installing an additional server, this may be a good choice to run this *Zigbee-to-MQTT bridge*.



\
There are even more protocols (Thread, Tuya, ...) that I don't have time to investigate...




## Vendor lock-in

Referring to the Somfy example above, I want to demonstrate how much this lock-in trend is ridiculously...

[This thread on Somfy's french forum](https://forum.somfy.fr/questions/3313144-tahoma-switch-deja-connectee-compte-remedier) shows many people having bought a gateway from Somfy being forced to ask for the helpdesk to unlock it remotely !

[In the following french thread](https://forum.somfy.fr/questions/1510502-fonctionnement-tahoma-internet) someone from Somfy customer support even justify the need for Internet (and their web services) saying that every vendor does the same and it is a marketing choice :

> Je vous informe qu'il s'agit du fonctionnement de notre domotique comme la grande majorité des systèmes de domotique, il s'agit d'un choix marketing dont il n'est pas prévu à l'heure actuel que ça change.

**Think about it.**

**Internet. Is. Required. To. OPEN YOUR SHUTTERS !**

**Because. Of. A MARKETING CHOICE !**

Although some people in the same forum thread seem to think that 'Somfy will always be there 🥰', it is obvious that it is not true and that a company acting this way will eventually end up making choice against the user's interest (you can easily find [dozens of big companies](https://www.businessinsider.com/tech-companies-that-shut-down-went-bankrupt-in-last-decade-2019-11?op=1#2018-alta-motors-13) and products that failed or were discontinued : Palm, Compaq, Nokia, BlackBerry, AltaVista, Google+, Windows Mobile, gaming consoles, ...).

So...

If you want to automate Somfy IO devices you have no other choice today than buying one of their *locked-in* gateways.
BUT you may still use an additional, open, gateway to control Somfy proprietary devices through the Somfy gateway, to reduce the risks implied by proprietary products. For instance by using the [overkiz plugin](https://www.home-assistant.io/integrations/overkiz/) in *Home Assistant*.

According to what I've discovered, this applies to many other vendors as well...



## The gateways

Let's come back to the gateway you will need to buy or make.

There are many gateways : vendors propose their own[^tahoma], some third party actors also do[^enki] [^tradfri] [^tuya], some only work with one or few protocols while others implement many.
Noticeably, some big actors have adopted standard protocols, like Ikea[^ikea-zigbee] or Lidl[^lidl-smart-home] with Zigbee.

I have been focusing on open source software gateways that can be installed on an existing appliance.

[**Home Assistant**](https://www.home-assistant.io/) (aka "HA") and [**Jeedom**](https://www.jeedom.com/) are two versatile and popular open source software gateways.
They both work on Raspberry Pi, and can be run as a Docker container (although the official images are not perfect).

There are others, but I haven't investigated. They work the same by installing plugins dedicated to the protocols and smart devices you want to control. Some users with a lot of smart devices have instances of different gateways because they can't find all the features in one.

**In my case *I have only installed Home Assistant*.** It was really quick to setup : the Docker image[^hass-docker] immediately worked and no more than 2-3 hours were needed to fully tune it (permissions and alike). It has been working great for weeks.



## The adapters

When you install a software gateway on an existing appliance (like a PC or a [Raspberry Pi](raspberrypi.com)), you need to complement it with a radio transmitter that is compatible with the protocols you want.

In my case - I wanted a Zigbee adapter for Raspberry Pi - I have bought an USB adapter rather than a HAT[^raspbee] to plug on the GPIO pins because it is more portable (it can be plugged on any computer with USB ports) and allows having a USB cable extend its range.

With open standards you may even make your own, from cheap radio transmitters and the appropriate software !
For instance, radio adapters for Z-Wave (908.42 MHz) or Zigbee (mainly on 2.4 GHz) can easily be bought but not for RTS, which uses 433,42 MHz, often missing in "433 MHz family" radio adapters.

### Compatibility

As we are talking about hardware stuff, make sure to buy one that implements the correct **version** of the chosen protocol.
For instance there are several "Zigbees" around that *may* have different compatibility levels : "v3.0", "Tuya", ...

Check also that the firmware can be updated (think about security fixes). Some devices are already labeled "Thread / Matter-ready", awaiting for firmware patches.

### Antenna or not ?

Often, the adapters are too small to get a correct radio reception.

**This is normal**. It is not a defect, physics cannot do better.

Some adapters include an amplifier and/or an antenna but they tend to require more power and they may still be subject to local interferences (there are many discussions about USB 3 hard drives interfering with radio signals on Raspberry Pi).

There is an easy solution : just use a cable to plug your device and extend its range.

### Vendors

I have not found a good benchmark of vendors, mostly trolls between users comparing different devices in different contexts...

As IoT standards are designed with low production costs in mind, electronic chipset are usually not complex to build, so most of the devices are probably just OK from a technical point of view.

Just be aware that most of them are built in a *not-so-human-friendly-and-not-so-privacy-friendly country...* See ?




## Smart marketing

As introduced before, there are a lot of standards.

But even within a single standard, **full support** is not always guaranteed.
For instance, different models of smart plug may not implement the same Zigbee metrics (*profiles*), and all gateways may not support them in the same way (the metrics AND the devices).

A good starting point is to check both the vendor's compatibility list and the gateway's one.

Unfortunately, product informations in stores are usually very poor (try to get the zigbee profiles for a device, or even just the protocol, on web marketplaces...).

Also, **the vendors will let you think that you have to use their own mobile app, ecosystem and connect your device to "The Cloud"**.
**Fortunately, this is false, as I've experienced.**
They just have to provide custom apps and gateways for newbies, and they tend to oversell those products in order to get a return on investment, but they just don't care giving more advanced options.

In my (very small, ok) experience, I've had no problem and no need to install/register/connect to anything else that **just the gateway and NO INTERNET**, the plugs were all recognized through plain Zigbee.

Of course, if you want to use Internet services like Amazon Alexa (don't) or the vendor's ones you *will* need to install/register/connect through Internet. Choose your fate.


\
\
End.


[^clamp-meter]: [Pince ampèremétrique.jpg](https://commons.wikimedia.org/w/index.php?curid=47203181)
[^power-plug]: [Power-Meter 33409-480x360 (5000495108).jpg](https://commons.wikimedia.org/wiki/File:Power-Meter_33409-480x360_(5000495108).jpg)
[^zlinky]: [ZLinky_TIC](https://github.com/fairecasoimeme/Zlinky_TIC)
[^shelly]: [Shelly energy metering products](https://www.shelly.com/en-gb/products/energy-metering)
[^nous-plug]: [Smart ZigBee Socket NOUS A1Z](https://nous.technology/product/a1z-1.html)
[^enki]: [Enki](https://enki-home.com/)
[^tahoma]: [Tahoma](https://www.somfy.co.uk/products/smart-home-with-tahoma)
[^tradfri]: [TRÅDFRI app & Gateway](https://www.ikea.com/gb/en/customer-service/faq/tradfri-app-and-gateway-pub802ccaa1)
[^lidl-smart-home]: [Lidl Smart Home](https://customer-service.lidl.co.uk/SelfServiceUK/s/article/How-does-smart-home-work)
[^tuya]: [tuya & lidl](https://www.tuya.com/developer-stories/lidl)
[^ikea-zigbee]: [Ikea & zigbee](https://www.ikea.com/gb/en/customer-service/knowledge/articles/0f5877f2-10gg-46g8-bbg7-83f26d4112df.html)
[^mosquitto]: [Mosquitto, an MQTT server](https://www.mosquitto.org)
[^raspbee]: [RaspBee II](https://phoscon.de/en/raspbee2/)
[^hass-docker]: Running Home Assistant as a docker container is probably of no use to most people, and may be complex to understand as it requires access to the physical port with the Zigbee adapter, but for me it was still better than a local installation as it fitted my existing deployment routines.
[^hass-energy-full-approach]: [You may find here another, full approach to energy monitoring with Home Assistant](https://community.home-assistant.io/t/an-approach-to-both-detailed-and-group-level-energy-management/393261)