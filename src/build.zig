const std = @import("std");
const builtin = @import("builtin");



/// build
/// -----
/// This function builds TetOS
/// and all its related components.
pub fn build(builder: *std.Build) void
{
    // Bootloader target options
    // -------------------------
    // - UEFI
    // - 64bit
    // - GNU ABI
    const BootloaderTarget = builder.resolveTargetQuery
    (
        .{
            .os_tag = .uefi,
            .cpu_arch = .x86_64,
            .abi = .gnu,
        },
    );

    // Kernel target options
    // ---------------------
    // - Freestanding
    // - 64bit
    // - GNU ABI
    const KernelTarget = builder.resolveTargetQuery
    (
        .{
            .os_tag = .freestanding,
            .cpu_arch = .x86_64,
            .abi = .gnu,
        },
    );
    
    // Optimization options
    // --------------------
    const Optimization = .ReleaseSmall;

    // TetoEFI (tetoefi.zig)
    // ---------------------
    const bootloader = builder.addExecutable
    (
        .{
            .name = "bootx64",
            .root_module = builder.createModule
            (
                .{
                    .root_source_file = builder.path("tetoefi.zig"),
                    .target = BootloaderTarget,
                    .optimize = Optimization,
                }
            ),
        }
    );   

    // KasaneKernel (kasanekernel.zig)
    // -------------------------------
    const kernel = builder.addExecutable
    (
        .{
            .name = "kasanekernel",
            .root_module = builder.createModule
            (
                .{
                    .root_source_file = builder.path("kasanekernel.zig"),
                    .target = KernelTarget,
                    .optimize = Optimization,
                }
            ),
        }
    );   

    // Set output directory
    // --------------------
    builder.exe_dir = "../Target/EFI/BOOT/";

    // Build the executables and depend on them 
    // ----------------------------------------
    // Swap these around so bootloader gets built first
    builder.default_step.dependOn(&bootloader.step);
    builder.default_step.dependOn(&kernel.step);


    // Install artifacts
    // -----------------
    const InstallBootloader = builder.addInstallArtifact
    (
    bootloader,
    .{
                .dest_dir = .default
            }                                                               
    );   

    const InstallKernel = builder.addInstallArtifact
    (
    kernel, 
    .{
                .dest_dir = .default
            }                                                  
    );

                            
    builder.getInstallStep().dependOn(&InstallBootloader.step);
    builder.getInstallStep().dependOn(&InstallKernel.step);

}
