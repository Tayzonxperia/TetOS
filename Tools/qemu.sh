#!/bin/bash



qemu-system-x86_64 -m 64 -serial stdio -bios Tools/firmware-x86.fd \
-drive format=raw,file=fat:rw:Target/Debug -d in_asm
