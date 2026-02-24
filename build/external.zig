// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)

const root = @import("root.zig");

const configuration = @import("configuration.zig");
const executables = @import("executables.zig");

const std = root.Standard.std;
const builtin = root.Standard.builtin;
const build = root.Standard.build;



pub const ImageFormat = struct 
{
    Blue: u8,
    Green: u8,
    Red: u8,
    Reserved: u8    // Optional alpha
};

pub fn convertImageData(builder: *build, image: []const u8) ImageFormat
{
    
}