const std = @import("std");
const string = []const u8;

pub const Tag = enum(u8) {
    _reserved,
    boolean,
    integer,
    bit_string,
    octet_string,
    null,
    object_identifier,
    object_descriptor,
    external_type,
    real_type,
    enumerated_type,
    embedded_pdv,
    utf8_string,
    relative_object_identifier,
    time,
    _reserved2,
    sequence,
    set,
    char_string18,
    char_string19,
    char_string20,
    char_string21,
    char_string22,
    utc_time,
    generalized_time,
    char_string25,
    char_string26,
    char_string27,
    char_string28,
    char_string29,
    char_string30,
    date,
    _,

    pub fn int(tag: Tag) u8 {
        return @enumToInt(tag);
    }
};
