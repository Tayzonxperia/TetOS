// The main root module for the TetOS project 
// Copyright - 2025/2026 - Taylor (Wakana Kisarazu)



/// Standard
/// --------
/// This holds code and modules from what is considered
/// as the Zig standard library. This code is essential 
/// for TetOS, both the kernel and bootloader rely on 
/// these functions. This is possible because the Zig
/// standard library was built with bare-metal in mind.
/// The Standard struct includes the following:
/// 
/// - std       --> The main standard library functions.
/// - builtin   --> Functions built into the language and compiler.
/// - mem       --> Functions and allocator for handling memory.
/// - fmt       --> Functions for formatting strings and buffers.
/// - uefi      --> The UEFI library, derived from C.
/// - coff      --> Functions for manipulation PE/COFF binaries.
/// - unicode   --> Functions for managing UTF strings.
/// - debug     --> The debugger routines, optional but nice to have.
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

    // (USE WITH CAUTION)
    const isDebug = true; 

    /// Debug functions
    pub const debug = if(isDebug) std.debug else null;
};

/// KasaneKernel
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

/// TetoEFI
/// -------
pub const TetoEFI = struct 
{
    /// EFI bootloader core functions
    pub const boot = @import("boot/main.zig");
};

/// Common
/// ------
/// Everything in this struct should only be here if the following is true
/// 
/// - The base function has a long name
/// - The function is used often
/// - It is used by many code imports  
pub const Common = struct 
{

    // Common UTF16 functions
    // ----------------------
    /// toUtf16Str converts a UTF-8 string literal to a UTF-16 string literal       - This is a comptime function
    pub const toUtf16Str = Standard.unicode.utf8ToUtf16LeStringLiteral;    
    /// toUtf16Buf converts a UTF-8 buffer to a UTF-16 buffer (null-terminated)     - This is a runtime function     
    pub const toUtf16Buf = Standard.unicode.utf8ToUtf16LeAllocZ;    

    // Common debug functions
    // ----------------------
    // These will be `null` if Standard.debug is not defined (or null), hence the double checks
    /// debugAssert causes undefined behaviour when `ok` is `false` for testing purposes
    pub const debugAssert = if (Standard.debug) Standard.debug.assert else null;
    /// debugPanic causes a panic when triggered for testing purposes
    pub const debugPanic = if (Standard.debug) Standard.debug.panic else null;
    /// debugPanicExtra causes a panic when triggered for testing purposes, just with more traces than the former
    pub const debugPanicExtra = if (Standard.debug) Standard.debug.panicExtra else null;
};