#!/bin/bash



qemu-system-x86_64 -m 4096 -serial stdio -bios Target/firmware.fd \
-drive format=raw,file=fat:rw:Target/Debug -d in_asm
