// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
// ------------------------------------------------
// Core features needed for the TetoEFI bootloader
// ------------------------------------------------
const root = @import("../root.zig");

const assembly = @import("arch/main.zig").Assembly;

const efi = root.Standard.uefi;
const utf16Str = root.Standard.unicode.utf8ToUtf16LeStringLiteral;
const utf16Buf = root.Standard.unicode.utf8ToUtf16LeAllocZ;



/// efiError
/// --------
pub const efiError = efi.Error;


/// efiSystemTab
/// ------------
pub const efiSystemTab = @TypeOf(efi.system_table);


/// efiBootSvc
/// ----------
pub const efiBootSvc = @TypeOf(efi.system_table.boot_services);


/// efiConfigTab
/// ---------------
pub const efiConfigTab = @TypeOf(efi.system_table.configuration_table);


/// SystemTable
/// -----------
pub const SystemTable = struct 
{   
    // System table itself
    table: efiSystemTab = undefined,

    // System table header
    header: @TypeOf(efi.system_table.hdr) = undefined,

    // System table entries
    entries: @TypeOf(efi.system_table.number_of_table_entries) = undefined,

    // Firmware revision
    fwRevision: @TypeOf(efi.system_table.firmware_revision) = undefined,

    // Firmware vendor
    fwVendor: @TypeOf(efi.system_table.firmware_vendor) = undefined,

    // Init function     
    pub fn init(t: ?efiSystemTab) @This()
    {   
        // Get the system table.
        // We cannot proceed without a valid 
        // system table, so force exit now! 
        const tab = t orelse unreachable;

        // Return the data
        // fully filled
        return @This()
        {
            .table = tab,
            .header = tab.hdr,
            .entries = tab.number_of_table_entries,
            .fwRevision = tab.firmware_revision,
            .fwVendor = tab.firmware_vendor
        };
    }
};


/// BootServices
/// ------------
pub const BootServices = struct 
{   
    // Boot service itself
    service: efiBootSvc = undefined,

    // Boot services header
    header: @TypeOf(efi.system_table.boot_services.?.hdr) = undefined,

    // Init function
    pub fn init(s: efiBootSvc) @This()
    {   
        // Get the boot services.
        // We also cannot continue without valid
        // boot services, so also exit now!
        const svc = s orelse unreachable;

        // Return this
        return @This()
        {
            .service = svc,
            .header = svc.hdr
        };
    }
};


/// ConfigTable
/// -----------
pub const ConfigTable = struct 
{
    // Config table itself
    table: efiConfigTab = undefined,

    // Init function
    pub fn init(t: efiConfigTab) @This()
    {
        // Get the config table.
        const tab = t;

        // Return this
        return @This()
        {
            .table = tab
        };
    }
};


pub const MemoryManagement = struct 
{   
    pub inline fn allocPages(s: efiBootSvc, num: usize) [][4096]u8
    {   
        // Make sure boot services exist.
        const svc = s.?;

        // malloc
        const pages = svc.allocatePages(.any, .boot_services_data, num)
        catch @panic("[!] Failed to allocate pages");

        return pages;
    }   
};