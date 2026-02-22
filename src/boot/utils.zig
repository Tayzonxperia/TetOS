const root = @import("../root.zig");





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


