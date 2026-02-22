const root = @import("root.zig");

const self = root.TetoEFI.boot;



pub fn main() self.efi.Error!void
{
    self.mainFunc() catch
    {
        self.utils.NO_OPERATION();
    };
}