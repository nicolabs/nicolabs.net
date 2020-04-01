---
layout: post
date: 2012-07-30 13:09:50 +0100
title: Building PyCrypto for Win32
permalink: articles/building-pycrypto-win32
tags:
  - cryptography
  - MinGW
  - python
  - Windows
maturity: deprecated
---

> This article contains instructions to build PyCrypto 2.6 for Windows XP (32 bits).

![Python logo](/assets/blog/python-logo-master-v3-TM-flattened-75.png)

The [PyCrypto](https://www.dlitz.net/software/pycrypto/) library provides Python with implementation for a lot of algorithms for cryptography. It's very useful.

Ubuntu has it by default but if you want to have it for Python 3.2 on Windows, you must use [Active Python](http://www.activestate.com/activepython), as there is no other binary release for Python 3.2 on the web.

In case you want to use the official Python distribution or if ActiveState did not (yet) released a PyCrypto for the version of Python you are using, this article might help you by putting together the steps to build it from source.

Also attached : a binary `.exe` for the impatients : [pycrypto-2.6.win32-py3.2_0.exe](/assets/blog/pycrypto-2.6.win32-py3.2_0.exe).


## Building on Windows XP 32bits

First install *Python* if not already done : [www.python.org/download](http://www.python.org/download/).

*PyCrypto* is an open source project so just get the package as well and unzip it : [www.dlitz.net/software/pycrypto](https://www.dlitz.net/software/pycrypto).

In order to fix a bug with *distutils* and the latest version of the compiler, edit `<Python32_root>/Lib/distutils/cygwinccompiler.py` by removing all occurrences of `-mno-cygwin` (this option has been removed in the latest versions).

Building PyCrypto requires a native compiler. By default it asks for *Visual Studio* but we will use *MinGW* :

1. Install MinGw32 from [sourceforge.net/projects/mingw](http://sourceforge.net/projects/mingw/files/latest/download?source=files)
2. Make sure to install "C++ compiler", "C compiler" (not sure if it's required) and "MSYS Basic System"
3. Open a console with `<MinGW_root>/msys/1.0/msys.bat` (will give you an already set up *PATH*)

In this console type the following distutils command from the unzipped directory of PyCrypto :

```shell
python setup.py build --compiler=mingw32 install
```

And you're done : **PyCrypto installed !**

> If you are just looking for the binary release, I've attached [the installer for Win 32](/assets/blog/pycrypto-2.6.win32-py3.2_0.exe). This is probably not an optimized binary as the compilation produced the following message : `warning: GMP or MPIR library not found; Not building Crypto.PublicKey._fastmath`...


## Errors you might encounter

### TypeError: unorderable types: NoneType() >= str()

`gcc.exe` is not in the PATH ([bugs.python.org/issue8384](http://bugs.python.org/issue8384)). Use `msys.bat` or put all necessary tools in your PATH.

### RuntimeError: chmod error

`chmod.exe` is not in the PATH (or *MSYS* is not installed)

### IOError: Unable to find vcvarsall.bat

*Visual Studio* is not installed ([bugs.python.org/issue2698](http://bugs.python.org/issue2698)). Use `--compiler=mingw32`.


## References

- “Unable to find vcvarsall.bat” error when trying to install rdflib" - [blog.eddsn.com/2010/05/unable-to-find-vcvarsall-bat/](http://blog.eddsn.com/2010/05/unable-to-find-vcvarsall-bat/)
- An alternative ? Get binaries with pypm - [stackoverflow.com/questions/1687283/why-cant-i-just-install-the-pycrypto](http://stackoverflow.com/questions/1687283/why-cant-i-just-install-the-pycrypto)
- ActiveState's Python distribution - [www.activestate.com/activepython](http://www.activestate.com/activepython)
- Distutils bug - [bugs.python.org/issue12641](http://bugs.python.org/issue12641)
- About Cygwin options - [www.delorie.com/howto](http://www.delorie.com/howto)
