---
layout: post
title: "Python versus Shell scripting : from experience"
date: 2015-11-08 14:24:13 +0100
permalink: articles/python-versus-shell-scripting-experience
tags: python scripting shell
---
![Python vs Shell](/assets/blog/Selection_008.png)

A quick "pros & cons" to choose between Python or Shell scripting, from what I've observed through the years.

This could probably apply to [other high level script languages][1] vs shell.

[1]: # "Like Ruby, but not like Perl, as it shares more with shells from my point of view, like unreadable syntax and execution speed."

## Choose Python for :

- **its simple syntax** : can be read even by non Python-speaking people. End users may not be scared to change scripts to fit their need.
- **portability** : Python is actually more portable than shell because of ease of installation for any OS. Shell is theoretically portable but it's complicated to explain end users how to install the runtime (e.g. see cygwin). A Python script can be packaged into an executable program. There may be ways to bundle a script with the shell runtime.

## Choose Shell for :

- **speed** : except in case of bad code logic, shell scripts are usually a lot faster than Python's equivalents.
- **its ease to deal with external programs and system** : shell's syntax is already made to test/pipe/chain easily existing programs, whereas Python requires some extra boilerplate. Shell also has built-in functions to deal directly with files and the system, whereas Python uses an object-oriented model, which may not be as handy.
