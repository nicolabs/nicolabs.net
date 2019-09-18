---
date: 2019-09-02
tags:
    - android
    - security
---

# Why

It is a general security recommendation to use passwords managers because :

- It allows to **segregate services** by giving each of them a different password so ~~if~~ when someone gets into their database he would not be able to use the password against other services
- It greatly simplifies **frequent update of passwords**
- In special cases (e.g. you die) : it can be used by a trusted person to recover your accounts
- It's better than online password manager services (e.g. like major web browsers or paying cloud services propose) because it also has integrations for mobile and native applications

However I don't like it much because :

- It is a single point of failure : if anyone manages to get access to the password manager's database he has ALL your passwords ; that's precisely against using different passwords for different services (one has it all : your password manager)
- Password managers are legions on the Internet but very few are trustworthy
- Authentication is not all : if the authentication mechanism is complicated enough, *they* would find another way in, while you're battling with complex configuration and plugins.

So why writing about it ?

Because I still use a password manager to maintain a long list of passwords that I use on unstrusteable websites :

- The ones that **require** to create an account just to get an estimate of the delivery price.
- The ones that send you back your password **in clear** by email as a subscription confirmation.
- The ones that you're **just not confident** they understand what privacy is.

For me that means almost all sites beyond the less-than-ten ones I use to manage authentication, messaging and money.
For those sites I use long passphrases I manually roll from time to time, in addition to a second factor (2FA). *They* would need to get my brain (still working) and my second factor(s) ; it's enough for me.


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
- On Android, have to re-select the database file each time (looks like it looses its path or whatever) !
