---
layout: post
title: Migrating from Subversion to Mercurial
date: 2012-01-25 22:25:10 +0100
permalink: articles/migrating-subversion-mercurial
tags: tooling mercurial migration pre-revprop-change subversion svnsync
---
> Instructions are aimed at Windows mainly (on Linux it should be easier).

# Need to migrate from Subversion to Mercurial ?

This is a quick guide to migrating an existing _SVN_ repository to a new _Hg_ one.

It takes 2 major steps :

1. make a local copy of the existing SVN repository
2. convert it to Hg

# Make a local copy of the existing SVN repository

Oddly enough, this was the hardest part to figure out :

## 1. Create a local repository

It will mirror the existing (remote) one. I just used TortoiseSVN on an new, empty directory.

## 2. Initialize this repository

    C:\Users\nicolas\Work>"C:\Program Files\TortoiseSVN\bin\svnsync.exe" init file:///c:/Users/nicolas/Work/ciform-bak https://plugnauth.svn.sourceforge.net/svnroot/plugnauth

On Windows you will need the following `pre-revprop-change.bat` file in the `hooks` subdirectory of your newly created repository :

```bat
@REM pre-revprop-change.bat
@ECHO OFF

set user=%3

if /I '%user%'=='syncuser' goto ERROR_REV

exit 0

:ERROR_REV echo "Only the syncuser user may change revision properties" >&2
exit 1
```
[gist.github.com/1679659](https://gist.github.com/1679659)

You may find similar code on the net but :

- the sample that's provided with _TortoiseHg_ (or Tigris' distribution apparently) only contains Linux-ready scripts
- many samples on the web work fine for common operations but not for the `svnsync` command we are about to use

It looked strange to me that it was not working out of the box on Windows, but I really had to create that script to make it work...

## 3. Start the synchronization

    C:\Users\nicolas\Work>"C:\Program Files\TortoiseSVN\bin\svnsync.exe" sync --username cbonar file:///C:/Users/nicolas/Work/ciform-bak
    [...]
    Committed revision 92.
    Copied properties for revision 92.
    Transmitting file data .
    Committed revision 93.
    Copied properties for revision 93.

We can now work with this local SVN mirror.


# Convert the SVN repository to a Hg one

This operation is quite simple...

## 1. Enable ConvertExtension

With a command line client, it should be as easy as making sure you have the following in your `.hgrc` or `mercurial.ini` file :

    [extensions]
    convert=

With TortoiseHg I just had to enable `convert` in the global settings (I did first on the repo settings only but it didn't work right away so I gave up) :

![ConvertExtension enabled in TortoiseHg](/assets/blog/TortoiseHg-ConvertExtension.png)

## 2. Run the "hg convert" command

It might be the right time to [remap author names](http://mercurial.selenic.com/wiki/ConvertExtension#A--authors)...

    C:\Program Files\TortoiseHg>hg convert file:///c:/Users/nicolas/Work/ciform-bak file:///c:/users/nicolas/Work/ciform-hg
    initializing destination file:///c:/users/nicolas/Work/ciform-hg repository
    scanning source...
    sorting...
    converting...
    92 + added trunk directory : main development stream
    [...]
    0 + a lot of work on the ant task

Done. **You now have a fully functional Mercurial repository with all changesets from the SVN history !**


Successful import from SourceForge's SVN to Google Code's Hg :

![Sample project imported from Sourceforge's SVN to Google code's Hg](/assets/blog/svn2hg-googlecode.png)

# Related links

- Sample `pre-revprop-change` hooks for Windows : [stackoverflow.com/questions/6155/common-types-of-subversion-hooks/9010360#9010360](http://stackoverflow.com/questions/6155/common-types-of-subversion-hooks/9010360#9010360)
- Official doc for converting from different sources to Hg : [mercurial.selenic.com/wiki/ConvertExtension](http://mercurial.selenic.com/wiki/ConvertExtension)
- `pre-revprop-change.bat` adapted for Windows from  : [chestofbooks.com/computers/revision-control/subversion-svn/Repository-Replication-Reposadmin-Maint-Replication.html](http://chestofbooks.com/computers/revision-control/subversion-svn/Repository-Replication-Reposadmin-Maint-Replication.html)
