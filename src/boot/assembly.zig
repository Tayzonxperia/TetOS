// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
// ------------------------------------------------
// Assembly code needed for the TetoEFI bootloader
// ------------------------------------------------
const root = @import("../root.zig");

const builtin = root.Standard.builtin;


/// HANG_SYSTEM
/// -----------
/// HANG_SYSTEM decompiles to a
/// `pause` instruction.
/// ---------------------------
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


/// HALT_SYSTEM
/// -----------
/// HALT_SYSTEM decompiles to a
/// `cli` and a `hlt` instruction.
/// ------------------------------
pub inline fn HALT_SYSTEM() void
{
    asm volatile
    (
        \\cli
        \\hlt
    );
}


/// NO_OPERATION
/// ------------
/// NO_OPERATION decompiles to a 
/// `nop` instruction.
/// ----------------------------
pub inline fn NO_OPERATION() void
{
    asm volatile 
    (
        \\nop
    );
}