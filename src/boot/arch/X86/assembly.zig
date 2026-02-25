// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
// ------------------------------------------------
// Assembly code needed for the TetoEFI bootloader
// ------------------------------------------------



pub inline fn HANG_SYSTEM() void
{
    while (true)
    {
        asm volatile
        (
            \\pause
        );
    }   
}


pub inline fn HALT_SYSTEM() void
{
    asm volatile
    (
        \\cli
        \\hlt
    );
}


pub inline fn NO_OPERATION() void
{
    asm volatile 
    (
        \\nop
    );
}