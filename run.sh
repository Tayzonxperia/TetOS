#!/bin/bash



qemu-system-x86_64 -m 4096 -serial stdio -bios tools/ovmf.fd -drive format=raw,file=fat:rw:Target \
-d in_asm
