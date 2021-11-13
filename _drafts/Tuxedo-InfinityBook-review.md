---
title: Tuxedo InfinityBook S 15 review
layout: post
tags:
  - review
  - hardware
  - laptop
maturity: draft
---

![Tuxedo InfinityBook with keyboard lights](/assets/blog/screenshots/tuxedo-infinity/tuxinfinity_kblight.jpg)

# TODO

- le menu d'hibernation ne fonctionne pas
- charge par USB c très efficace. Le chargeur n'est pas plus compact que le classique par contre. Voir quelques grammes plus lourd.
- des fichiers autostart vers des binaires absents (/usr/local/bin/vboxinstall.sh, /usr/local/bin/cryptshutdown.sh)
- surélévation du capot à l'ouverture ok effectivement (me suffit pour avoir une position ~ ergonomique) - en revanche empêche de poser sur un docker usb-c comme celui vendu par tuxedo (le chassis + le bas de l'écran présentent un angle qui n'adhère pas)

https://www.tuxedocomputers.com/en/Linux-Hardware/Linux-Notebooks/15-16-inch/TUXEDO-InfinityBook-S-15-Gen6.tuxedo

## What's in the box

- the laptop itself
- cable (length : )
- quickstart manual
- a more complete manual (in german but helped me find out the key to enter bios menu) ; from the reviews I've seen I understand there is only a german version of this guide, which is not cool
- USB key with Tuxedo's Web fully automated installation (WebFAI)
- some goodies : mouse carpet, 2 pens, ...

![Tuxedo InfinityBook 15S](/assets/blog/screenshots/tuxedo-infinity/TUXEDO%20InfinityBook%20S%2015%20Gen6.jpg)

## Performance

- As expected, it's lightning fast

## Screen

