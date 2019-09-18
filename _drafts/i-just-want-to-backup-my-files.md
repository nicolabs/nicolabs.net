---
title: I just want to backup my files
layout: post
tags:
  - security
  - cloud
  - "Series : your own cloud"
---

What does it mean to "just backup my files" ?

Let's guess the implicit requirements behind this :
- what maximum cost
- what maximum recovery delay
- how much privacy
- how much resiliency
- how deep history (file deletion or example)

## Technical constraints

Huge size means huge recovery time : separate data into several backup sets per priority or usage. For example one set for system configuration, one for personal configuration, one for photos, ... You're able to quickly restore your system then restore your photos over several days or weeks.

## A word on Backblaze

### Compared to others

AWS Glacier is not integrated with duplicity because of its asynchronous API.

Crash Plan does not provide an API.

B2 price.
B2 availability and durability ?

...

### Options

Personal backup solution does not match my needs because :
- requires a closed source client
- therefore client encryption cannot be trusted
- Linux not supported

B2/Personal backup features not used (done by duplicity) :
- client side encryption
- incremental upload
- file versioning

Duplicity also :
- supports other (cloud or not) providers
- open source


## The ultimate sensitive place

There is always a place that can unlock the chain , whether it's your memory or some file.
With complex secrets like GPG keys, or whole files you just cannot keep it in memory so you can either print them, or simply keep them on a hidden USB key.
Save the minimal configuration to recover secret keys and backup configuration.


## References

- https://www.backblaze.com/backup-your-computer.html
- [How to configure Backblaze B2 with Duplicity on Linux](https://help.backblaze.com/hc/en-us/articles/115001518354-How-to-configure-Backblaze-B2-with-Duplicity-on-Linux)
