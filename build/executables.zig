// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)

const root = @import("root.zig");

const configuration = @import("configuration.zig");

const std = root.Standard.std;
const builtin = root.Standard.builtin;
const build = root.Standard.build;

const ConfigProfile = configuration.ConfigProfile;



pub const ExecutableType = enum 
{
    Bootloader,
    Kernel
};


pub fn loadExecutable(builder: *build, config: ConfigProfile, exe: ExecutableType) *build.Step.Compile 
{
    return switch (exe) 
    {
        .Bootloader => builder.addExecutable
        (
            .{
                .name = "bootx64",
                .root_module = builder.createModule
                (
                    .{
                        .root_source_file = builder.path("src/tetoefi.zig"),
                        .target = config.bootloaderTarget,
                        .optimize = config.optimize
                    }
                )
            }
        ),

        .Kernel => builder.addExecutable
        (
            .{
                .name = "kasanekernel",
                .root_module = builder.createModule
                (   
                    .{
                        .root_source_file = builder.path("src/kasanekernel.zig"),
                        .target = config.kernelTarget,
                        .optimize = config.optimize
                    }
                )
            }
        )
    };
}


pub fn setTargetDirectory(config: ConfigProfile) []const u8
{   
    return switch (config.optimize)
    {
        .Debug => "Target/Debug/EFI/BOOT",
        .ReleaseSafe => "Target/ReleaseSafe/EFI/BOOT",
        .ReleaseSmall => "Target/ReleaseSmall/EFI/BOOT",
        .ReleaseFast => "Target/ReleaseFast/EFI/BOOT"
    };
}