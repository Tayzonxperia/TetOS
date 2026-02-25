// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
// ------------------------------------------------
// Architecture specific code for the TetoEFI bootloader
// ------------------------------------------------
const root = @import("../../root.zig");

const builtin = root.Standard.builtin;



pub const Assembly = switch (builtin.cpu.arch)
{
    .x86, .x86_64 => @import("X86/assembly.zig"),
    .arm => @import("ARM/assembly.zig"),
    .aarch64, .aarch64_be => @import("AARCH64/assembly.zig"),
    .riscv32, .riscv64 => @import("RISCV/assembly.zig"),
    .mips, .mips64, .mips64el => @import("MIPS/assembly.zig"),
    .powerpc, .powerpcle, .powerpc64, .powerpc64le => @import("PPC/assembly.zig"),
    else => @compileError("Unsupported architecture")   
};
