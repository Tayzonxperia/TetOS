// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
const root = @import("../root.zig");

const utils = @import("utils.zig");

const efi = root.Standard.uefi;
const utf = root.Standard.unicode.utf8ToUtf16LeStringLiteral;


/// filesystemProtocol
/// ------------------
/// A shorthand for `efi.protocol.SimpleFileSystem`
pub const filesystemProtocol = efi.protocol.SimpleFileSystem;


/// fileProtocol
/// ------------
/// A shorthand for `efi.protocol.File`
pub const fileProtocol = efi.protocol.File;


/// openMode
/// --------
pub const openMode = efi.protocol.File.OpenMode;


/// attributes
/// ----------
pub const attributes = efi.protocol.File.Attributes;


/// FileSystem
/// -----------
pub const FileSystem = struct 
{
    /// The protocol for SimpleFileSystem
    protocol: ?*filesystemProtocol,

    /// The filesystem info.
    fsInfo: struct
    {   
        /// Revision version
        revision: u64 = 1,

        protocolFile: *fileProtocol
    },

    /// The error union we use for
    /// SimpleFileSystem and File 
    pub const Error = error
    {
        Memory,
        Device,
        NoMedia,
        ChangedMedia,
        Corrupted,
        Denied,
        Protocol,
        Unsupported,
        Undefined
    };

    /// init
    /// ----
    /// This function is the init sequence for this protocol. \
    /// This has to be ran before use of this struct.
    pub fn init(self: ?*filesystemProtocol) Error!@This()
    {
        // Resolve the protocol.
        // If the protocol gets passed null, this means that locateProtocol failed
        // to find SimpleFileSystem, therefore we can conclude it doesn't exist here.
        const fsysProtocol = self orelse return Error.Protocol;
        
        // Resolve the second protocol.
        // This is needed because fileProtocol isn't found like a regular protocol, but 
        // given by openVolume. Yeah stupid i know, should have just been 1 fucking protocol.
        const fProtocol = fsysProtocol.openVolume() catch |e| switch (e)
        {
            error.OutOfResources => return Error.Memory,
            error.DeviceError => return Error.Device,
            error.NoMedia => return Error.NoMedia,
            error.MediaChanged => return Error.ChangedMedia,
            error.VolumeCorrupted => return Error.Corrupted,
            error.AccessDenied => return Error.Denied
        };

        // Get the revision because why not
        const rev = fsysProtocol.revision;

        // Return the struct
        return @This()
        {
            .protocol = fsysProtocol,
            .fsInfo = 
            .{
                .revision = rev,
                .protocolFile = fProtocol
            }
        };
    }

    pub fn readFile(self: @This(), path: []const u8) Error!*fileProtocol
    {
        // Resolve protocol
        const protocol = self.fsInfo.protocolFile;

        // Open file
        const file = protocol.open(utf(path), openMode.read, attributes.read_only) catch |e| switch (e)
        {
            error.anyerror => utils.BREAKPOINT(e, "Error: ")
        };

        var buf
        file.read()
    }
};