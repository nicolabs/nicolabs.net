# My PGP strategy

## Balancing security and usability

The only truly secure data is the one that never leaves a secure enclave. From the time when a secret has been accessible by a possibly corrupted tool/network/environment/device it's not truly safe anymore.
Therefore you realize you have to use derivative secrets with different trust levels to allow your phone to sign messages, a web service to prove your ownership, ...
Everything is your definition and usage of the trust levels.

- GPG key set :
  - root, most secure one
  - per segregation case : devices, application, service provider, ...

## Create it

    gpg --expert --full-generate-key --allow-freeform-uid

- `--expert` gives the full choice of algorithms (I'm now always using the longest keys and strongest algorithms - ECC - I can)
- `--allow-freeform-uid` allows to use an URL instead of an email (so I'm not spammed) for keys not intended for email communications. However to get benefit from automatic E-mail encryption it's mandatory to have the encryption key (or one of its signers?) attached to a key with your email.
- *Curve 25519* algorithm, based on several lectures ; it's a bet on the future and might reveal wrong so let be ready to renew keys in some time anyway

Choosing RSA and 4096 because of compatibility **BUT does it makes sense for the primary key ???**.

Duration : for keys attached to mobile devices (smartphone, laptop you take with you in the train), it makes sense to use a reduced timelife for the keys (like 1 month ?).
It will not prevent the stealer of your smartphone to use the key if he has really planned to do so, but you'll sleep better after the key has expired.


## Make it useable

### On public directories

I've never been far in there because of one main reason : **spam**.

## User interface

As far as I know there is no user-friendly interface. The best one for me being kgpg for years and it has missing icons on Ubuntu and still launches a terminal to properly edit keys...

I put it on the fact that, because of its highly secure design, GPG is not easy to integrate in other programs.

It's not vital to have a graphic interface dedicated to gpg because most use cases are handled within a client application (e.g. mail app, chat app, ...).
However it's a major pain point when coming to generate or edit keys, as people usually don't remember gpg commands and options they use once a year...


### Enters keybase.io

Same problems but more integrations available.
Decreased (say adapted) security but acceptable use : each one must be aware this hasn't been battle-tested as pgp.
See [NCC_Group_Keybase_KB2018_Public_Report_2019-02-27_v1.3.pdf](https://keybase.io/docs-assets/blog/NCC_Group_Keybase_KB2018_Public_Report_2019-02-27_v1.3.pdf).

Account created early, lost key (as usual because I've just not used it enough to make it in my long-term memory).

Main security aspects :
- It's now using its own separate cryptography system (it's not PGP anymore) but it can still certify PGP keys.
- It's centralized (1 server provider ; see below)
- It eases identities spreading by:
    - providing a unique directory for identities (keybase.io)
    - automatically creating a key per device, signed by any other owned key, that can be easily revoked (no more sacrosanct private key that can never be touched)

It allows to sign generic statements (not only keys) and therefore can be used to certify almost anything like ownership of online accounts (twitter, Mastodon, ...) but also websites and PGP keys.

IMHO it's still a very nice tool to advertise online identities (including PGP keys) and allow people to send you encrypted messages without having to reveal an email address to spammers or to set up an online form.

The apps are quite good and they provide services over the main mechanism : encrypted chat, encrypted file system, encrypted git repository. The user experience they provide is far behind the big commercial ones (far less reactive) but it does the job. The biggest issue for me is the high battery drain it occurs (my Android phone mainly, which I suspect is very dependent on the phone's hardware).

One huge advantage is the availability of client apps for all platforms, which made me use it to securely* exchange data between my devices (PC, Android, iOS devices) through chat or file transfer.

I've started to use encrypted git repositories for not-so-sensitive-projects-that-I-still-don't-want-to-publish to prevent me from hosting my own, but I don't mean it as a target solution because I'm worried what would happen to my data if keybase turns off...

The main issue for me is its centralised architecture :
- its availability and integrity depends on a unique provider (might be possible to deploy other instances but I haven't seen any and they would not federate, defeating the purpose of being a centralised directory)
- its terms and privacy rules can change at any time
- as a cloud service, gathers data about their users (see [their privacy policy](https://keybase.io/docs/privacypolicy))
- as a US-hosted service it depends on US law (which forces the provider to disclose data, restricts cryptography exports)

=> unfortunately proved right on May 7, 2020 when Keybase announced they were bought by Zoom...


### Keyoxide

TODO


### keys.openpgp.org

https://keys.openpgp.org/about/faq

A key server that's not part of the federated SKS pool (not compatible).

It brings confidentiality features by separating identifying data from public one. It has plans to federated several instances.


## OpenKeychain

OpenKeychain is an implementation of OpenPGP for Android.

It let's you generate/import/export keys and is integrated with a few essential apps.

It has several limitations like reduced algorithms choice and forcing the presence of an email on new keys (but can import keys without one) but you probably won't find a better app nowadays.

It does the job.




## Wrap up

- master key with email
- keybase.io to advertise keys and online accounts
- separate keys per usage
- unencrypted backup on hidden USB key


## References

- https://alexcabal.com/creating-the-perfect-gpg-keypair
- [OpenPGP Best Practices](https://riseup.net/en/security/message-security/openpgp/best-practices#openpgp-key-checks)
- [Guide to using YubiKey for GPG and SSH](https://github.com/drduh/YubiKey-Guide)
- [SafeCurves: choosing safe curves for elliptic-curve cryptography](https://safecurves.cr.yp.to/)
- [Offline GnuPG Master Key and Subkeys on YubiKey NEO Smartcard](https://blog.josefsson.org/2014/06/23/offline-gnupg-master-key-and-subkeys-on-yubikey-neo-smartcard/)
- [GnuPG, clefs, YubiKey : c’est parti](https://www.unicoda.com/?p=3230)
