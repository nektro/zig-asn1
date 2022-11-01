const std = @import("std");
const string = []const u8;
const assert = std.debug.assert;
const extras = @import("extras");

pub const Tag = enum(u8) {
    // zig fmt: off
    _reserved           = @as(u8, 0) | @enumToInt(PC.primitive),
    boolean             = @as(u8, 1) | @enumToInt(PC.primitive),
    integer             = @as(u8, 2) | @enumToInt(PC.primitive),
    bit_string          = @as(u8, 3) | @enumToInt(PC.primitive),
    octet_string        = @as(u8, 4) | @enumToInt(PC.primitive),
    null                = @as(u8, 5) | @enumToInt(PC.primitive),
    object_identifier   = @as(u8, 6) | @enumToInt(PC.primitive),
    object_descriptor   = @as(u8, 7) | @enumToInt(PC.primitive),
    external_type       = @as(u8, 8) | @enumToInt(PC.primitive),
    real_type           = @as(u8, 9) | @enumToInt(PC.primitive),
    enumerated_type     = @as(u8,10) | @enumToInt(PC.primitive),
    embedded_pdv        = @as(u8,11) | @enumToInt(PC.primitive),
    utf8_string         = @as(u8,12) | @enumToInt(PC.primitive),
    relative_oid        = @as(u8,13) | @enumToInt(PC.primitive),
    time                = @as(u8,14) | @enumToInt(PC.primitive),
    _reserved2          = @as(u8,15) | @enumToInt(PC.primitive),
    sequence            = @as(u8,16) | @enumToInt(PC.constructed),
    set                 = @as(u8,17) | @enumToInt(PC.constructed),
    numeric_string      = @as(u8,18) | @enumToInt(PC.primitive),
    printable_string    = @as(u8,19) | @enumToInt(PC.primitive),
    teletex_string      = @as(u8,20) | @enumToInt(PC.primitive),
    videotex_string     = @as(u8,21) | @enumToInt(PC.primitive),
    ia5_string          = @as(u8,22) | @enumToInt(PC.primitive),
    utc_time            = @as(u8,23) | @enumToInt(PC.primitive),
    generalized_time    = @as(u8,24) | @enumToInt(PC.primitive),
    graphic_string      = @as(u8,25) | @enumToInt(PC.primitive),
    visible_string      = @as(u8,26) | @enumToInt(PC.primitive),
    general_string      = @as(u8,27) | @enumToInt(PC.primitive),
    universal_string    = @as(u8,28) | @enumToInt(PC.primitive),
    unrestricted_string = @as(u8,29) | @enumToInt(PC.primitive),
    bmp_string          = @as(u8,30) | @enumToInt(PC.primitive),
    date                = @as(u8,31) | @enumToInt(PC.primitive),
    _,

    // zig fmt: on

    pub fn int(tag: Tag) u8 {
        return @enumToInt(tag);
    }
};

pub const Length = packed struct(u8) {
    len: u7,
    form: enum { short, long },

    pub fn read(reader: anytype) !u64 {
        const octet = @bitCast(Length, try reader.readByte());
        switch (octet.form) {
            .short => return octet.len,
            .long => {
                var res: u64 = 0;
                assert(octet.len <= 8); // long form length exceeds bounds of u64
                assert(octet.len > 0); // TODO indefinite form
                for (extras.range(octet.len)) |_, i| {
                    res |= (@as(u64, try reader.readByte()) << @intCast(u6, 8 * (octet.len - 1 - @intCast(u6, i))));
                }
                return res;
            },
        }
    }
};
