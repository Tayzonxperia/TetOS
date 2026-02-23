# The TetOS Project

####  Kimi wa jitsu ni baka dana!

---

## Contents

1. [Overview](#overview)
2. [Progress](#progress)
3. [Building](#building)
4. [Contributing](#contributing)
5. [Legalities](#legalities)
6. [Licence](#licence)
7. [Acknowledgements](#acknowledgements)

---

## Overview

**The TetOS Project** is an open-source kernel and bootloader - soon to be a full operating
system.


The kernel is written in:
- Zig
- Assembly

The bootloader is written in:
- Zig
- Assembly

The build system is written in:
- Zig
- Nim
- Shell (Bash)


Made for the UTAUloid and chimera **Kasane Teto**. It aims to bring new meaning to what a
operating system can be, inspired by Terry Davis' TempleOS


#### Project artifacts:

- TetoEFI (`bootx64.efi`)

TetoEFI is the bootloader for the TetOS project

- KasaneKernel (`kasanekernel`)

KasaneKernel is the kernel for the TetOS project


> TetOS only plans to support x86_64 desktop computers currently, and only supports
building on a x86_64 GNU/Linux machine, but this may change in the future. (Other 
types of systems may work but will not be tested)

---

## Progress

**The current progress of TetOS is as follows:**

- [X] TetoEFI started
- [ ] KasaneKernel started


### TetoEFI

- [X] Program functional

- [X] UEFI intergration

    - [X] BootService

        - [ ] Boot service handling
        - [ ] Exit boot service support

    - [X] SimpleTextOutput 

        - [X] Stdout console
        - [X] Stderr console
        - [X] Hardware resetting
        - [X] Device modesetting
        - [X] Console geometry 

    - [X] SimpleTextInput

        - [X] Stdin console
        - [X] Hardware resetting
        - [X] Device modesetting
        - [X] Unicode input support
        - [ ] Scancode input support

    - [X] GraphicsOutput

        - [X] Block transfer
        - [ ] Location-based block transfer
        - [X] Hardware resetting
        - [X] Device modesetting
        - [X] Screen painting 
        - [ ] Animation refresh/loop

    - [ ] SerialIo

        - [ ] QEMU stdio serial support 
        - [ ] Hardware resetting

- [ ] Filesystem 

    - [ ] Read
    - [ ] Write
    - [ ] Directory
    - [ ] Metadata
    - [ ] 4GB+ support

- [ ] Kernel loading

    - [ ] Memory mapping
    - [ ] Boot cmdline passing
    - [ ] Jumping into execution

### KasaneKernel

- [ ] Program functional

---

## Building

**The following are instructions and explainations of the TetOS build system
and how to build a TetOS image**

- None currently. The build system `tetostrap` is still in development. 
- Any attempts to compile shall be done by naviagting to `src` and running `zig build`
- Then, to run in QEMU, go to the project root and run `./run.sh`

---

## Contributing

You are intrested in developing for the TetOS Project?

**Please see CONTRIBUTING.md for infomation**

---

## Legalities

The TetOS Project may include or display copyrighted content inspired by 3rd-party
works, such as the character **Kasane Teto**. These works remain property of their
respective copyright holders. The TetOS Project's authors or contributors do **not
claim ownership** of such content.

**This project is purely fan-made and is in no way associated with TWINDRILL or Crypton
Future Media, Inc.**

For information regarding Kasane Teto’s usage, licensing, and permissions, please 
see the official guideline: [Kasane Teto CTU][CTU]. 
The PCL license applies mutatis mutandis to these elements.

All original code, design and resources created specifically for TetOS are licenced
under [LICENSE](LICENSE), for details and possible exceptions - see below.

---

## Licence

**Copyright (C) 2025-2026 Taylor Johnson (Wakana Kisarazu / Tayzonxperia).**

***All rights reserved.***


> This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free 
Software Foundation; either version 2 of the License, or (at your option) 
any later version


#### For the licence the TetOS Project is under, see [LICENCE](LICENCE) and for full details about copyright, see [COPYING](COPYING)

---

## Acknowledgements

#### For licences of other software that may be under a different licence to the TetOS Project licence, see [Licences](Licences)


- [EDK2 OVMF Firmware](EDK2) - [(Licence)](Licences/LICENCE-EDK2) - For the OVMF firmware required to run TetOS in a virtual machine.


[CTU]: https://kasaneteto.jp/guideline/ctu.html "Kasane Teto CTU"
[EDK2]: https://github.com/tianocore/edk2 "EDK2 Github Repository"