// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)

const root = @import("root.zig");

const std = root.Standard.std;
const builtin = root.Standard.builtin;
const build = root.Standard.build;
const target = root.Standard.target;



pub const ConfigProfile = struct 
{
    experimental:   bool,
    fancy:          bool,
    serial:         bool,
    optimize:       builtin.OptimizeMode,

    // Separate targets
    bootloaderTarget:   build.ResolvedTarget,
    kernelTarget:       build.ResolvedTarget
};


pub fn loadConfig(builder: *build) ConfigProfile
{   
    const experimentalFeatures = builder.option
    (bool, "experimental", "Enable experimental features") orelse false;

    const fancyFeatures = builder.option
    (bool, "fancy", "Enable fancy features") orelse false;

    const serialSupport = builder.option
    (bool, "serial", "Enable serial support") orelse false; 

    const optimizeMode = builder.standardOptimizeOption
    (
        .{
            .preferred_optimize_mode = .Debug
        }
    );

    const archType = builder.option
    (target.Cpu.Arch, "arch", "Target CPU architecture")
    orelse .x86_64;

    const bootloaderTarget = builder.resolveTargetQuery
    (
        .{
            .cpu_arch = archType,
            .os_tag = .uefi,
            .abi = .none 
        }
    );

    const kernelTarget = builder.resolveTargetQuery
    (
        .{
            .cpu_arch = archType,
            .os_tag = .freestanding,
            .abi = .none 
        }
    );

    if (builder.args == null)
    {
        std.debug.print
        (   
            \\  |=======================================|
            \\  |          TetOS configuration          |
            \\  |=======================================|             
            \\  
            \\  Experimental:   {}
            \\  Fancy:          {}
            \\  Serial:         {}
            \\
            \\  Build mode:     {}
            \\  Architecture:   {}
            \\
            \\  Bootloader:
            \\      -> OS Tag:  {}
            \\      -> ABI:     {}
            \\
            \\  Kernel:
            \\      -> OS Tag:  {}
            \\      -> ABI:     {}
            \\
            
            ,.{
                experimentalFeatures,
                fancyFeatures,
                serialSupport,

                optimizeMode,
                archType,

                bootloaderTarget.result.os.tag,
                bootloaderTarget.result.abi,

                kernelTarget.result.os.tag,
                kernelTarget.result.abi
            }
        );
    }

    return
    .{
        .experimental = experimentalFeatures,
        .fancy = fancyFeatures,
        .serial = serialSupport,
        .optimize = optimizeMode,

        // Separate targets
        .bootloaderTarget = bootloaderTarget,
        .kernelTarget = kernelTarget
    };
}


pub fn loadOptions(builder: *build, config: ConfigProfile) *build.Step.Options
{
    const options = builder.addOptions();

    options.addOption(bool, "experimental", config.experimental);
    options.addOption(bool, "fancy", config.fancy);
    options.addOption(bool, "serial", config.serial);

    return options;
}