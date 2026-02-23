// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)

/// Standard
/// --------
pub const Standard = struct 
{   
    /// Main standard functions
    pub const std = @import("std");

    /// Built-in functions
    pub const builtin = std.builtin;

    /// Build system functions
    pub const build = std.Build;

    /// Host target functions
    pub const target = std.Target;

    /// Build step functions
    pub const step = std.Build.Step;

    /// Memory functions
    pub const mem = std.mem;

    /// Mathamatical functions
    pub const math = std.math;

    /// Formatting functions
    pub const fmt = std.fmt;
    
    /// Debug functions
    pub const debug = std.debug;
};