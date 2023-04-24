---
title: '901 - Roger'
weight: 901
---

Within the Engineering Technology program it is sometimes needed to have access to a server. For the purpose, **Roger** was born.

This server is accessible over the Internet through SSH. You have received (or will receive) an email that contains your username and password.


## SSH-ing

To connect to Roger, an SSH client should be used (e.g. [putty](https://www.putty.org/)). In case a GUI will be used, an Xserver should be run on your machine. [MobaXterm](https://mobaxterm.mobatek.net/) is a tool that provides both an SSH client and an Xserver.

Log in on **Roger** which lives at **193.190.58.21** on **port 2222** with your login and **<u>change your password</u>**. 

> [jovliegen@roger ~]$ passwd



## Makefile for cross compiling

In the Makefile of the example (found [here](https://github.com/KULeuven-Diepenbeek/hwswcodesign-labs)), the cross compiler is set like this:

> RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32

> TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)i/bin/riscv32-unknown-elf-

