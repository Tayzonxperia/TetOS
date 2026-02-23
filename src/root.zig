// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)



/// Standard
/// --------
pub const Standard = struct 
{   
    /// Main standard functions
    pub const std = @import("std");

    /// Built-in functions
    pub const builtin = @import("builtin");

    /// Memory functions
    pub const mem = std.mem;

    /// Mathamatical functions
    pub const math = std.math;

    /// Formatting functions
    pub const fmt = std.fmt;
    
    /// UEFI functions
    pub const uefi = std.os.uefi;

    /// PE/COFF functions
    pub const coff = std.coff;

    /// Unicode functions
    pub const unicode = std.unicode;

    /// Debug functions
    pub const debug = std.debug;
};

/// Kasanekernel
/// ------------
pub const KasaneKernel = struct 
{
    /// Kernel core functions
    pub const kern = @import("kern/main.zig");

    /// Kernel init functions
    pub const init = @import("init/main.zig");

    /// Kernel memory functions
    pub const mm = @import("mm/main.zig");

    /// Kernel driver functions
    pub const drv = @import("drv/main.zig");

    /// Kernel filesystem functions
    pub const fs = @import("fs/main.zig");

    /// Kernel headers
    pub const hdr = @import("hdr/main.zig");
};

/// Tetoefi
/// -------
pub const TetoEFI = struct 
{
    /// EFI bootloader core functions
    pub const boot = @import("boot/main.zig");
};

