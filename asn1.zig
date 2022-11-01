const std = @import("std");
const string = []const u8;
const assert = std.debug.assert;
const extras = @import("extras");

pub const Tag = enum(u8) {
    // zig fmt: off
    end_of_content      = @as(u8, 0) | @enumToInt(PC.primitive),
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

    const PC = enum(u8) {
        primitive   = 0b00000000,
        constructed = 0b00100000,
    };

    const Class = enum(u8) {
        universal   = 0b00000000,
        application = 0b01000000,
        context     = 0b10000000,
        private     = 0b11000000,
    };
    // zig fmt: on

    pub fn int(tag: Tag) u8 {
        return @enumToInt(tag);
    }

    pub fn extra(pc: PC, class: Class, ty: u5) Tag {
        var res: u8 = ty;
        res |= @enumToInt(pc);
        res |= @enumToInt(class);
        return @intToEnum(Tag, res);
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

fn expectTag(reader: anytype, tag: Tag) !void {
    const actual = @intToEnum(Tag, try reader.readByte());
    if (actual != tag) return error.UnexpectedTag;
}

fn expectLength(reader: anytype, len: u64) !void {
    const actual = try Length.read(reader);
    if (actual != len) return error.UnexpectedLength;
}

pub fn readBoolean(reader: anytype) !bool {
    try expectTag(reader, .boolean);
    try expectLength(reader, 1);
    return (try reader.readByte()) > 0;
}

pub fn readInt(reader: anytype, comptime Int: type) !Int {
    comptime assert(@bitSizeOf(Int) % 8 == 0);
    const L2Int = std.math.Log2Int(Int);
    try expectTag(reader, .integer);
    const len = try Length.read(reader);
    assert(len <= 8); // TODO implement readIntBig
    assert(len > 0);
    assert(len <= @sizeOf(Int));
    var res: Int = 0;
    for (extras.range(len)) |_, i| {
        res |= (@as(Int, try reader.readByte()) << @intCast(L2Int, 8 * (len - 1 - @intCast(L2Int, i))));
    }
    return res;
}

// TODO readIntBig

// TODO enumerated value

// TODO real value

// TODO bitstring value

// TODO octetstring value

pub fn readNull(reader: anytype) !void {
    try expectTag(reader, .null);
    try expectLength(reader, 0);
}

// TODO sequence value

// TODO sequence-of value

// TODO set value

// TODO set-of value

// TODO choice value

// TODO value of a prefixed type

// TODO value of an open type

// TODO instance-of value

// TODO value of the embedded-pdv type

// TODO value of the external type

// TODO object identifier value

// TODO relative object identifier value

// TODO OID internationalized resource identifier value

// TODO relative OID internationalized resource identifier value

// TODO values of the restricted character string types

// TODO values of the unrestricted character string type
