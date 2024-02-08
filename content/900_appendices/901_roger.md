---
title: '901 - Roger & Chip'
weight: 901
---

Within the Engineering Technology program it is sometimes needed to have access to a server. For this purpose, **Roger** was born. On this server several virtual machines are running. For this course, students can use **chip**.

This server is accessible over the Internet. To be able to connect to the virtual machines **a VPN connection** is required. You have received (or will receive) an email that contains your username and password.


## OpenVPN-ing

To connect to Roger's VPN server, a VPN client should be used (e.g. [putty](https://www.putty.org/)). In case a GUI will be used, an Xserver should be run on your machine. [MobaXterm](https://mobaxterm.mobatek.net/) is a tool that provides both an SSH client and an Xserver.

Log in on **Roger** which lives at **193.190.58.21** on **port 2222** with your login and **<u>change your password</u>**. 

> [jovliegen@roger ~]$ passwd



## Makefile for cross compiling

In the Makefile of the example (found [here](https://github.com/KULeuven-Diepenbeek/course_hwswcodesign/blob/master/src/100/firmware/Makefile)), the cross compiler is set like this:

The specific version which was used from GitHub:

> RISCV_GNU_TOOLCHAIN_GIT_REVISION = 8c969a9

The path to the installation:

> RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv

The fixed prefix to the executables, using the previously set variable:

> TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv32-unknown-elf-
