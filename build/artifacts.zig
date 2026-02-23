// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)

const root = @import("root.zig");

const configuration = @import("configuration.zig");
const executables = @import("executables.zig");

const std = root.Standard.std;
const builtin = root.Standard.builtin;
const build = root.Standard.build;
const step = root.Standard.step;

const compileStep = build.Step.Compile;
const InstallArtifact = build.Step.InstallArtifact;



pub fn loadInstall(builder: *build, compile: *compileStep) *InstallArtifact
{
    builder.default_step.dependOn(&compile.step);

    return builder.addInstallArtifact
    (
        compile,    
    .{
        .dest_dir = .default
        }
    );
}
