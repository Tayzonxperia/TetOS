// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
const root = @import("../root.zig");

pub const system = @import("system.zig");
pub const utils = @import("utils.zig");
pub const text_output = @import("text_output.zig");
pub const text_input = @import("text_input.zig");
pub const graphics = @import("graphics.zig");
pub const efi = root.Standard.uefi;
pub const core = @import("core.zig");


pub fn mainFunc() efi.Error!void
{   
    const systemCtx = system.systemInit();
    const systemTable = systemCtx.systemTable;
    const bootSvc = systemTable.boot_services.?;
    const bootsvc = systemTable.boot_services;

    // Initzalize default structs
    var systable = core.SystemTable
    {};

    var bootservice = core.BootServices
    {};

    var output = text_output.TextOutput
    {
        .stdOut = .{},
        .stdErr = .{}
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

    // Locate the protocols
    const outputProtocol = bootSvc.locateProtocol(efi.protocol.SimpleTextOutput, null)
    catch |e| switch (e)
    { 
        error.InvalidParameter => return efi.Error.InvalidParameter,
        error.Unexpected => unreachable,
    };

    const inputProtocol = bootSvc.locateProtocol(efi.protocol.SimpleTextInput, null)
    catch |e| switch (e)
    {
        error.InvalidParameter => return efi.Error.InvalidParameter,
        error.Unexpected => @panic("[!] Failed to locate input protocol"),
    };

    const gopProtocol = bootSvc.locateProtocol(efi.protocol.GraphicsOutput, null) 
    catch |e| switch (e)
    {
        error.InvalidParameter => return efi.Error.InvalidParameter,
        error.Unexpected => return efi.Error.Unexpected,
    };

    // Initzalize the structs fully
    systable = core.SystemTable.init(systemTable);

    bootservice = core.BootServices.init(bootsvc);

    output = text_output.TextOutput.init(systemTable.con_out.?, systemTable.std_err.?, true)
    catch unreachable;

    input = text_input.TextInput.init(systemTable.con_in.?)
    catch @panic("[!] Failed to setup input protocol");

    gop = graphics.GraphicsOutput.init(gopProtocol.?) 
    catch { return utils.HALT_SYSTEM(); };

    // dud
    _ = outputProtocol.?;
    _ = inputProtocol.?;
  
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
    catch { return utils.HALT_SYSTEM(); };

    _ = gop.paintScreen(pixel[0..])
    catch { return utils.HALT_SYSTEM(); };

    _ = input.inputToConsole(output) catch {};

    utils.HANG_SYSTEM();
}