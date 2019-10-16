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

- `--expert` gives the full choice of algorithms (it's good to know what's available even though I'm not using ECC right now)
- `--allow-freeform-uid` allows to use an URL instead of an email (so I'm not spammed) for keys not intended for email communications. However to get benefit from automatic E-mail encryption it's mandatory to have the encryption key (or one of its signers?) attached to a key with your email.
- *Curve 25519* algorithm, based on several lectures ; it's a bet on the future and might reveal wrong so let be ready to renew keys in some time anyway

Choosing RSA and 4096 because of compatibility **BUT does it makes sense for the primary key ???**.


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

Account created early, lost key (as usual because I've just not used it enough to make it in my long-term memory).

It's now using its own separate cryptography system (it's not PGP anymore) but it can still certify PGP keys.

It allows to sign generic statements (not only keys) and therefore can be used to certify almost anything like ownership of online accounts (twitter, Mastodon, ...) but also websites and PGP keys.

 IMHO it's still a very nice tool to advertise online identities (including PGP keys).

The apps are quite good and they provide services over the main mechanism : encrypted chat, encrypted file system, encrypted git repository.
I use a bit the encrypted chat to transfer data between my devices but I don't use other services yet because I'm worried what would happen to my data if keybase turns off...

The main issues is its centralised architecture :
- its availability and integrity depends on a unique provider (might be possible to deploy other instances but I haven't seen any and they would not federate, defeating the purpose of being a centralised directory)
- its terms and privacy rules can change at any time
- as a cloud service, gathers data about their users (see [their privacy policy](https://keybase.io/docs/privacypolicy))
- as a US-hosted service it depends on US law (which forces the provider to disclose data, restricts cryptography exports)


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
