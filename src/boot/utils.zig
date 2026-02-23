const root = @import("../root.zig");

const text_output = @import("text_output.zig");


/// HANG_SYSTEM
/// -----------
/// HANG_SYSTEM decompiles to a
/// `pause` instruction.
pub inline fn HANG_SYSTEM() void
{
    while (true)
    {
        asm volatile
        (
            \\pause
        );
    }
}


/// HALT_SYSTEM
/// -----------
/// HALT_SYSTEM decompiles to a
/// `clt` and a `hlt` instruction.
pub inline fn HALT_SYSTEM() void
{
    asm volatile
    (
        \\cli
        \\hlt
    );
}


/// NO_OPERATION
/// ------------
/// NO_OPERATION decompiles to a 
/// `nop` instruction.
pub inline fn NO_OPERATION() void
{
    asm volatile 
    (
        \\nop
    );
}


/// BREAKPOINT
/// ----------
/// BREAKPOINT is a debug function and prints a error
/// to the console, so we can verify and trace errors
pub noinline fn BREAKPOINT(e: anyerror, out: text_output.TextOutput) void
{
    const name = @errorName(e);

    _ = out.writeString(name, true) catch {};
    
    HALT_SYSTEM();
}