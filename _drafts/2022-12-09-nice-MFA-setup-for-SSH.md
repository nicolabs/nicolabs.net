---
title: A nice multi-factor setup for SSH
layout: post
tags:
  - security
  - mfa
  - 2fa
  - fido
  - yubikey
  - ssh
  - raspberry pi
---

![SoloKeys](/assets/blog/3rdparty/pictures/solokeys.png)
<figcaption>Illustration © 2022 SOLOKEYS - https://solokeys.com</figcaption>

This article shows how to set up an SSH server so that users can authenticate :
1. either with a hardware token (FIDO-compatible actually)
2. or with a two-factor authentication process, using their password and a one-time password (OTP)

In order to do that, we will see how to :
- set up SSH for TOTP (with a PAM module)
- generate an OTP secret and "pair" with the user's OTP application
- set up SSH for FIDO authentication
- set up the hardware token (I'm using a [YubiKey](https://yubikey.me/) here)
- generate a FIDO key on the hardware token and "pair" with the server

>***Note***
>
> This setup is only an example but should be a good starting point to build and tune your own authentication workflow.
>
> We could for instance first try a standard "public key" authentication when on the local network so that no hardware token and no password is required while in trusted zone...
>
> You will probably find similar articles over there, but I could not find the exact same setup so I've put together everything here. The one I should mention is [XHR's one](https://xosc.org/u2fandssh.html) who shares exactly the same approach (and who is still using the [finger protocol](https://en.wikipedia.org/wiki/Finger_protocol), by the way !), though you may find some other details and tips here.



## Authentication with a one-time password

![TOTP hardware token](https://upload.wikimedia.org/wikipedia/commons/0/03/Security_token.jpg)

### Set up the server host

In order for a "One-Time Password" (OTP) to be asked for after the usual password, we have to install a [PAM module (Pluggable Authentication Module)](https://en.wikipedia.org/wiki/Linux_PAM) on the server side.
Please note this is not SSH-specific, the module will work for all authentications on this machine.
The module is [google-authenticator-libpam](https://github.com/google/google-authenticator-libpam), it's from Google but it works with any TOTP-or-HOTP-compatible generator application.

This article explains it well : [Use 2FA (Two-Factor Authentication) with SSH @ linode.com](https://www.linode.com/docs/guides/secure-ssh-access-with-2fa/) ; below are the resulting commands and files.

First install the module :

```shell
sudo apt install libpam-google-authenticator
```

And enable it by editing PAM configuration ; here a sample `/etc/pam.d/common-auth` file :

```shell
# 1. here are the per-package modules (the "Primary" block)
# pam_unix is the standard password authentication
# success=1 means to bypass one step (which then leads to the OTP module)
auth    [success=1 default=ignore]      pam_unix.so nullok_secure
# In this sample setup, we allow users to connect with their LDAP password
# success=ok means to go to the next step (which is the OTP module)
auth    [success=ok default=ignore]     pam_ldap.so minimum_uid=1000 use_first_pass
# Finally, the OTP password is asked
# In case of success the 'deny' step is bypassed, leading to the 'permit' module
auth    [success=1 default=ignore]      pam_google_authenticator.so

# 2. here's the fallback if no module succeeds
auth    requisite                       pam_deny.so

# 3. prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
auth    required                        pam_permit.so
```

**From here, each user must generate a secret on the server in order to log in !**
**So, DO NOT LOG OUT now or generate an OTP secret for yourself and test the authentication before !**

There are other possible layouts for the PAM configuration, like `nullok` to allow users to log in without OTP until they have set it up : [github.com/.../google-authenticator-libpam](https://github.com/google/google-authenticator-libpam).


### Per-user set-up

To connect with OTP, each user must generate a secret by running this console-interactive process on the server :

```shell
# Runs a console-interactive process
google-authenticator

# Once done, send the file to other hosts where you want to use
# the same OTP secret (e.g. same network servers)
scp ~/.google_authenticator me@anotherhost.intranet
```

The process will save the secret into `~/.google_authenticator` and print informations to import it into an OTP application (e.g. via a QRCode).
Once generated, the secret file can be copied to other hosts in order to reuse the same OTP on several hosts.

Some good open source OTP apps for Android and iOS :
- ![Aegis logo](https://getaegis.app/images/icon.png){:class="inline" height="32px"} [Aegis](https://getaegis.app/)
- ![FreeOTP logo](https://freeotp.github.io/img/freeotp.svg){:class="inline" height="32px"} [FreeOTP](https://freeotp.github.io/)



## Authentication with a hardware token


![SoloKeys somu](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.shopify.com%2Fs%2Ffiles%2F1%2F0196%2F3068%2F6272%2Fproducts%2Fsomu_580x.jpg%3Fv%3D1618577369&f=1&nofb=1&ipt=8876f1516c3911fe122bbf20ebf9f0b28e3671427634f29bb3c2a3756155459e&ipo=images){:class="inline" height="120px"}![Nitrokey](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.nitrokey.com%2Fsites%2Fall%2Fthemes%2Fnitrokey%2Fmedia%2Fnitrokey-u2f.jpg&f=1&nofb=1&ipt=4ceb7b4ae8bf482c619f9428b5ca9679676b065c92c82f765df867bb54975994&ipo=images){:class="inline" height="120px"}![OnlyKey](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.shopify.com%2Fs%2Ffiles%2F1%2F2670%2F1700%2Fproducts%2F1_Main_Image_530x%402x.jpg%3Fv%3D1550701254&f=1&nofb=1&ipt=17adad9edf2b1ee0fcf30b4889c643cf3858204b15972710d8dfd86106edeb4a&ipo=images){:class="inline" height="120px"}

Since OpenSSH 8.2 it is possible to authenticate with a [FIDO](https://fidoalliance.org/fido2/) device, which brings support for a whole lot of hardware tokens.

>***Note***
>
> Before, there were procedures like using a specific [yubico-pam module for YubiKeys](https://www.linode.com/docs/guides/how-to-use-yubikey-for-two-factor-ssh-authentication/) (not described here).

The process is the same as with *public key* authentication but with a specific type of key, and you need your hardware token to be plugged in at authentication time.

You will find [several](https://fido.ftsafe.com/open-ssh-with-fido-keys/) [articles](https://www.linode.com/docs/guides/how-to-use-yubikey-for-two-factor-ssh-authentication/) already describing the process so I'll just put the important parts.


### Client setup


#### Set a PIN on the FIDO2 token

In order to use a *resident* key on a FIDO2 device, you will probably be required to set a PIN.

>***Note***
>
> Instructions in this paragraph are specific for YubiKey because it's the one I had for my tests but the rest of the article should work seamlessly with any other FIDO2 devices ([SoloKeys](https://solokeys.com/), [Nitrokey](https://www.nitrokey.com/fr), [OnlyKey](https://onlykey.io/), ... ) which may additionally bring interesting features like full open source design, reversible USB-A, firmware upgrade, hardware password manager, ...

For a YubiKey, you will need to [install the *YubiKey Manager (ykman)*](https://support.yubico.com/hc/en-us/articles/360016649039-Enabling-the-Yubico-PPA-on-Ubuntu).
You will not need the *YubiKey Personalization Tool* for this tutorial, if you wonder.

If you never set up a PIN on your YubiKey, simply run :

    # Example OS-independent installation command
    pip install --user yubikey-manager
    # Set the PIN for the first time
    ykman fido access change-pin --new-pin tfbZxxGY3r

It's important to note that the PIN is not limited to digits, FIDO2 allows up to **63 alphanumeric characters** !


#### Generate an SSH key

Each user must then generate a compatible private key ; run this on a client workstation :

```shell
    # Generates a key that resides in the hardware token
    # Replace 'NameYourKeyHere' with some string to identify this key
    # between others on the hardware token (e.g. 'intranet')
    ssh-keygen -t ed25519-sk -O resident -O application=ssh:NameYourKeyHere -O verify-required -f ~/.ssh/ed25519_sk_yubikey1
    # OR, generate a key that will NOT be usable on another host
    #ssh-keygen -t ed25519-sk -f ~/.ssh/ed25519_sk_yubikey1
    # Authorize it to the remote machines
    ssh-copy-id -f -i ~/.ssh/ed25519_sk_yubikey1.pub somehost.intranet
    ssh-copy-id -f -i ~/.ssh/ed25519_sk_yubikey1.pub anotherhost.intranet
```

You could use `-t ecdsa-sk` key type instead. From what I understand, `ecdsa-sk` is more compatible ; `ed25519-sk` is [not affiliated with NIST](https://www.hyperelliptic.org/tanja/vortraege/20130531.pdf).

The `-O resident` option allows the generated key to be "discoverable", meaning that you will be able to use it from another computer (`ssh-keygen -K` will extract some *key handle* from the hardware token into `~/.ssh/`). In this case, `-O verify-required` is also used so that a PIN is required.
This is only available for FIDO2 devices.

On the contrary, the commented-out alternative command will require a private key to be present on the computer in addition to the hardware token, meaning that another person will not be able to log in from another computer even she finds/steals the hardware token.
This works with older FIDO devices.

More explanations in the [release notes of OpenSSH](https://www.openssh.com/txt/release-8.2).

It is a good practice to do all of this again with another security token, so you are not locked-out in case you loose one.
You might also use the OTP process to recover.


#### Setting up the SSH client

Finally, users should make sure that their SSH client configuration is ready to use FIDO authentication ; partial sample `~/.ssh/config` :

```shell
# Takes the value of `ChallengeResponseAuthentication` (deprecated) if not defined
KbdInteractiveAuthentication yes

# Use my keys for all hosts of the intranet
Host *.intranet
  IdentityFile ~/.ssh/id_rsa
  IdentityFile ~/.ssh/ed25519_sk_yubikey1
  IdentityFile ~/.ssh/ed25519_sk_yubikey2
```

*More infos in [the man page](https://man.openbsd.org/ssh_config).*


### SSH server setup

Now, the server part.

First make sure your server runs OpenSSH ≥ [8.2/8.2p1](https://www.openssh.com/txt/release-8.2).
With older Debian systems [you can get it from backports](https://forums.raspberrypi.com/viewtopic.php?t=265211#p1817379).

From there, the configuration of `/etc/ssh/sshd_config` is pretty simple :

```shell
# Allow keyboard-interactive authentication (which is used for FIDO devices)
KbdInteractiveAuthentication yes
#ChallengeResponseAuthentication is a deprecated alias for KbdInteractiveAuthentication
#ChallengeResponseAuthentication yes

# Make sure to effectively enable it
# Here, we also enable classic publickey authentication from the local network
AuthenticationMethods publickey keyboard-interactive

# Make sure to allow enough tries for users who have many keys
# otherwise, they may encounter a 'Too many authentication failures' error
# even before their key is tried...
MaxAuthTries 9
```

*More infos in [the man page](https://man.openbsd.org/sshd_config).*

Now restart the SSH server :

```shell
sudo service ssh restart
```

**From another session**, try to authenticate :

```shell
$ ssh somehost.intranet
# The following message may be different or even absent !
# See https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html#_troubleshooting
Confirm user presence for key ssh:NameYourKeyHere
# Then, touch your FIDO2 token
You have new mail.
me@somehost.intranet:~ $
```

**You're in !**



## References

- [Using a U2F/FIDO key with OpenSSH](https://xosc.org/u2fandssh.html)
- [Using YubiKey to Secure Remote Servers in 10 minutes or less | Nextcloud 2FA](https://www.youtube.com/watch?v=4lPvjON4-k8) (video)
- [Understanding YubiKey PINs](https://support.yubico.com/hc/en-us/articles/4402836718866-Understanding-YubiKey-PINs)
- [YubiKey Manager downloads for all OS](https://www.yubico.com/support/download/yubikey-manager/)
- [YubiKey Manager (ykman) CLI and GUI Guide > FIDO Commands](https://docs.yubico.com/software/yubikey/tools/ykman/FIDO_Commands.html)
- [Ansible playbook](TODO)
- [Open-SSH with FIDO Keys](https://fido.ftsafe.com/open-ssh-with-fido-keys/)
- [Securing SSH with FIDO2 @ yubico.com](https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html)
- [Use 2FA (Two-Factor Authentication) with SSH](https://www.linode.com/docs/guides/secure-ssh-access-with-2fa/)
- [forums.raspberrypi.com > openssh 8.2 enables u2f / fido2 tokens](https://forums.raspberrypi.com/viewtopic.php?t=265211)
- [SSH/SFTP with Two Factor Authentication @ hallam.ch](https://www.hallam.ch/blog/index.php/2020/04/19/ssh-sftp-with-two-factor-authentication/)
- Linux PAM :
  - [How To Use PAM to Configure Authentication on an Ubuntu 12.04 VPS @ digitalocean.com](https://www.digitalocean.com/community/tutorials/how-to-use-pam-to-configure-authentication-on-an-ubuntu-12-04-vps)
  - [pam.d(5) - Linux man page](https://linux.die.net/man/5/pam.d)
- Legacy method with *yubico-pam-* :
  - [Two Factor PAM Configuration](https://developers.yubico.com/yubico-pam/Two_Factor_PAM_Configuration.html)
  - [Using a YubiKey for 2FA when Logging in over SSH](https://www.linode.com/docs/guides/how-to-use-yubikey-for-two-factor-ssh-authentication/) (legacy )
- [OpenSSH manuals](http://www.openssh.com/manual.html)
- [Security dangers of the NIST curves](https://www.hyperelliptic.org/tanja/vortraege/20130531.pdf)


![Gemalto usb shell token with a punched OpenPGP card inside.jpg](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Gemalto_usb_shell_token_with_a_punched_OpenPGP_card_inside.jpg/640px-Gemalto_usb_shell_token_with_a_punched_OpenPGP_card_inside.jpg)
