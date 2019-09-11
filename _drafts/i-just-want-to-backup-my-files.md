---
title: I just want to backup my files
layout: post
tags:
  - security
  - cloud
  - "Series : your own cloud"
---

What does it mean to "just backup my files" ?

## Technical constraints

Huge size means huge recovery time : separate data into several backup sets per priority or usage. For example one set for system configuration, one for personal configuration, one for photos, ... You're able to quickly restore your system then restore your photos over several days or weeks.

## A word on Backblaze

Personal backup solution does not match my needs because :
- requires a closed source client
- therefore client encryption cannot be trusted
- Linux not supported

Duplicity does :
- client side encryption
- incremental upload
- support other (cloud or not) providers
- open source


## References

- https://www.backblaze.com/backup-your-computer.html
