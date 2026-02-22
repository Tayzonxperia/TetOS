const root = @import("../root.zig");

const efi = root.Standard.uefi;




pub const SystemCtx = struct 
{
    /// UEFI system table
    /// -----------------
    /// Contains pointers and structs to the various other
    /// UEFI firmware services this is passed to the EFI 
    /// main entry point upon application start
    systemTable: *efi.tables.SystemTable,


    /// UEFI main boot services
    /// -----------------------
    /// The UEFI boot services are the main way of
    /// interacting with the UEFI firmware, this is 
    /// a part of the systemTable struct - It is known
    /// that the boot services will become unavailable 
    /// after exitBootServices() is called - according 
    /// to UEFI documentation and specification
    bootServices: ?*efi.tables.BootServices,


    /// UEFI main runtime services
    /// --------------------------
    /// The UEFI runtime services are another way of
    /// interacting with the UEFI firmware, this is
    /// a part of the systemTable struct - It is known
    /// that the runtime services will still be available
    /// after exitBootServices() is called - accoring 
    /// to UEFI documentation and specification
    runtimeServices: *efi.tables.RuntimeServices,


    /// UEFI config table
    /// -----------------
    /// The UEFI configuration table 
    configTable: [*]efi.tables.ConfigurationTable,


    /// UEFI table header
    tableHeader: efi.tables.TableHeader,


    /// UEFI table entry count                                
    tableEntryCount: usize,


    /// UEFI provided firmware vendor string
    firmwareVendor: [*:0]const u16,


    /// UEFI provided firmware revision string
    firmwareRevision: u32
};


pub fn systemInit() SystemCtx
{   
    return
    .{
        .systemTable = efi.system_table,
        .bootServices = efi.system_table.boot_services,
        .runtimeServices = efi.system_table.runtime_services,
        .configTable = efi.system_table.configuration_table,
        .tableHeader = efi.system_table.hdr,
        .tableEntryCount = efi.system_table.number_of_table_entries,   
        .firmwareVendor = efi.system_table.firmware_vendor,
        .firmwareRevision = efi.system_table.firmware_revision     
    };
}




