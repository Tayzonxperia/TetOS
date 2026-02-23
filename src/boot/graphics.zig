const root = @import("../root.zig");

const utils = @import("utils.zig");

const efi = root.Standard.uefi;



/// graphicsProtocol
/// ----------------
/// A shortand for `efi.protocol.GraphicsOutput`
pub const graphicsProtocol = efi.protocol.GraphicsOutput;


/// bltPixel
/// --------
/// A shorthand for `efi.protocol.GraphicsOutput.BltPixel`
pub const bltPixel = efi.protocol.GraphicsOutput.BltPixel;


/// bltOperation
/// ------------
/// A shorthand for `efi.protocol.GraphicsOutput.BltOperation`
pub const bltOperation = efi.protocol.GraphicsOutput.BltOperation;


/// GraphicsOutput
/// --------------
/// The UEFI GOP. An abstraction provided
/// by the UEFI firmware over the graphics
/// framebuffer, allowing easier use.
pub const GraphicsOutput = struct 
{   
    /// The protocol for GOP.
    protocol: ?*graphicsProtocol,

    /// The display mode info.
    modeInfo: struct 
    {
        /// Mode version.
        ver: u32 = 1,

        /// Horizontal resolution.
        resH: u32 = 800,    

        // VGA 800x600 is a sane default

        /// Vertical resolution.
        resV: u32 = 600,    

        /// Format of pixels.
        pixFmt: graphicsProtocol.PixelFormat = graphicsProtocol.PixelFormat.blt_only,

        /// Bitmask of pixels.
        pixBit: graphicsProtocol.PixelBitmask = 
        .{
            .red_mask = 0,
            .blue_mask = 0,
            .green_mask = 0,
            .reserved_mask = 0
        },

        /// Pixels per scanline.
        pixPerScanLine: u32 = 0
    },
    
    /// The error union we use 
    /// for GraphicsOutput.
    /// 
    /// `Memory`            -> 
    /// A memory failure was encountered. \
    /// `Device`            -> 
    /// A device failure was encountered. \
    /// `InvalidParam`      -> 
    /// A invalid paramater was passed. \
    /// `ProtocolFailure`   ->
    /// The protocol failed to start or
    /// failed to be located. \
    /// `Unsupported`       -> A unsupported
    /// option was passed. \
    /// `Undefined`         -> A unexpected
    /// error has occured and it could not
    /// be handled.
    pub const Error = error
    {   
        Memory,
        Device,
        InvalidParam,
        Protocol,
        Unsupported,
        Undefined,
    };

    /// init
    /// ----
    /// This function is the init sequence for this protocol. \
    /// This has to be ran before the use of this struct.
    pub fn init(self: ?*graphicsProtocol) Error!@This()
    {   
        // Resolve the protocol.
        // If the protocol gets passed null, this means that locateProtocol failed
        // to find GOP, therefore we can conclude that GOP doesn't exist here.
        const protocol = self orelse return Error.Protocol;

        // Get the current GOP display mode.
        const curMode = protocol.mode.mode;
        
        // Obtain current mode infomation.
        const curModeInfo = protocol.queryMode(curMode) catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.InvalidParameter => return Error.InvalidParam,
            else => return Error.Undefined
        };

        // Set the video mode.
        // This also has the benifit of clearing the display.
        protocol.setMode(curMode) catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.Unsupported => return Error.Unsupported,
            else => return Error.Undefined
        };

        // Return the struct, with all 
        // the data filled in. 
        return @This()
        {
            .protocol = protocol, 
            .modeInfo =
            .{
                .ver = curModeInfo.version,
                .resH = curModeInfo.horizontal_resolution,
                .resV = curModeInfo.vertical_resolution,
                .pixFmt = curModeInfo.pixel_format,
                .pixBit = curModeInfo.pixel_information,
                .pixPerScanLine = curModeInfo.pixels_per_scan_line,
            },
        };
    }

    /// paintScreen
    /// -----------
    /// This function fills the display with the specified buffer using
    /// the block transfer operation: blt_video_fill. \
    /// The resolution is pre-calculated and is garanteed to be correct.
    pub fn paintScreen(self: @This(), buf: [*]graphicsProtocol.BltPixel) Error!void
    {   
        // Resolve protocol.
        const protocol = self.protocol orelse return Error.Protocol;

        const resH = self.modeInfo.resH;    // Horizontal.
        const resV = self.modeInfo.resV;    // Vertical.

        // Draw it with block transfer video fill.
        protocol.blt(buf, bltOperation.blt_video_fill,
        0, 0, 0, 0, resH, resV, 0)
        catch |e| switch (e)
        {
            error.DeviceError => return Error.Device,
            error.InvalidParameter => return Error.InvalidParam,
            else => return Error.Undefined
        };
    }
};