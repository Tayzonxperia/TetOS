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
            \\fence
        );
    }
}


pub inline fn HALT_SYSTEM() void
{
    asm volatile
    (
        \\csrci mstatus, 0x8
        \\wfi
    );
}


pub inline fn NO_OPERATION() void
{
    asm volatile 
    (
        \\nop
    );
}