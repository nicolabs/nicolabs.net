---
title: An email domain for your family
layout: post
tags:
  - mail
  - self hosting
  - domain
maturity: stable
last_modified_at: 2024-02-14
---

Do you want your *tribe* to share the same *cool* email addresses suffix like **@smith.org**, **@smith.family**, **@thesmithes.club**... ?

You have several choices :
<!--more-->

**1. Pay an email provider to host all email accounts.** This forces everyone to use the same provider and may become expensive if your pals are many or require lots of storage...
You may get it "free of charge" but you will have to pay by giving up your personal data.
{% plantuml %}
@startuml

!include <tupadr3/common>
!include <office/Servers/server_generic>

rectangle Tribe as "Your tribe" {
  actor Tim
  actor Tom
  actor Thelma
}
actor Others as "Another tribe"

OFF_SERVER_GENERIC(Server,"GMail\n(common provider)")

Tim --> Server
Tom --> Server
Thelma --> Server
Others -left-> Server : sends Tom@smith.org

@enduml
{% endplantuml %}

**2. Self-host an email server.** This implies a lot of technical maintenance (because you want it to be highly available). Nowadays aggressive anti-spam features of the major email providers also make it very VERY complicated for self-hosting.
{% plantuml %}1
@startuml

!include <tupadr3/common>
!include <office/Servers/server_generic>

rectangle Tribe as "Your tribe" {
  actor Tim
  actor Tom
  actor Thelma
}
actor Others as "Another tribe"

OFF_SERVER_GENERIC(Server,Your home\nserver)

Tim =right=> Server : **Administrates**
Tim --> Server
Tom --> Server
Thelma --> Server
Others -left-> Server : sends Tom@smith.org

@enduml
{% endplantuml %}

**3. Let everyone choose their own email provider and redirect to/from the tribe's domain.**
{% plantuml %}
@startuml

!include <tupadr3/common>
!include <office/Servers/server_generic>

top to bottom direction

rectangle Tribe as "Your tribe" {
  actor Tim
  actor Tom
  actor Thelma
}
actor Others as "Another tribe"

OFF_SERVER_GENERIC(TimServer,GMail)
OFF_SERVER_GENERIC(TomServer,Yahoo!)
OFF_SERVER_GENERIC(ThelmaServer,Librem)
OFF_SERVER_GENERIC(DNS,Front\nmail provider)

Tim --> TimServer
Tom --> TomServer
Thelma --> ThelmaServer
TimServer <-- DNS
TomServer <-- DNS
ThelmaServer <-- DNS
Others -left-> DNS : sends Tom@smith.org

@enduml
{% endplantuml %}

**This article is a very draft description on how to do it the 3rd way.**

> *Disclaimer :* The providers in this article are just examples. I am not saying that you should use them.


## The pattern

Let's say you chose *Gandi* as a front domain and email provider for your family (or friends) to share the same email domain : *thelma@smith.org*, *tim@smith.org*, *tom@smith.org*, ...

There are two things to consider :

**In order for them to receive emails** at their custom `@smith.org` address, we need to :

