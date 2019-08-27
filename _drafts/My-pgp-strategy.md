# My PGP strategy

## Balancing security and usability

- GPG key set :
  - root, most secure one
  - per device

## Create it

    gpg --expert --full-generate-key --allow-freeform-uid

- `--expert` gives the full choice of algorithms (it's good to know what's available even though I'm not using ECC right now)
- `--allow-freeform-uid` allows to use an URL instead of an email (so I'm not spammed)
- *Curve 25519* algorithm, based on several lectures ; it's a bet on the future and might reveal wrong so let be ready to renew keys in some time anyway

Choosing RSA and 4096 because of compatibility **BUT does it makes sense for the primary key ???**.


## Make it useable

### On public directories

I've never been far in there because of one main reason : **spam**.

### Enter keybase.io

Same problems but more integrations available.
Decreased security but acceptable use : each one must be aware of the actual level of trust it brings.

Account created early, lost key (as usual because I've just not used it enough to make it in my long-term memory).

## References

- https://alexcabal.com/creating-the-perfect-gpg-keypair
- [OpenPGP Best Practices](https://riseup.net/en/security/message-security/openpgp/best-practices#openpgp-key-checks)
- [Guide to using YubiKey for GPG and SSH](https://github.com/drduh/YubiKey-Guide)
- [SafeCurves: choosing safe curves for elliptic-curve cryptography](https://safecurves.cr.yp.to/)
- [Offline GnuPG Master Key and Subkeys on YubiKey NEO Smartcard](https://blog.josefsson.org/2014/06/23/offline-gnupg-master-key-and-subkeys-on-yubikey-neo-smartcard/)
- [GnuPG, clefs, YubiKey : c’est parti](https://www.unicoda.com/?p=3230)
