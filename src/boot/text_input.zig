// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
const root = @import("../root.zig");

const utils = @import("utils.zig");
const text_output = @import("text_output.zig");

const efi = root.Standard.uefi;



/// textInputProtocol
/// ------------------
/// A shortand for `efi.protocol.SimpleTextOutput`
pub const textInputProtocol = efi.protocol.SimpleTextInput;


/// key
/// ---
/// A shorthand for `efi.protocol.SimpleTextOutput.Key`
pub const key = efi.protocol.SimpleTextInput.Key;


/// TextInput
/// ---------
/// The UEFI SimpleTextInput. An abstraction
/// provided by UEFI firmware over the keyboard
/// device, allowing easier use.
pub const TextInput = struct 
{   
    /// The protocol for SimpleTextInput
    protocol: ?*textInputProtocol,

    /// The error union for
    /// TextInput.
    /// 
    /// `Memory`        -> 
    /// A memory failure was encountered. \
    /// `Device`        ->
    /// A device failure was encountered. \
    /// `NotReady`      ->
    /// The device is not ready to use. \
    /// `InvalidParam`  ->
    /// A invalid parameter was passed. \
    /// `Protocol`      ->
    /// The protocol failed to init. \
    /// `Unsupported`   -> 
    /// A unsupported operation occured. \
    /// `Undefined`     ->
    /// A unexpected error occured.
    pub const Error = error
    {
        Memory,
        Device,
        NotReady,
        InvalidParam,
        Protocol,
        Unsupported,
        Undefined
    };

    /// init
    /// ----
    /// This function is the init sequence for this struct. \
    /// This has to be ran before using this struct.    
    pub fn init(selfIn: ?*textInputProtocol) Error!@This()
    {
        // Resolve the protocols.
        const protocol = selfIn orelse return Error.Protocol;

        // Reset the keyboard.
        // This might fail, so panic if it does.
        protocol.reset(true) catch @panic("[!] Keyboard reset failure");

        // Return the struct, with all
        // the data filled in.
        return @This()
        {
            .protocol = protocol
        };
    }

    /// readInput
    /// ---------
    /// This function reads the input from the input
    /// device and returns it.
    pub fn readInput(self: @This()) Error!key.Input
    {   
        // Resolve protocol.
        const protocol = self.protocol orelse return Error.Protocol;

        // Get the keystroke.
        const input = protocol.readKeyStroke() catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.NotReady => return Error.NotReady,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined
        };

        // Return it.
        return input;
    }

    /// readInputUntil
    /// --------------
    /// This function reads the input from the input device
    /// until the specified char is encountered. \
    /// This is blocking.
    pub fn readInputUntil(self: @This(), char: u16) Error!void
    {
        // Resolve protocol.
        const protocol = self.protocol orelse return Error.Protocol;

        while (true)
        {   
            // Get the keystroke.
            const input = protocol.readKeyStroke() catch |e| switch (e)
            {
                error.DeviceError => return Error.Device,
                error.NotReady => continue,  // Attempt until ready
                error.Unsupported => return Error.Unsupported,
                else => return Error.Undefined
            };

            // Break if input is the char provided.
            if (input.unicode_char == char)
            { break; }
        }
    }

    /// inputToConsole
    /// --------------
    /// This function reads input from the input device and prints each char
    /// to the set console until Ctrl+X is encountered. \
    /// This function supports backspace and newlines, and can essentially
    /// function as a small text editor.
    pub fn inputToConsole(self: @This(), out: text_output.TextOutput) Error!void
    {   
        // Resolve protocol.
        const protocol = self.protocol orelse return Error.Protocol;

        while (true)
        {   
            // Get the keystroke.
            const input = protocol.readKeyStroke() catch |e| switch (e)
            {   
                error.DeviceError => return Error.Device,
                error.NotReady => continue, // Try until ready
                error.Unsupported => return Error.Unsupported,
                else => return Error.Undefined
            };

            // Break if Ctrl+X just like
            // GNU Nano!
            if (input.unicode_char == 24)
            { break; }

            // Print newline if '\r'.
            if (input.unicode_char == '\r')
            { _ = out.writeString("\r\n", false) catch {}; }

            // If regular input.
            if (input.unicode_char != 0)
            {   
                // Cast it, then create a temporary
                // 1-byte slice to print.
                const ch: u8 = @intCast(input.unicode_char);
                const sli: []const u8 = &[_]u8{ch};
                    
                // Write the slice.
                _ = out.writeString(sli, false)
                catch |e| switch (e)
                {
                    error.Device => return Error.Device,
                    error.Unsupported => return Error.Unsupported,
                    else => return Error.Undefined
                };
            }
        }
    }
};
