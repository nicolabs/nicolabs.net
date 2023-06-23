---
title: An email domain for your family
layout: post
tags:
  - mail
  - self hosting
  - domain
maturity: good
---

Do you want your family members to share the same **@\<put your family name here\>** emails ?

You have several choices :

1. pay an email provider to host email accounts => this may become expensive if your pals send a lot of multimedia files through emails and require lots of GB
2. self-host an email server => this implies a lot of administration if you want it to be highly available, including complex white-listing to bypass anti-spam filters
3. let everyone choose their own email provider and use the common domain to redirect to/from them

**This article is a very draft description on how to do it the 3rd way.**


## The pattern

Let's say you want everyone in your family (or friends) to share the same email domain : **mom@myfunky.family**, **jul@myfunky.family**, **dog@myfunky.family**, ...

For *Jul* which is using `jul@sadmail.org` that means :
1. forward all incoming messages at `jul@myfunky.family` to `jul@sadmail.org`
2. allow sending out emails as `jul@myfunky.family` from `sadmail.org`

The basic steps for this are explained in the following paragraphs :

1. Choose an email provider that will forward `@myfunky.family` messages to each member's own address
2. Register (rent) `myfunky.family` domain to a registrar and configure it
3. Members must allow their account at their personal email provider to send e-mails with their family address
4. Members may also need to add a new identify in their e-mail apps


## Choose an email provider

You need an email server to forward emails received at *@myfunky.family* to each members' personal mailbox.

In this tutorial we don't want to host the email server ourselves, so you may choose any email provider offering a *forwarding* service to external email addresses (I guess they all provide it).
It may be the one of your personal mailbox or a totally different one.
Often the domain registrar itself will offer it already so you probably don't need to go further.

**For each family member (after having configured the MX records) you will need to add a forward rule** :

| From                 | To                         |
|----------------------|----------------------------|
| `jul@myfunky.family` | `jul@sadmail.org`          |
| `mom@myfunky.family` | `mom455678@iamaboomer.com` |
| `dog@myfunky.family` | `snoopy@snoopymail.waf`    |

See the mail provider for the exact procedure (if you're using the domain registrar's to do this, [you probably just have to change to the correct tab...](https://docs.gandi.net/en/gandimail/forwarding_and_aliases/index.html)).

Note that **you will first need to configure the MX records** on `myfunky.family` so you don't loose emails - see below.


## Register and configure the family domain

There are 2 things to configure on the domain :

- Set [MX records](https://www.cloudflare.com/learning/dns/dns-records/dns-mx-record/) pointing at the *forwarding* email server you chose in 1.
- Set anti-spam records ([a.k.a. "SPF"](https://www.cloudflare.com/learning/dns/dns-records/dns-spf-record/)) to allow other email providers to send upon the family addresses without being flagged as spammers

### MX records :

**See the mail provider for the values tu put in the MX records**. Basically, it consists of putting the email server address.

If it is the domain registrar chances are it is already configured or there is a one-click procedure.

Once MX records are configured, you can proceed to forwarding rules (see above).

### SPF records :

*Receiving* email on your *@myfunky.family* address is ultra-simple and most of the time instant (it's just adding a forward rule at the email provider - see above).

But **to be able to send from this address you will have to set anti-spam records on the DNS** to pass through spam filters : this is called [SPF (Sender Policy Framework)](https://www.cloudflare.com/learning/dns/dns-records/dns-spf-record/).

The principle is simple : this is a [TXT record](https://www.cloudflare.com/learning/dns/dns-records/dns-txt-record/) on the `myfunky.family` domain which contains the email providers allowed to send emails with this domain.
For instance if some members use Gmail and others Yahoo Mail, you need to include both `_spf.google.com` and `_spf.mail.yahoo.com` to this list (exact values are provided by each mail provider).

However, when including too many of them (this may come quickly since your family members probably use different email providers), you will reach the **limit of 10 total DNS queries allowed** by the SPF specification !
Important to know : [each initial domain may resolve to several ones](https://toolbox.googleapps.com/apps/checkmx/) : for instance `_spf.google.com` currently resolves to 3 other domains (3 additional DNS queries).

The only way to bypass this limitation is to directly include IP addresses instead of domain names, **but then you must take care of updating them when they change**.
You [might find online tools](https://dmarcly.com/blog/spf-permerror-too-many-dns-lookups-when-spf-record-exceeds-10-dns-lookup-limit) to do this - it's called [**SPF flattening**](https://smalltechstack.com/blog/flattening-your-spf-record), but I haven't found a correct one.
There are also tools to update by hand or automatically ([here's mine](https://github.com/nicolabs/gandi-spf-flatten/tree/main)).

This was the touchy part, other steps are usually straightforward...


## Steps for each family member

### Allow their account to send e-mails with their family address

In ordert to *send* emails with their family address, members need to configure their own email provider : the procedure differs for each of them but it often imply sending a verification email to the new address [e.g. for Gmail](https://support.google.com/mail/answer/22370).

### Add a new identity in their e-mail apps

As a final step, each member will probably want to add their family address as a new identity so that they don't need to manually change the `from:` field for each message to send.

This is also a client-specific configuration (e.g. for [K9-Mail](https://docs.k9mail.app/en/6.400/settings/account/#manage-identities) ; for [Thunderbird](https://support.mozilla.org/en-US/kb/using-identities)).
