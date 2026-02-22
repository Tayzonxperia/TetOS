const root = @import("../root.zig");

const utils = @import("utils.zig");

const efi = root.Standard.uefi;



/// textOutputProtocol
/// ------------------
/// A shortand for `efi.protocol.SimpleTextOutput`
pub const textOutputProtocol = efi.protocol.SimpleTextOutput;


/// attribute
/// ---------
/// A shortand for `efi.protocol.SimpleTextOutput.Attribute`
pub const attribute = efi.protocol.SimpleTextOutput.Attribute;


/// geometry
/// --------
/// A shortand for `efi.protocol.SimpleTextOutput.Geometry`
pub const geometry = efi.protocol.SimpleTextOutput.Geometry;


/// TextOutput
/// ----------
/// The UEFI SimpleTextOutput. An abstraction
/// provided by UEFI firmware over the console 
/// device, allowing easier use.
pub const TextOutput = struct 
{

    /// Standard output console
    stdOut: struct
    {
        protocol: *textOutputProtocol = undefined,
        foreground: attribute.ForegroundColor = .white,
        background:  attribute.BackgroundColor = .black,
        geometry: geometry = undefined
    },

    /// Standard error console
    stdErr: struct
    {
        protocol: *textOutputProtocol = undefined,
        foreground: attribute.ForegroundColor = .red,
        background:  attribute.BackgroundColor = .black,
        geometry: geometry = undefined
    },

    /// The error union for
    /// TextOutput.
    /// 
    /// `Memory`        -> 
    /// A memory failure was encountered. \
    /// `Device`        ->
    /// A device failure was encountered. \
    /// `InvalidParam`  ->
    /// A invalid parameter was passed. \
    /// `Protocol`      ->
    /// The protocol failed to init. \
    /// `Unsupported`   -> 
    /// A unsupported operation occured. \
    /// `Undefined`     ->
    /// A unexpected error occured.
    pub const Error = error
    {
        Memory,
        Device,
        InvalidParam,
        Protocol,
        Unsupported,
        Undefined
    };

    /// init
    /// ----
    /// This function is the init sequence for this struct. \
    /// This has to be ran before using this struct.
    pub fn init(selfOut: ?*textOutputProtocol, selfErr: ?*textOutputProtocol, cursor: bool) Error!@This()
    {
        // Resolve the protocols.
        // This works differently to GOP, as SimpleTextOutput doesn't usually
        // need to be found by locateProtocol. You just find the devices in systemTable.
        // Therefore, we initzalize both devices, and take them as arguments directly.
        const protocolOut = selfOut orelse return Error.Protocol;
        const protocolErr = selfErr orelse return Error.Protocol;

        // Reset both consoles.
        // This should NEVER fail, which is why we
        // tag it as unreachable, and don't even panic.
        protocolOut.reset(true) catch unreachable;
        protocolErr.reset(true) catch unreachable;

        // Get the mode of both consoles.
        const outMode = protocolOut.mode.mode;
        const errMode = protocolErr.mode.mode;

        // Obtain geometry for the mode of the stdout console
        const outModeGeo = protocolOut.queryMode(outMode) catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined   
        };

        // Obtain geometry for the mode of the stderr console
        const errModeGeo = protocolErr.queryMode(errMode) catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined   
        };

        // Set the mode of the stdout console
        protocolOut.setMode(outMode) catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined
        };

        // Set the mode of the stderr console
        protocolErr.setMode(errMode) catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined
        };

        // Define the attributes of the stdout console
        const attributeOut: attribute =     // Define the type manually
        .{
            .foreground = attribute.ForegroundColor.lightred,
            .background = attribute.BackgroundColor.black
        };

        // Define the attributes of the stderr console
        const attributeErr: attribute =     // Define the type manually
        .{
            .foreground = attribute.ForegroundColor.red,
            .background = attribute.BackgroundColor.black
        };

        // Set the color attributes of the stdout console
        protocolOut.setAttribute(attributeOut) catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            else => return Error.Undefined
        };

        // Set the color attributes of the stderr console
        protocolErr.setAttribute(attributeErr) catch |e| switch (e) 
        {
            error.DeviceError => return Error.Device,
            else => return Error.Undefined
        };

        // Clear the stdout console
        protocolOut.clearScreen() catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined
        };

        // Clear the stderr console
        protocolErr.clearScreen() catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined
        };

        // Toggle the cursor on the stdout console
        protocolOut.enableCursor(cursor) catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined
        };

        // Toggle the cursor on the stderr console
        protocolErr.enableCursor(cursor) catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined
        };

        return @This()
        {
            .stdOut =
            .{
                .protocol = protocolOut,
                .foreground = attributeOut.foreground,
                .background = attributeOut.background,
                .geometry = outModeGeo   
            },
            .stdErr =
            .{
                .protocol = protocolErr,
                .foreground = attributeErr.foreground,
                .background = attributeErr.background,
                .geometry = errModeGeo
            }
        };
    }

    pub fn writeString(self: @This(), msg: []const u8, newline: bool) Error!void
    {   
        // Resolve protocol.
        const protocol = self.stdOut.protocol;

        // Verify and check each char, then print it.
        for (msg) |char|
        {
            const ch = [2]u16{char, 0};

            const canWrite = protocol.testString(@ptrCast(&ch)) catch return Error.Undefined;
            
            if (canWrite)
            {   
                _ = protocol.outputString(@ptrCast(&ch)) catch |e| switch (e)
                {
                    error.DeviceError => return Error.Device,
                    error.Unsupported => return Error.Unsupported,
                    else => return Error.Undefined
                };
            }
            else 
            {
                return Error.InvalidParam;
            }
        }

        if (newline)
        {
            // Array for the carriage return + newline.
            const nl = [3]u16{'\r', '\n', 0};

            // Output the newline.
            _ = protocol.outputString(@ptrCast(&nl)) catch |e| switch (e)
            {
                error.DeviceError => return Error.Device,
                error.Unsupported => return Error.Unsupported,
                else => return Error.Undefined 
            };
        }
    }
};
