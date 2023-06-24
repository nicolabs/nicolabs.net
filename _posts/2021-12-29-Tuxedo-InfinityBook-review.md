---
title: Tuxedo InfinityBook S 15 review
layout: post
tags:
  - bios
  - hardware
  - laptop
  - linux
  - privacy
  - review
  - Ubuntu
maturity: good
alternate:
  - https://dev.to/nicobo/tuxedo-infinitybook-s-15-review-2aho
  - https://www.reddit.com/r/tuxedocomputers/comments/rsw8c9/tuxedo_infinitybook_s_15_review/
---

![Tuxedo InfinityBook with keyboard lights](/assets/blog/screenshots/tuxedo-infinity/tuxinfinity_kblight.jpg)

After almost ten years of good and loyal services 🎖, I had to give up on my [Lenovo Thinkpad T520](https://pcsupport.lenovo.com/us/en/products/laptops-and-netbooks/thinkpad-t-series-laptops/thinkpad-t520), which was getting too slow for things like intensive Docker building...

Althought I still trust Lenovo for providing excellent Linux laptops, I wanted to try one of the newcomers in the Linux laptop market.

I made up my mind on [InfinityBook S 15](https://www.tuxedocomputers.com/en/Linux-Hardware/Linux-Notebooks/15-16-inch/TUXEDO-InfinityBook-S-15-Gen6.tuxedo) from Tuxedo Computers ('TC').


## What's in the box

- The laptop itself (it's just a customized [Clevo NS50](https://clevo-computer.com/en/laptops-configurator/purpose/business-and-office-solutions/5400/clevo-ns50mu-intel-core-11-gen.-tiger-lake/iris-xe-graphics-thunderbolt-4))
- A power cable (~ 2,80m from plug to computer)
- A quickstart manual
- A more complete manual (in german 🇩🇪, but helped me finding out the key to enter BIOS menu)
- An USB key with TC's Web fully automated installation ("WebFAI") - *not tested*
- Some goodies : mouse pad, 2 pens, ...

![Tuxedo InfinityBook 15S](/assets/blog/screenshots/tuxedo-infinity/TUXEDO%20InfinityBook%20S%2015%20Gen6.jpg)


## Tuxedo customer service : shipping, documentation,. ..

- At the difference of many comments I've seen around, my computer was shipped within a few days (around a week) - very statisfying
- [Their website](https://tuxedocomputers.com) is annoying as it does not let you CTRL-click a link to open into a new tab : the current page will freeze (click event is probably registered in javascript in a wrong way :-()
- At the time of writing, there is no dedicated help page for my device ([only for InfinityBook S14, not S15](https://www.tuxedocomputers.com/en/Infos/Help-Support/Help-for-my-device/TUXEDO-InfinityBook-Series.tuxedo))
- One mandatory thing for me is to be able to tune memory, disks, CPU before ordering. Tuxedo's website is very good at this. You can even [make your own keyboard](https://www.youtube.com/watch?v=6wrwNaS5dw4&t=38) or [engrave a custom logo on the chassis](https://www.tuxedocomputers.com/en/Individual-Keyboards.tuxedo).


## Performance & fan noise

I'm not a performance addict (I don't play games, I don't mine bitcoins, I don't run do machine learning on my computer), so I have not run extended benchmarks.

However it's obviously fast, it compiles docker images & runs multiple VM seamlessly ; as expected regarding the [Intel Tiger Lake Core i7 CPU, 64GB 3200MHz RAM and NVMe PCIe 4.0 disk](https://linux-hardware.org/?probe=aabe23e7a8).

As seen in many comments, I can confirm that Tuxedo computers have an unusual management of fan speed.
The fan is agressively activated whenever there is a CPU / GPU utilization increase.
This follows a sane logic but can make you nervous when it suddenly starts to blow as the computer goes to sleep or when you're in the train, in the middle of quiet people...

Even with the most quiet profile ('silent', in the *Tuxedo control center*) it will be triggered very early.


## Display

- I was worried looking at the poor display specifications but they don't hold true : resolution and brightness are really fine. You will still have to forget about dark themes if you want to code under the sun but as far as I know it's the case with most laptops out there.
- 16/9 allows for a 15"6 display, and even if it's not the best ratio for coding, the resolution compensates by allowing enough text rows to be displayed within the given height. I don't regret this 15"6 over the 14" version as it brings some comfort displaying documents side by side.
- When working in stand up position, if your workbench is a bit low (e.g. 90 cm high), the lid does not open enough to get a comfortable 90° to the eyes. I would have appreciated it to open 15-20° more.


## Sound

- Speakers are the worst I've ever encountered, without a doubt. Still, it proved enough for video conferencing (tested with *MS Teams*).
- The problem is only with internal speakers, not the sound card, as sound quality is good if you use an external headset.
- [A suggested trick is to install PulseEffects](https://github.com/tuxedocomputers/pulseeffects-presets) but it does not add any significant improvement with the given settings.
- Allowing volume over 100% is probably your best bet to get the most of it : `dconf write /com/solus-project/budgie-raven/allow-volume-overdrive true`


## Camera

- The camera is also one of the poorest I've seen in years, it just seems to come from the past. Fortunately it's not something I personally care about.
- There is an infrared camera that can be used with *Windows Hello*, but that is not taken into account out of the box by [*Howdy*, the Linux alternative](https://github.com/boltgolt/howdy). Howdy works with the normal camera, though, although the configuration is not obvious at first.


## Keyboard 🐧

I have to say that the keyboard, ironically, turned out to be a major selling point for me, as most other Linux laptops distributors don't support AZERTY layouts.

- Numeric keypad (it's been a long time I haven't used one) : it's nice to have it but, in the end, I can live without it and I would prefer to have it removed and the room used to get larger keys on the right side (shift, enter, ...) and/or the speakers enhanced
- Black keys on black background is beautiful but not the best choice for the eyes : keys are faster to locate with silver/black combination for instance
- By default, there is a 'Tux' key 🐧 instead of a 'Windows ' or 'Apple' one, which is funny, but [you could also have whatever symbols printed on all keys](https://www.youtube.com/watch?v=nidnvlt6lzw&t=1). This may help reduce the learning curve but it seems impossible to get what the default keyboard would look like anyway.
- Back-lit keyboard is also not the best technique to light keys. From my experience I find it more comfortable to light the keys from above ([ThinkPad™ had a ThinkLight™ embedded at the top of the lid](https://youtu.be/MH7o3Zb8HVg)) : it enlightens all keys, their surface AND the touchpad (which is not, on the tux, making it tricky to find it or its fingerprint reader in the dark).
- As seen in a few forums, I confirm that the keys lights comes both from around (their side) and from the characters, which are semi-transparent
- This model can only have on color at a time (I couldn't find a place where it's stated). To change the color follow the procedure on TC's website and reboot (it takes a kernel module to reload ; the doc is really hard to find (it's [here](https://www.tuxedocomputers.com/en/Infos/Help-Support/Instructions/Installation-of-keyboard-drivers-for-TUXEDO-Computers-models-with-RGB-keyboard-.tuxedo) and [there](https://github.com/tuxedocomputers/tuxedo-keyboard))). I've tried several values for the `mode=` parameter but it didn't change anything ; however changing the mode with the keyboard shortcut seems to cycle through preconfigured colors
- A visual *Num Lock* indicator would have been nice


## Touchpad

- The touchpad is not good.
- The slide sensation is not at the level I'm used to with Thinkpad and HP computers, resulting in a lower accuracy. It can be especially annoying when you need to do very small moves to put the cursor at a pixel-sized location. Maybe it can be fixed by configuration ?
- It looks less durable than a HP Elitebook or Envy laptop for instance. Let's see in a few years if it looks like the one of my old Thinkpad ![Photo](TODO)


## Chassis

- The chassis feels more heavy than I expected (compared to my old thinkpad *=> have to check the weight*)
- It's same width as a usual 15"6 but as short in depth as a 14", which is great for transportation
- When opening the lid, lift-up hinges raise the notebook a little bit from the rear, which is ergonomic for typing, but in turn prevent to fit over a docking station like their own [Tuxedo Office Hub](https://www.tuxedocomputers.com/en/Linux-Hardware/Accessories-books-co-/USB-accessories/Universal-docking-station-for-all-TUXEDO-Books-Type-C-Type-A-USB-connection_1.tuxedo)... I've tried several positions but it doesn't easily stay in place.
- The lid (as well as most other parts) seem to be easily scratched and the material does not prevent finger marks at all (see photos below)

![Tuxedo InfinityBook scratched](/assets/blog/screenshots/tuxedo-infinity/tuxinfinity_scratch.jpg)
![Tuxedo InfinityBook finger marks](/assets/blog/screenshots/tuxedo-infinity/tuxinfinity_fingermarks.jpg)


## Battery & charge

- Don't trust the battery life advertized on TC's website. It's just a normal battery with normal life expectations. No more, no less.
- The cable is long enough and the charger fairly small enough for transportation.
- Charging with TC's USB-C cable is as much efficient as with a classic cable. The USB-C port's position seems a bit uncomfortable (in the middle - so it may be in the way sometimes, and not easy to plug without looking) but it has not annoyed me so far.
- Both cables feel the same weight and size overall, but the USB-C may allows you to charge your smartphone or another computer with a compatible battery.
- The [*FlexiCharger*](https://www.tuxedocomputers.com/en/Infos/Help-Support/Frequently-asked-questions/What-is-Flexicharger-.tuxedo) feature of Tuxedo is nice : it lets you preserve battery life (not autonomy) by preventing micro-charges. However when you need full capacity you have to reboot in order to deactivate it from the BIOS. This setting should be available from the OS (e.g. Tuxedo Control center) to really be called "flexible".
- FlexiCharger has bugs, too : the BIOS UI enters an infinite loop if you try to set up the 'stop charge' threshold below the 'start charge' one, and sometimes the charge does not start when the battery capacity reaches the configured threshold : you have to unplug the cable and plug it back.
- *Hibernate* menu does not work (I suspect it may be linked to the fact that I have 64 GB of RAM and no dedicated swap partition, but I haven't investigated on this topic yet). Anyway hibernation has never worked out of the box with Ubuntu.


## Fingerprint reader

It's there but not working :
  - [linuxhardware probe says there's no known driver](https://linux-hardware.org/?id=usb:04f3-0c63)
  - however seems to be supported with [*f*print](https://fprint.freedesktop.org/supported-devices.html)

This does not make sense as it's embedded on the touchpad's surface so we would expect it to be useable... Maybe Tuxedo is hopping for a driver update ?


## Tuxedo's WebFAI

- I wanted to use the provided USB key to test several distributions, but it's a pain because this so-called WebFAI requires a *wired* connection, forcing me to stay next to the Internet box (which is not in a cosy place) during the whole installation.
- Otherwise, the USB key works ([Dominik said his was not](https://youtu.be/1TFMxbNtXyQ))


## Tuxedo OS & other customizations

I ordered the computer pre-installed with *Tuxedo OS*, a custom *Ubuntu Budgie* distribution: there are a few things that don't work out of the box with this configuration.

- Some basic packages are missing (because of Ubuntu ?) ; e.g. `ifconfig`
- Some presets that could be provided : installed PulseEffects, disabling Intel ME, FlexiCharger enabled ?
- Tuxedo Control Center has only a limited set of features, from which only the power profile is of some interest. From the reviews I read, I expected more. Also the tray icon is the only one in color...
- The computer seems to suspend to RAM when the lid is closed, as expected, but stills consumes a lot of energy : from 61% battery remaining to only 9% in appromixately 9h. Applying [this](https://www.tuxedocomputers.com/en/Infos/Help-Support/Instructions/Fine-tuning-of-power-management-with-suspend-standby.tuxedo) enhances battery life (from 31% to 21% in 7h30). There may be even better solutions.
- Automatic or manual screen lock (*\<Super\>+L*) does not work OOTB, you have to enable it : `dconf write /org/gnome/desktop/lockdown/disable-lock-screen false`
- When you ask for Tuxedo OS to be installed, in addition to the main partition, they also create the UEFI partition (512 MB FAT) and a swap partition at the end of the disk. But they made the swap partition 8 GB, whereas I have 64 GB of RAM...
- Software center is used (comes from Ubuntu), but it's just not useable (anybody uses it anyway ?). You get multiple identical entries with no clue about which one to choose. Most of the time the version is outdated. etc.
- Some 'autostart' symlinks target missing executables (`/usr/local/bin/vboxinstall.sh`, `/usr/local/bin/cryptshutdown.sh`)


## Tuxedo's BIOS

Tuxedo ships computers with a custom BIOS.

I thought that was fine, because they could provide nice features like FlexiCharger, **disabling Intel ME** (which was a major point for me), ...
However I later learned that they get BIOS updates from *Clevo* for which [they are not able to testify what's inside](https://www.reddit.com/r/tuxedocomputers/comments/qbal7m/new_infinitybook_s15_bios/hhbvdgs/), which of course **is a major issue for privacy !**

Unfortunately, this discredits all their work on the BIOS, and the best thing to do would probably be to [switch to coreboot or alike instead](https://www.tuxedocomputers.com/en/Infos/Help-Support/Frequently-asked-questions/Coreboot-on-TUXEDO-Computers-devices.tuxedo).


## Wrapping up

- **I'm not impressed**.
- I would rather **trade the extended keys (numeric keypad and so) with better audio and larger ENTER and SHIFT keys**.
- The **touchpad is not good**.
- The **custom BIOS should be replaced with a more free-as-in-freedom one**, just like [coreboot](https://www.coreboot.org/).
- The default Ubuntu Budgie install is not for *power users*. Change it.
- Still, **it is an up-to-date computer for programmers** and overall I don't regret buying it as it's ok for my daily usage.


## References

- [InfinityBook S 15 at Tuxedo's](https://www.tuxedocomputers.com/en/Linux-Hardware/Linux-Notebooks/15-16-inch/TUXEDO-InfinityBook-S-15-Gen6.tuxedo)
- Tuxedo InfinityBook Pro 14 Gen 6 video review by Dominik : [Part 1](https://youtu.be/1TFMxbNtXyQ) \| [Part 2](https://youtu.be/_IQwZlNOxEQ) \| [Bonus round](https://youtu.be/fRa9rF3yj4M)
- [reddit.com - InfinityBook S 14 Gen 6: some Issues, Questions and Short Review](https://www.reddit.com/r/tuxedocomputers/comments/m9vw43/infinitybook_s_14_gen_6_some_issues_questions_and/)
- [reddit.com - Review of Tuxedo InifityBook S14 v5 (or Clevo L141CU, Schenker Via 14, System76 Lemur Pro 14)](https://www.reddit.com/r/linuxhardware/comments/fvgu0h/review_of_tuxedo_inifitybook_s14_v5_or_clevo/)
