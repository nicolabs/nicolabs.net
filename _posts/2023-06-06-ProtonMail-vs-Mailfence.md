---
title: I got bored of Google reading my emails
layout: post
tags:
  - mail
  - security
permalink: 2023/protonmail-vs-mailfence
last_modified_at: 2024-02-16
maturity: good
---


[**Proton Mail**](https://proton.me/mail) and [**Mailfence**](https://mailfence.com) are two famous email service providers known for their privacy-friendly policies.

You will find [many](https://www.lifewire.com/best-secure-email-services-4136763) [articles](https://restoreprivacy.com/email/secure/) [comparing](https://www.makeuseof.com/mailfence-vs-protonmail-which-is-more-secure/) them as well as [other](https://restoreprivacy.com/email/secure/) [similar](https://itsfoss.com/secure-private-email-services/) providers, but most of them are just theoretical, so I decided to give them a *real world* test run.

My use case was to exchange emails with *normal people* (i.e. without requiring them all to have state-of-the-art encrypted mailboxes).

After reading enough of both providers documentation, I've became confident that they were both offering adequate security to evade at least a bit from greedy GAFAs through **end-to-end encryption**, **OpenPGP encryption & signature**, a lot of **security & privacy best practices**, as well as recommendations from many trustworthy sources.

The below comparison will therefore go straight to the differences that I've found to be decisive for a practical day to day usage. Depending on how far your paranoia goes, you may read by yourself the thrilling crypto details elsewhere....

> Please note that both providers have their issues so you may not find the perfect one in this article. However it may still give advices on comparing email providers in general, and especially Proton Mail vs others.



## Where Proton Mail wins

![Proton Mail logo](/assets/blog/3rdparty/logos/Mail-logomark-logotype-colored-noborder.svg){:class="inline" height="120px"}
<figcaption>Proton Mail logo - https://proton.me</figcaption>

### Security

As introduced, I'll be very quick on the pure security features : overall Proton Mail has a slightly superior security model.
It provides a **zero-knowledge architecture**, has never access to the private key which encrypts your data on their servers, and [publishes the sources of the client applications](https://github.com/ProtonMail/proton-mail-android).

On the contrary, Mailfence stores the private key on its servers as a trade-off in favor of user experience (e.g. seamless encryption/decryption from the web UI). Of course you should encrypt the key itself before sending it through the web UI, but it is still easy to send it in clear by mistake (I've tested it : it's absolutely possible and they purposely display a warning when detected). This may also facilitate the exploitation of vulnerable keys by a malicious admin.

### Multi-factor authentication

Proton Mail allows [2FA with hardware U2F or FIDO2 tokens in addition to TOTP](https://proton.me/support/two-factor-authentication-2fa) while Mailfence only supports TOTP.

Additionally, when 2FA is activated on Mailfence, you need to define dedicated passwords for each service (IMAP, SMTP, POP, etc) [but you can only define *a single* password for each of them](https://twitter.com/Mailfence/status/1673985727485419525), which is displayed only once at set up time !
**This is nonsense** as such a password should be unique per device, not per service. This is just how it's done everywhere else... This mailfence system forces you to configure all of your devices *at the same time* (and do it again for all of them *each time you add one*)...



## Where Mailfence wins

![Mailfence logo](/assets/blog/3rdparty/logos/mailfence-logo-black-white-barbed.svg){:class="inline" height="120px"}
<figcaption>Mailfence logo - https://mailfence.com</figcaption>

### Standards and usability

This is probably the major difference between Proton and others (not only Mailfence).

Because they wanted to go further than current email security standards, Proton had to build a non-standard ecosystem. This is justified because there is no widespread end-to-end encryption standard. However this leads to **locking you into Proton-specific applications** : custom Android / iOS applications and a local proxy for desktop. **You will not be able to use your favorite email client with Proton Mail** (no POP, no IMAP).

Despite delivering very high quality products, I've observed some annoying bugs in Proton Mail and Proton apps lack in features, a bit behind other open source products with larger communities, like Thunderbird and K9-Mail.

This is also the reason why I had to reach their customer support more than once, which was not the case with Mailfence, for which I could get around configuration problems myself.

Actual examples of bad experience with Proton include :

- attachments in the Android mail app are saved "somewhere" but the user is not notified, which is misleading and not the convention in such app
- `@protonmail.com` address is used when responding to an email even if it was sent to an alias, making it easy to reveal your private e-mail
- Mobile (Android) app was very slow (it has improved *a lot* in a few months but it still freezes a few seconds when clicking the button and the CPU seems to be put under heavy load when searching in messages) - I assume this is because of client-side cryptography

I also encounter from time to time quite *scary* bugs like :

- message loss (I still haven't identified the cause)
- impossibility to send messages (especially on bad mobile network), producing tons of copies of the draft message as as side effect
- multiple messages mixed together 😱 (in Thunderbird it frequently happens that I click on a message but the content of another one is loaded, or the body of an email continues in another one)

On the other side, **Mailfence implements plain email standards**.

This gives Mailfence a lot of advantages over Proton : you can use your favorite POP/IMAP-compatible email client, import/export using standard procedures (see below for more details), advertises support for \*DAV protocols (not tested) for calendar, contacts, remote file access (get access to the attachments via WebDAV !) ...


### Sending with custom domain address

This one is a small advantage for Mailfence, but still...

Custom domain hosting works fine, but the more specific case when you just want to use your custom-domain address to **send** emails from Proton Mail (i.e. without having Proton be the mail provider for all the domain's addresses) is probably not intended by Proton *(there is a trick however : go first through the full procedure to define Proton as the mail host for the domain, so Proton lets you register your alias - by adding MX, TXT, etc. records to the DNS - then remove or update the MX priority to go back to the previous MX handler)*.

On the other side, with Mailfence you just have to add an email in [your personal data section](https://mailfence.com/flatx/index.jsp#tool=prefs&page=perso), then validate by following the link in a confirmation email ! This feature is a bit hidden / not well documented but actually works perfectly.

This will not prevent you from properly configuring your custom domain to redirect **incoming** emails and pass through spam filter (SPF-related entries), though.



## Draw

There are a few features worth describing even though they don't give a clear advantage to one or the other.

### Trust

Proton Mail has a good reputation among the global community and [Mailfence is recommended by Thunderbird](https://support.mozilla.org/en-US/kb/new-email-address).

Even though they are both located in privacy-friendly countries ([Switzerland for Proton](https://proton.me/about) and [Belgium for Mailfence](https://mailfence.com/en/company.jsp)), they have to comply with the local laws and both publish reports about the legal inquiries they receive ([Proton](https://proton.me/legal/transparency), [transparency report](https://blog.mailfence.com/transparency-report-and-warrant-canary/)).

They both promote security by transparency : Proton [audits its client apps](https://proton.me/blog/security-audit-all-proton-apps), which are also open source, and Mailfence lets you use your favorite client apps, while [using OpenPGP.js](https://blog.mailfence.com/fr/chiffrement-de-bout-en-bout-mailfence/#h-comment-nous-procedons) in their web client.

None of them publish the server-side code though, but you will not get better today, and hopefully this should not be required thanks to end-to-end encryption.

### Importing emails

Proton Mail has a helpful feature to import mail history from external providers. You may have to run the procedure several times to get all mail transferred with high volumes, but I found it OK to merge ~1GB of data from 2 GMail accounts (I've not tested on my whole 20+ GB of emails because it was a good opportunity to trim old mails).

As Mailfence supports IMAP, it's even easier to import messages from another provider : [just download all messages in your local mail client from the old account and drag & drop them to Mailfence's](https://mailfence.com/en/doc/#import). It's long because messages are copied one by one. But it could not be simpler.

This may seems like a little advantage for Mailfence but I consider it a draw because Proton's features just does the job.

### Overall offer, maturity and support

[Proton Mail](https://proton.me/mail/pricing) and [Mailfence](https://mailfence.com/#pricing) plans have each pros & cons but Proton always offer more storage for the same price, and shows a more ambitious portfolio of services (VPN, password manager).
Mailfence should probably do better here ; their free plan was so much limited that I could not test without paying.
This is still a limited advantage for Proton because as good as they are, their services are less usable due to non-standard protocols and not always mature apps (e.g. *Proton Drive* provides huge storage but at the time of writing it can only be accessed through the web interface - no API, no automatic upload / synchronization).

It's also rare enough to mention that Proton's support team answered quickly and, after a cold start, were quite efficient to answer my questions, even speaking a perfect French (although always pushing first the English response).
However as said before, I haven't even had *the need* to contact Mailfence's customer support.

Mailfence documentation, on its side, is quite a mess to search for : Google was better than their own website to find out [SPF/DKIM/DMARC values](https://kb.mailfence.com/kb/set-up-anti-spoofing-defense-custom-domain/) for instance.

Mailfence has other bugs also, which can be quite annoying :

- Aggressive [anti-spam](https://mailfence.com/en/doc/#antispam) filters : it happens every day that legit messages end up in the *spams* folder... In fact it never happened to me to miss legit messages so much ! Additionally, Mailfence does not learn from the actions I take to move them back to the *inbox* or the *spam* folders so I had to deactivate the anti-spam for all incoming mails !
- Read messages are not marked as read ! Most of the time they just come back as 'unread', making it a never-ending story...
- Mailfence advertises providing XMPP instant messaging, but they don't support [SRV records](https://prosody.im/doc/dns#srv_records) - which is a basic recommendation to implement, and seemingly other features are missing / not open so I just could not make it work correctly in Thunderbird and Conversations.im.
- Searching emails on the server is also not working well from clients (currently it's not working *at all* in my K9-Mail) ; this can really be show-stopper

Although it may be a bit in favor of Proton, I could not clearly determine a winner on this one...

### Anti-spam addresses

Both ProtonMail and Mailfence support *[Plus Addressing](https://blog.mailfence.com/plus-addressing-to-track-spammers/)* to fight against spam : e.g. `uniqueprefix+myname@mf.me` or `uniqueprefix+myname@pm.me`.


## Conclusion

**Proton Mail is probably the closest to zero-knowledge security email provider**, but it comes at a price : you will be locked within their ecosystem.
Proton is therefore probably well advised for a closed group of people who want to securely exchange messages, files, events, ... Probably OK for small businesses.

On the other hand if, like most people, you want to exchange emails with non-Proton users, copies of your messages will be found *unencrypted* in others' mailboxes anyway.
In this case Proton does not offer significant advantages and **you will prefer providers implementing email standards like Mailfence or others, for a better integration** with common software.

Note that what applies to Mailfence here might apply to other email providers with end-to-end encryption as well. I've actually started to test Tutanota some time ago and they were looking so much the same that I've not bothered testing both of them.

Ultimately, **if you search for secure and practical *messaging*, then you might not want to use emails at all** and switch over to other protocols like XMPP, Signal, ... which have a larger user base than Proton and are built on security-focused standards, unlike emails.
