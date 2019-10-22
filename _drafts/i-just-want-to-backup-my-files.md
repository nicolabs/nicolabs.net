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

### Covered scenarios

1. 1 disk loss
  - don't want to download data from all disks
2. Unwanted file deletion
  - don't want to download the whole data set


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


### Sample reports

#### Initial upload

    --------------[ Backup Statistics ]--------------
    StartTime 1568759264.08 (Wed Sep 18 00:27:44 2019)
    EndTime 1568759386.88 (Wed Sep 18 00:29:46 2019)
    ElapsedTime 122.80 (2 minutes 2.80 seconds)
    SourceFiles 588
    SourceFileSize 269671106 (257 MB)
    NewFiles 588
    NewFileSize 269671106 (257 MB)
    DeletedFiles 0
    ChangedFiles 0
    ChangedFileSize 0 (0 bytes)
    ChangedDeltaSize 0 (0 bytes)
    DeltaEntries 588
    RawDeltaSize 269507266 (257 MB)
    TotalDestinationSizeChange 200758158 (191 MB)
    Errors 0
    -------------------------------------------------

    --- Finished state OK at 00:37:45.461 - Runtime 00:10:15.079 ---

Files sizes on B2 are :

- 2.6 MB for the `*.sigtar.gpg`
- 1.3 KB for the `*.manifest.gpg`
- 200.8 MB for the `*.vol1.difftar.gpg` (is it compressed / deduplicated ?)

#### Other uploads

    --------------[ Backup Statistics ]--------------
    StartTime 1569029572.30 (Sat Sep 21 03:32:52 2019)
    EndTime 1569051602.44 (Sat Sep 21 09:40:02 2019)
    ElapsedTime 22030.15 (6 hours 7 minutes 10.15 seconds)
    SourceFiles 15976
    SourceFileSize 58373953276 (54.4 GB)
    NewFiles 9407
    NewFileSize 39419829255 (36.7 GB)
    DeletedFiles 0
    ChangedFiles 0
    ChangedFileSize 0 (0 bytes)
    ChangedDeltaSize 0 (0 bytes)
    DeltaEntries 9407
    RawDeltaSize 39417859079 (36.7 GB)
    TotalDestinationSizeChange 35196315298 (32.8 GB)
    Errors 0
    -------------------------------------------------

    --- Finished state OK at 09:52:56.818 - Runtime 06:22:48.465 ---

    --------------[ Backup Statistics ]--------------
    StartTime 1569116155.81 (Sun Sep 22 03:35:55 2019)
    EndTime 1569155262.71 (Sun Sep 22 14:27:42 2019)
    ElapsedTime 39106.90 (10 hours 51 minutes 46.90 seconds)
    SourceFiles 15977
    SourceFileSize 58373957372 (54.4 GB)
    NewFiles 15977
    NewFileSize 58373957372 (54.4 GB)
    DeletedFiles 15975
    ChangedFiles 0
    ChangedFileSize 0 (0 bytes)
    ChangedDeltaSize 0 (0 bytes)
    DeltaEntries 31952
    RawDeltaSize 58370041596 (54.4 GB)
    TotalDestinationSizeChange 53905745481 (50.2 GB)
    Errors 0
    -------------------------------------------------

    --- Finished state OK at 14:46:07.733 - Runtime 11:15:55.851 ---

The previous one and this one ran at the same time :

    --------------[ Backup Statistics ]--------------
    StartTime 1569115942.63 (Sun Sep 22 03:32:22 2019)
    EndTime 1569136911.50 (Sun Sep 22 09:21:51 2019)
    ElapsedTime 20968.86 (5 hours 49 minutes 28.86 seconds)
    SourceFiles 11269
    SourceFileSize 26726712099 (24.9 GB)
    NewFiles 11269
    NewFileSize 26726712099 (24.9 GB)
    DeletedFiles 0
    ChangedFiles 0
    ChangedFileSize 0 (0 bytes)
    ChangedDeltaSize 0 (0 bytes)
    DeltaEntries 11269
    RawDeltaSize 26723848835 (24.9 GB)
    TotalDestinationSizeChange 26108177956 (24.3 GB)
    Errors 0
    -------------------------------------------------

    --- Finished state OK at 09:32:30.829 - Runtime 06:02:20.171 ---


## The ultimate sensitive place

There is always a place that can unlock the chain , whether it's your memory or some file.
With complex secrets like GPG keys, or whole files you just cannot keep it in memory so you can either print them, or simply keep them on a hidden USB key.
Save the minimal configuration to recover secret keys and backup configuration.


## References

- https://www.backblaze.com/backup-your-computer.html
- [How to configure Backblaze B2 with Duplicity on Linux](https://help.backblaze.com/hc/en-us/articles/115001518354-How-to-configure-Backblaze-B2-with-Duplicity-on-Linux)
