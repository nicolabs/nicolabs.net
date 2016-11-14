---
layout: post
title: "A paper backup for your private key"
date: 2012-06-14 00:03:28 +0100
tags: android printkey security certificate cryptography java JKS keystore keytool openssl paperkey password PEM PKCS12 X.509
permalink: articles/paper-backup-your-private-key
---
> This article focuses on Android and Java keystores, but it applies as well to any key that can be printed as plain text.
>
> Before printing a private key, make sure that it is what you need : for instance you would rather print a revocation certificate for an OpenPGP key since you can still sign content with a new key. This is not the case for Android, which requires the same key for every release of an application.

## Securing a private key

Talking about digital security, there are several techniques to keep a private key secure :

- choose strong algorithms with long enough keys
- choose a strong password (and don't tell it)
- keep it in a safe place (don't copy it on all your USB keys or your phone)
- be paranoid
- ...

Anyway, there is always a risk that you loose access to your key : whether it was deleted or you've lost the password. Because of this you should keep a copy in a safe place.

There are [many ways](http://www.gnupg.org/gph/en/manual.html#AEN513) to keep a backup key. This article takes the Android case to explain **how to print a private key to paper** so that you can restore it even if your hard disk crashed or if you forgot the password.

## The Android case

![Android keychain](/assets/blog//android-keychain.png)

Android requires developers to [sign their applications](http://developer.android.com/guide/publishing/app-signing.html) with a digital certificate and that each future release be signed with the same certificate.

Since all releases of an application are signed with the same certificate, the system knows when an update is available for a given application and the end user is seamlessly notified.

Sadly, bad things happen when the developer (you) looses access to the certificate : he (you) will not be able to release updates for the application without it. [Never](http://stackoverflow.com/questions/4843212/the-apk-must-be-signed-with-the-same-certificates-as-the-previous-version). [Ever](http://stackoverflow.com/search?q=%5Bandroid%5D+lost+keystore).

Android does not currently support multiple certificates per application so [the best you could do](http://stackoverflow.com/questions/2815221/lost-cert-for-published-app) would be to release a new app with the same name, in the hope your users will find a way to it by themselves...

As years go on, you will have a new computer, wipe USB keys, reinstall OS, ...
So many dangerous operations for your digital certificates, hidden among millions of files !
If, like me, you are anxious at the idea of losing your certificates or passwords, just print a paper copy !
Although it is not invulnerable, paper should be less prone to mass erasing than a simple electronic file.

The idea is [simple](http://en.wikipedia.org/wiki/Paper_key), [not new](http://www.jabberwocky.com/software/paperkey/), and you just need to know two commands to get a printable hard copy of your certificate.

Let's start.

## Java keystores

> Although this article focuses on command line, you can choose the easy way and use [a graphical tool](http://www.lazgosoftware.com/kse) to export / import all data.

Android uses jarsigner to sign apks (application files). Therefore, your key must live within a "JKS" file (**J**ava **k**ey **s**tore).

To deal with JKS you use the `keytool` command, which is [included in the JDK](http://docs.oracle.com/javase/7/docs/technotes/tools/solaris/keytool.html) (JDK 6+ is required to run commands from this article).

Here is a reminder of the [Android recommended way](http://developer.android.com/guide/publishing/app-signing.html#cert) to generate a certificate for signing applications :

    keytool -genkeypair -keystore mykeys.jks -alias foo -keyalg RSA -keysize 2048 -validity 10000`

With this command, your JKS will be named `mykeys.jks` and your certificate aliased as "foo".

It is important to note than `-genkeypair` will not only generate a private & public key pair, but also [wrap it in a self-signed X509 certificate](http://docs.oracle.com/javase/6/docs/technotes/tools/solaris/keytool.html#genkeypairCmd). The alias you chose will then link to *two* main distincts components : the private key and the certificate.

![Fig. 1 -  A typical Java keystore with signing material for an Android application](/assets/blog//android-keystore.png)

### A note about passwords

Java keystores support two kind of passwords : the one for the keystore itself, and one for each key (alias) it contains.

In this article, we use `openssl` to create keys and therefore give them passwords, while the keystore password is always set in the `keytool` command.

During creation, if you do not provide a password for a key, `keytool` will give it the same as the keystore. When reading a key, `keytool` will try the keystore password first, so you will only be prompted once if they are the same.

Still, _`keytool` does require passwords_ on both keystore and keys (even if they are the same) and according to the documentation, they must be at least 6 characters long.

Therefore, although `openssl` allows keys without passwords, **make sure to put one that's compatible with `keytool`** (not empty and same as the keystore if you choose so) or you will get cryptic errors like _division by zero_ or _Error outputting keys and certificates_ with :

    139832027854496:error:06065064:digital envelope routines:EVP_DecryptFinal_ex:bad decrypt:evp_enc.c:539:
    139832027854496:error:23077074:PKCS12 routines:PKCS12_pbe_crypt:pkcs12 cipherfinal error:p12_decr.c:104:
    139832027854496:error:2306A075:PKCS12 routines:PKCS12_item_decrypt_d2i:pkcs12 pbe crypt error:p12_decr.c:130:

## Exporting keypair and certificate

Since JDK 6, `keytool` provides the `-importkeystore` command to import / export full data between keystores. Before that, only public parts could be exported. Unfortunately it is still not able to export private data to plain text : you will need to use another tool to achieve this : `openssl`.

    keytool -importkeystore -srcstoretype jks -srcalias foo -deststoretype pkcs12 -srckeystore mykeys.jks -destkeystore foo.p12

    openssl pkcs12 -in foo.p12 -out foo.pem -nodes

The first command exports all key/certificate data to a binary PKCS12 file. Make sure to give this file the *same* password as the exported key (see the note about passwords).

The second command converts the binary PKCS12 to readable text (also called PEM, or ASCII-armored).
By default the private key is still printed encrypted with a symmetric algorithm, so even if you get this key data, you will need the password to unlock it. The option `-nodes` bypasses this by allowing the key to be printed **unencrypted**.

You end up with two Base64-encoded elements in the file `foo.pem` : the private key and the certificate.

    Bag Attributes
        friendlyName: foo
        localKeyID: 54 69 6D 65 20 31 33 33 39 35 32 31 39 38 37 38 35 37
    Key Attributes: <No Attributes>
    -----BEGIN PRIVATE KEY-----
    MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDJZo94ubcUv+jH
    45ljstc7mc0QkLi90Y23wSeR4PYm9TTscuL2y7YoYW74f98HO1IQyw0TGGsCVhiN
    ... (cut) ...
    ibYd/PO20fiHIXRcC8bRejW+rdujiGWbbdkUMtNPv2mSkU1O/EFQ1azz7Luh5qrv
    pPuhlcdgBgEznzg0YlS+BIYJfxDaCdXMr/O7Vhr7PuMMcMXHXjSYss/B5P1hCG4+
    fQkDExaUGryMbReQWmz8k1PhiA==
    -----END PRIVATE KEY-----
    Bag Attributes
        friendlyName: foo
        localKeyID: 54 69 6D 65 20 31 33 33 39 35 32 31 39 38 37 38 35 37
    subject=/C=FR/ST=France/L=Paris/O=nicobo.net/OU=IT/CN=M. Nicobo
    issuer=/C=FR/ST=France/L=Paris/O=nicobo.net/OU=IT/CN=M. Nicobo
    -----BEGIN CERTIFICATE-----
    MIIDRDCCAiygAwIBAgIET9MM1TANBgkqhkiG9w0BAQUFADBkMQswCQYDVQQGEwJG
    UjEPMA0GA1UECBMGRnJhbmNlMQ4wDAYDVQQHEwVQYXJpczESMBAGA1UEChMJRnJl
    ... (cut) ...
    pdl1Nx2TwgaFyjAIMNmXETwwHlCID8bqOvg/4Jg+IkhemTLd0YB56PHYw1+7atMi
    t4WQYPsdxrjoT1M7qYo/I6UM9YemmW1sN+XEdpwu130iMPkUflZvewUXtiokK16h
    mLjm8v4vbo2SPx40WypprCQf+2H1RcPa
    -----END CERTIFICATE-----

=> [Print them down](http://nicolabs.github.io/printkey) and keep the papers in a place safe from dangers like fire, unauthorized people, ....

![Key printed to paper](/assets/blog//printedkey.png)

You can remove the unnecessary text outside of BEGIN / END blocks. On MS Windows, you may need to convert line breaks - which follow the Unix convention - to read the text.

One more advice before printing : make sure to use a font that does display all characters as *different* symbols or you might not be able to recover the key later. Check especially i,I,l,1 ( (upper & lower 'i', 'L' and one) and o,O,0 ('o' and zero) characters.

## Restoring the certificate

When the big day has come and you want to restore your digital certificate from a piece of paper, simply type the key data back into a text file (let's call it `foo-restored.pem`) then run the following commands :

    openssl pkcs12 -export -in foo-restored.pem -out foo-restored.p12

    keytool -importkeystore -srckeystore foo-restored.p12 -srcstoretype pkcs12 -destkeystore restored.jks -deststoretype jks -srcalias 1 -destalias foorestored

> You could try an OCR software to scan the text from a photo or image. I have not been successful with this yet.

This time, the first line converts back the PEM data to binary PKCS12.
Don't miss the `-export` option, that was not used for the opposite transformation.

The second line imports back the key and certificate into your JKS keystore. If it already exists, it will be updated.
We did not specify an alias (`-name`) for the key on the `openssl` command so we use `-srcalias 1` to target it. You can choose whatever alias you want for the restored key in your keystore (here `foorestored`).

*Remember : the new password the openssl command asks for will be the password for the key. The new password the `keytool` command asks for will be the password for the keystore.*

Your keystore `restored.jks` now contains an exact copy of your lost key : signing with it will produce *identical* results as signing with the original key.

> If you want to compare two signed jar, compare their content, not the jar themselves : all files must be binary equal (except the name of the key files if you changed it).

## References

- keytool : [docs.oracle.com/javase/7/docs/technotes/tools/windows/keytool.html](http://docs.oracle.com/javase/7/docs/technotes/tools/windows/keytool.html)
- OpenSSL : [openssl.org/docs/apps/openssl.html](http://www.openssl.org/docs/apps/openssl.html) and [openssl.org/docs/apps/pkcs12.html](http://www.openssl.org/docs/apps/pkcs12.html) and [openssl.org/related/binaries.html](http://www.openssl.org/related/binaries.html) (binaries for windows: 'light' version is enough)
- Android - signing your applications : [developer.android.com/guide/publishing/app-signing.html](http://developer.android.com/guide/publishing/app-signing.html)
- Introduction to certificates : [openssl.org/docs/HOWTO/certificates.txt](http://www.openssl.org/docs/HOWTO/certificates.txt)
- Help on stackoverflow : [stackoverflow.com/questions/652916/converting-a-java-keystore-into-pem-format](http://stackoverflow.com/questions/652916/converting-a-java-keystore-into-pem-format)
- KeyStore Explorer (GUI) : [lazgosoftware.com/kse/index.html](http://www.lazgosoftware.com/kse/index.html)
- Jarsigner : [docs.oracle.com/javase/7/docs/technotes/tools/windows/jarsigner.html](http://docs.oracle.com/javase/7/docs/technotes/tools/windows/jarsigner.html)
- The GNU Privacy Guard - Defining your security needs : [gnupg.org/gph/en/manual.html#AEN494](http://www.gnupg.org/gph/en/manual.html#AEN494)
- X.509 certificates format by PGP : [pgpi.org/doc/pgpintro](http://www.pgpi.org/doc/pgpintro)
- Maybe an alternative : signing with several certificates at the same time (not tested)
- Tesseract - an open source OCR software : [code.google.com/p/tesseract-ocr/](http://code.google.com/p/tesseract-ocr/)
- [en.wikipedia.org/wiki/Paper_key](http://en.wikipedia.org/wiki/Paper_key)
- Paperkey - an OpenPGP key archiver : [jabberwocky.com/software/paperkey/](http://www.jabberwocky.com/software/paperkey/)
- Safeberg's ® Trusted Paper Key : [safeberg.com/en/howitworks/usagetrustedpaperkey](http://www.safeberg.com/en/howitworks/usagetrustedpaperkey)
- Print a GPG key : [wiki.debian.org/Keysigning](https://wiki.debian.org/Keysigning)
- Pretty-print your key with this form : [github.com/nicolabs/printkey](https://github.com/nicolabs/printkey)
