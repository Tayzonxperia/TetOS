const root = @import("root.zig");

const self = root.TetoEFI.boot;



pub fn main() self.efi.Error!void
{
    self.mainFunc() catch
    {
        self.assembly.NO_OPERATION();
    };
}