1. Make the [MX records](https://www.cloudflare.com/learning/dns/dns-records/dns-mx-record/) of `smith.org` domain point at *Gandi's*[^1] email servers
2. Configure redirection rules at *Gandi's* email servers for each tribe member ; e.g. `tim@smith.org --> tim@gmail.com`


**For them to be able to send emails** from their custom `@smith.org` address, we also need to :

1. Configure new 'identities' in each member's account at their current email provider to use the custom email address
2. Configure anti-spam DNS records at *Gandi* so that each member can send emails from their own provider's domain without being blocked

Details for each step are explained in the following paragraphs.


## Choose an email provider that can forward

So you need an email server to forward emails received at *@smith.org* to each members' personal mailbox.

In this tutorial we don't want to host the email server ourselves, so you should choose any email provider offering a *forwarding* service to external email addresses (I guess they all provide it).
It may be the one of your personal mailbox or a totally different one.
Often the domain registrar itself will offer this already so you probably don't need to look further.

**For each family member you will need to add a forward rule** ; e.g. :

| From                 | To                         |
|----------------------|----------------------------|
| `tim@smith.org` | `tim@gmail.com`          |
| `thelma@smith.org` | `thelma455678@iamaboomer.com` |
| `tom@smith.org` | `snoopy@snoopymail.waf`    |

See the mail provider for the exact procedure (if you're using the domain registrar's to do this, [you probably just have to find the correct tab...](https://docs.gandi.net/en/gandimail/forwarding_and_aliases/index.html)).


## Register and configure the family domain

There are at least two things to configure on the domain side :

- Set *MX records* pointing at the *forwarding* email server you chose.
- Set anti-spam records ([a.k.a. "SPF"](https://www.cloudflare.com/learning/dns/dns-records/dns-spf-record/)) to allow other email providers to send upon the family addresses without being flagged as spammers

### MX records :

**See the mail provider's documentation for the values to put in the MX records**. Basically, it consists of putting the email server address.
If your third-party email provider is also the domain registrar, then maybe it is already configured or there is a one-click procedure.

E.g. (beware of then ending dot !) : `example.org. 3600  MX   10 mailserver1.example.org.`

Once MX records and forward rules are configured, you will start receiving emails to the `@smith.org` address.

\
**That's all about *receiving* emails.**

### SPF records :

**To pass through spam filters sending emails from this domain, you will have to set anti-spam records on the DNS** : this is called [SPF (Sender Policy Framework)](https://www.cloudflare.com/learning/dns/dns-records/dns-spf-record/).

The principle is straightforward : this is a [TXT record](https://www.cloudflare.com/learning/dns/dns-records/dns-txt-record/) on the `smith.org` domain which contains the email providers allowed to send emails with this domain.
For instance if some members use Gmail and others Yahoo Mail, you need to include both `_spf.google.com` and `_spf.mail.yahoo.com` to this list (exact values are provided by each mail provider).

However if you include too many of them you will reach the **limit of 10 total DNS queries allowed** by the SPF specification !

**In addition [each initial domain may resolve to several ones](https://toolbox.googleapps.com/apps/checkmx/)** : for instance `_spf.google.com` currently resolves to 3 other domains (3 additional DNS queries). Since your family members probably use different email providers, you may quickly reach the limit...

The only way to bypass this limitation is to directly include the IP addresses instead of domain names, as IP addresses don't trigger a domain name resolution.
**In this case you have to take care of updating them if they change** (choice of the provider, not you..).
This is called [**SPF flattening**](https://smalltechstack.com/blog/flattening-your-spf-record).

You [might find online tools](https://dmarcly.com/blog/spf-permerror-too-many-dns-lookups-when-spf-record-exceeds-10-dns-lookup-limit) to do this, as well as other tools to update by hand or automatically...
As I haven't found nice & working ones [I have made one](https://github.com/nicolabs/gandi-spf-flatten/tree/main).

\
**Alright. This was the touchy part, other steps are usually straightforward...**


## Steps for each family member

### Allow their account to send e-mails with their family address

In order to *send* emails with their family address, members need to configure their account at their own email provider : the procedure differs for one to another but it often simply implies activating the feature and sending a verification email to the new address [e.g. for Gmail](https://support.google.com/mail/answer/22370).

### Add a new identity in their e-mail apps

As a final step, each member will probably want to add their family address as a new identity so that they don't need to manually change the `from:` field for each message to send.

This is also app-specific configuration (e.g. for [K9-Mail](https://docs.k9mail.app/en/6.400/settings/account/#manage-identities) ; for [Thunderbird](https://support.mozilla.org/en-US/kb/using-identities)).


_________________________________________________
[^1]: In this example Gandi has both roles : DNS & email provider
