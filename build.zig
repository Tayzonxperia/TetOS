// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)

const root = @import("build/root.zig");

const configuration = @import("build/configuration.zig");
const executables = @import("build/executables.zig");
const artifacts = @import("build//artifacts.zig");

const std = root.Standard.std;
const builtin = root.Standard.builtin;
const b = root.Standard.build;
const step = root.Standard.step;

const ConfigProfile = configuration.ConfigProfile;
const ExecutableType = executables.ExecutableType;

const loadConfig = configuration.loadConfig;
const loadExecutable = executables.loadExecutable;
const setTargetDirectory = executables.setTargetDirectory;
const loadInstall = artifacts.loadInstall;




pub fn build(builder: *b) void
{
    const config = loadConfig(builder);

    const tetoefi = loadExecutable(builder, config, .Bootloader);
    const kasanekernel = loadExecutable(builder, config, .Kernel);

    builder.exe_dir = setTargetDirectory(config);

    const installTetoefi = loadInstall(builder, tetoefi);
    const installKasanekernel = loadInstall(builder, kasanekernel);

    builder.getInstallStep().dependOn(@constCast(&installTetoefi.step));
    builder.getInstallStep().dependOn(@constCast(&installKasanekernel.step));
}