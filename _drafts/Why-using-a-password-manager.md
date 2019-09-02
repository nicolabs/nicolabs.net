---
date: 2019-09-02
tags:
    - android
    - security
---

# Experimenting KeePass XC

Components :

- Native app on ubuntu (must use the official PPA, not any of the Ubuntu-packaged ones, *as usual unfortunately*)
- Android official app
- Web browser official plugin

Pros

- File sharing through a shared/cloud filesystem seems to work (still not perfect has it seems to generate conflicts)
- Browser integration seems ok (automatic fields filling)

Cons

- Typing the password every time (using a mobile keyboard it's just super hard if you choose a long passphrase). I don't have a fingerprint reader on my phone so I cannot . There is also a "file" authentication : not tested as of today.
- Works, but not user-friendly to configure : it's not ready for the masses.
- They advertize a "TOTP" feature but I still haven't got how it works...
