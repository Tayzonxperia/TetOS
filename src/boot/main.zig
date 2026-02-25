// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
const root = @import("../root.zig");

pub const core = @import("core.zig");
pub const assembly = @import("arch/main.zig").Assembly;
pub const text_output = @import("text_output.zig");
pub const text_input = @import("text_input.zig");
pub const graphics = @import("graphics.zig");

pub const efi = root.Standard.uefi;



pub fn mainFunc() efi.Error!void
{   
    const systemTable = efi.system_table;
    const bootService = efi.system_table.boot_services;
    const configTable = efi.system_table.configuration_table;

    // Initzalize default structs
    var systable = core.SystemTable{};

    var bootsvc = core.BootServices{};

    var cfgtable = core.ConfigTable{};

    const bootservice = core.BootServices{};

    var output = text_output.TextOutput
    {
        .stdOut = 
        .{
        },
        .stdErr = 
        .{
        }
    };

    var input = text_input.TextInput
    {
        .protocol = null
    };

    var gop = graphics.GraphicsOutput
    {
        .protocol = null,
        .modeInfo = .{}
    };

    // Init core
    systable = core.SystemTable.init(systemTable);

    bootsvc = core.BootServices.init(bootService);

    cfgtable = core.ConfigTable.init(configTable);

    // Locate the protocols
    const outputProtocol = bootsvc.service.?.locateProtocol(efi.protocol.SimpleTextOutput, null)
    catch |e| switch (e)
    { 
        error.InvalidParameter => return efi.Error.InvalidParameter,
        error.Unexpected => unreachable,
    };

    const inputProtocol = bootsvc.service.?.locateProtocol(efi.protocol.SimpleTextInput, null)
    catch |e| switch (e)
    {
        error.InvalidParameter => return efi.Error.InvalidParameter,
        error.Unexpected => @panic("[!] Failed to locate input protocol"),
    };

    const gopProtocol = bootsvc.service.?.locateProtocol(efi.protocol.GraphicsOutput, null) 
    catch |e| switch (e)
    {
        error.InvalidParameter => return efi.Error.InvalidParameter,
        error.Unexpected => return efi.Error.Unexpected,
    };

    // Initzalize the structs fully
    output = text_output.TextOutput.init(systemTable.con_out.?, systemTable.std_err.?, true)
    catch unreachable;

    input = text_input.TextInput.init(systemTable.con_in.?)
    catch @panic("[!] Failed to setup input protocol");

    gop = graphics.GraphicsOutput.init(gopProtocol.?) 
    catch { return assembly.HALT_SYSTEM(); };

    // dud
    _ = outputProtocol.?;
    _ = inputProtocol.?;
    _ = bootservice;
  
    var pixel: [100*100]efi.protocol.GraphicsOutput.BltPixel = undefined;

        for (&pixel) |*p|
        {
            p.* = efi.protocol.GraphicsOutput.BltPixel
            {
                .red = 100,
                .green = 5,
                .blue = 120,
                .reserved =  0
            };
        }

    _ = output.writeString("Painting framebuffer...", true)    
    catch { return assembly.HALT_SYSTEM(); };

    _ = gop.paintScreen(pixel[0..])
    catch { return assembly.HALT_SYSTEM(); };

    _ = input.inputToConsole(output) catch {};

    const memory = core.MemoryManagement.allocPages(bootService, 16);
    
    _ = output.writeString(@ptrCast(&memory), true)
    catch unreachable;

    assembly.HANG_SYSTEM();
}