- Resolution and brightness are really fine IMHO (I was worried looking at the poor specs), even though you would have to forget the dark mode if you want to code under the sun (as far as I know it's the case with most laptops out there)
- 16/9 allows for a 15"6 display, and even if it's not the best ratio for coding the resolution compensates by allowing enough text lines to be displayed in the given height. I don't regret this 15"6 over the 14" version as it brings some comfort to display 2 documents or apps side by side (usefull when you have an editor next to an emulator).
- when working in stand up position, if the workbench is a bit low (e.g. 90 cm high), the lid does not open enough to get a comfortable 90° to my eyes. I would have appreciated it to open 15-20° more.

## Sound

- Speakers are the worst I've ever encountered, without a doubt. Still, it proved enough for video conferencing (tested with MS Teams).
- The problem is only with internal speakers, the sound quality is good if you use an external headset.
- The suggested trick installing PulseEffects barely enhance the sound quality and it does not add any significant difference (with the provided settings from Tuxedo's github for this particular laptop)
- Allowing volume over 100% is probably your best bet to get the most of it : `dconf write com/solus-project/budgie-raven/allow-volume-overdrive true`

## Camera

- The camera is also one of the poorest I've seen in years, it just seems to come from the past. However it's not something I personnaly care about.
- There is an infrared camera that can be used with Windows Hello, but that is not taken into account out of the box by Howdy, the Linux alternative. Howdy works with the normal camera, though, although the configuration is not obvious at first.

## Keyboard 🐧

- Numeric keypad : it's been a long time ; it's nice to have it but I can live without and in the end I would prefer to have it removed and the room used to get larger keys on the right side (shift, enter, ...) and/or the speakers enhanced
- black keys on black chassis = keys are less easily identified by the eye than silver/black => this and the fact that the chassis coat seems to be fragile => should be silver and black keys
- from my experience I find it more comfortable to light the keys from above (thinkpad had a light embedded at the top of the lid) : it enlightens all keys, their surface AND the touchpad (which is not, on the tux, making it tricky to find it or its fingerprint reader in the dark). It's barely OK to use for times when you don't have a mouse at hand.
- this model can only have on color at a time (I couldn't find a place where it's stated) ; to change the color follow the procedure on tc's website and reboot (it takes a kernel module to reload)
- the doc is really hard to find https://www.tuxedocomputers.com/en/Infos/Help-Support/Instructions/Installation-of-keyboard-drivers-for-TUXEDO-Computers-models-with-RGB-keyboard-.tuxedo https://github.com/tuxedocomputers/tuxedo-keyboard
- I've tried several values for the `mode=` parameter but it didn't change anything ; however changing the mode with the keyboard shortcut seems to cycle through preconfigured colors
- I confirm that the keys lights comes both from around (their side) and the characters are also enlightnen (semi transparent)


## Touchpad

- It's not good. The slide sensation is not at the level I'm used to with Thinkpad and HP computers, resulting in a lower accuracy. It can be especially annoying when you need to do very small moves to put the cursor at a pixel-sized location. Maybe it can be fixed by configuration ?
- It looks less durable than a HP Elitebook or Envy laptop for instance. Let's see in a few years if it looks like the one of my old Thinkpad ![Photo](TODO)

## Chassis

![Tuxedo InfinityBook finger marks](/assets/blog/screenshots/tuxedo-infinity/tuxinfinity_fingermarks.jpg)

- Feels more heavy than I expected (compared to my old thinkpad => gonna check the weight)
- It's same width as a usual 15"6 but as short in depth as a 14", which is great for transportation
- The lid (as well as most other parts) can easily be scratched and does not prevent finger marks at all (see photo)

![Tuxedo InfinityBook scratched](/assets/blog/screenshots/tuxedo-infinity/tuxinfinity_scratch.jpg)

## Battery

- Don't trust the battery life advertized o,n tuxedo's website. It's just a normal battery with normal life expectations. No more, no less.
- The cable is long enough and the charger fairly small enough for transportation.
- The *FlexiCharger* feature of Tuxedo is nice, as it lets you preserve battery life by preventing micro-charges. However when you need full capacity you have to reboot to change the parameter in the BIOS : this setting should be available from the OS (e.g. Tuxedo Control center) to be really called "flexible".
- FlexiCharger has bugs also : the UI enters an infinite loop if you try to set up the 'stop charge' threshold below the 'start charge' one, and sometimes the charge does not start when the battery capacity reaches the configured threshold : you have to unplug the cable and plug it back.

## Fingerprint reader

- It's there but not working :
	- linuxhardware probe says there's no known driver
	- however seems to be supported here : https://fprint.freedesktop.org/supported-devices.html
- It does not make sense as it's embedded on the touchpad's surface so we would like to use it... Maybe Tuxedo is hopping for a driver update ?

## Tuxedo's WebFAI

- I wanted to use the provided USB key to test several distributions, but it's a pain because the WebFAI requires a wired connection, so I have to go next to the Internet box during the whole installation.
- Otherwise, the USB key works (Dominik said his was not)

## Tuxedo OS & other customizations

- Some commands missing that I expected to be there are not (because of Ubuntu ?) ; e.g. ifconfig
- Some presets that could be provided : installed PulseEffects, disabling Intel ME, enabling battery limiting ?
- I'm not impressed with Tuxedo Control Center : it has only limited features, although usefull. Reading reviews I expected more. (also the tray icon is the only one in color)
- After some tests, the computer seems to suspend to RAM when the lid is closed (as expected), but stills consumes a lot of energy from my point of view. I put it in suspend mode around 23h : it had at 61% battery remaining. When I woke it up around 8h, only 9% were remaining.
	- Tried this : https://www.tuxedocomputers.com/en/Infos/Help-Support/Instructions/Fine-tuning-of-power-management-with-suspend-standby.tuxedo : from 31% to 21% in 7h30
- Automatic or manual screen lock (*<Super>L*) does not work OOTB, you have to manually enable it : `dconf write org/gnome/desktop/lockdown/disable-lock-screen false`
- When you ask for Tuxedo OS to be installed, in addition to the main partition, they also create the UEFI partition (512 MB FAT) and a swap partition at the end of the disk. But they made the swap partition 8 GB, whereas I have 64 GB of RAM...
- Software center is used (comes from Ubuntu), but it's just not useable (anybody uses it anyway ?). You get multiple identical entries with no clue about which one to choose. Most of the time the version is outdated. etc.
- there is no help for my device (only for InfinityBook S14, not S15) https://www.tuxedocomputers.com/en/Infos/Help-Support/Help-for-my-device/TUXEDO-InfinityBook-Series.tuxedo
- the website is annoying as it does not let you CTRL-click a link to open into a new tab : the current page will freeze (click event is probably registered in javascript in a wrong way)
- Sidenote on the delivery : as opposed to many comments I've seen around, my computer was shipped within a few days (around a week), so I was very satisfied on this point

## Wrapping up

- I'm not impressed.
- I would probably have preferred to remove the extended keys (numeric keypad and so) and replaced with better audio and larger keys. Let's see if I change my mind after some time using it.


## References

- [InfinityBook S 15 at Tuxedo's](https://www.tuxedocomputers.com/en/Linux-Hardware/Linux-Notebooks/15-16-inch/TUXEDO-InfinityBook-S-15-Gen6.tuxedo)
- Link to Redit
