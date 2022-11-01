const std = @import("std");
const string = []const u8;

pub const Tag = enum(u8) {
    // zig fmt: off
    _reserved           =  0,
    boolean             =  1,
    integer             =  2,
    bit_string          =  3,
    octet_string        =  4,
    null                =  5,
    object_identifier   =  6,
    object_descriptor   =  7,
    external_type       =  8,
    real_type           =  9,
    enumerated_type     = 10,
    embedded_pdv        = 11,
    utf8_string         = 12,
    relative_oid        = 13,
    time                = 14,
    _reserved2          = 15,
    sequence            = 16,
    set                 = 17,
    numeric_string      = 18,
    printable_string    = 19,
    teletex_string      = 20,
    videotex_string     = 21,
    ia5_string          = 22,
    utc_time            = 23,
    generalized_time    = 24,
    graphic_string      = 25,
    visible_string      = 26,
    general_string      = 27,
    universal_string    = 28,
    unrestricted_string = 29,
    bmp_string          = 30,
    date                = 31,
    _,

    // zig fmt: on

    pub fn int(tag: Tag) u8 {
        return @enumToInt(tag);
    }
};
