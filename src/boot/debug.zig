const root = @import("../root.zig");

const utils = @import("utils.zig");
const text_output = @import("text_output.zig");

const efi = root.Standard.uefi;



pub fn HALTERR(e: anyerror, out: text_output.TextOutput) void
{
    const name = @errorName(e);

    _ = out.writeString(name, true) catch {};
    
    utils.HALT_SYSTEM();
}