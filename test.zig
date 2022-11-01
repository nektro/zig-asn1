const std = @import("std");
const string = []const u8;
const asn1 = @import("asn1");
const assert = std.debug.assert;

// test certificate from https://tls13.xargs.org/certificate.html
test {
    const cert = [_]u8{
        0x30, 0x82, 0x03, 0x21, 0x30, 0x82, 0x02, 0x09, 0xa0, 0x03, 0x02, 0x01, 0x02, 0x02, 0x08, 0x15, 0x5a, 0x92, 0xad, 0xc2, 0x04, 0x8f, 0x90, 0x30, 0x0d, 0x06,
        0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x0b, 0x05, 0x00, 0x30, 0x22, 0x31, 0x0b, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55,
        0x53, 0x31, 0x13, 0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x0a, 0x13, 0x0a, 0x45, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x20, 0x43, 0x41, 0x30, 0x1e, 0x17, 0x0d,
        0x31, 0x38, 0x31, 0x30, 0x30, 0x35, 0x30, 0x31, 0x33, 0x38, 0x31, 0x37, 0x5a, 0x17, 0x0d, 0x31, 0x39, 0x31, 0x30, 0x30, 0x35, 0x30, 0x31, 0x33, 0x38, 0x31,
        0x37, 0x5a, 0x30, 0x2b, 0x31, 0x0b, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53, 0x31, 0x1c, 0x30, 0x1a, 0x06, 0x03, 0x55, 0x04, 0x03,
        0x13, 0x13, 0x65, 0x78, 0x61, 0x6d, 0x70, 0x6c, 0x65, 0x2e, 0x75, 0x6c, 0x66, 0x68, 0x65, 0x69, 0x6d, 0x2e, 0x6e, 0x65, 0x74, 0x30, 0x82, 0x01, 0x22, 0x30,
        0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00, 0x30, 0x82, 0x01, 0x0a, 0x02, 0x82, 0x01,
        0x01, 0x00, 0xc4, 0x80, 0x36, 0x06, 0xba, 0xe7, 0x47, 0x6b, 0x08, 0x94, 0x04, 0xec, 0xa7, 0xb6, 0x91, 0x04, 0x3f, 0xf7, 0x92, 0xbc, 0x19, 0xee, 0xfb, 0x7d,
        0x74, 0xd7, 0xa8, 0x0d, 0x00, 0x1e, 0x7b, 0x4b, 0x3a, 0x4a, 0xe6, 0x0f, 0xe8, 0xc0, 0x71, 0xfc, 0x73, 0xe7, 0x02, 0x4c, 0x0d, 0xbc, 0xf4, 0xbd, 0xd1, 0x1d,
        0x39, 0x6b, 0xba, 0x70, 0x46, 0x4a, 0x13, 0xe9, 0x4a, 0xf8, 0x3d, 0xf3, 0xe1, 0x09, 0x59, 0x54, 0x7b, 0xc9, 0x55, 0xfb, 0x41, 0x2d, 0xa3, 0x76, 0x52, 0x11,
        0xe1, 0xf3, 0xdc, 0x77, 0x6c, 0xaa, 0x53, 0x37, 0x6e, 0xca, 0x3a, 0xec, 0xbe, 0xc3, 0xaa, 0xb7, 0x3b, 0x31, 0xd5, 0x6c, 0xb6, 0x52, 0x9c, 0x80, 0x98, 0xbc,
        0xc9, 0xe0, 0x28, 0x18, 0xe2, 0x0b, 0xf7, 0xf8, 0xa0, 0x3a, 0xfd, 0x17, 0x04, 0x50, 0x9e, 0xce, 0x79, 0xbd, 0x9f, 0x39, 0xf1, 0xea, 0x69, 0xec, 0x47, 0x97,
        0x2e, 0x83, 0x0f, 0xb5, 0xca, 0x95, 0xde, 0x95, 0xa1, 0xe6, 0x04, 0x22, 0xd5, 0xee, 0xbe, 0x52, 0x79, 0x54, 0xa1, 0xe7, 0xbf, 0x8a, 0x86, 0xf6, 0x46, 0x6d,
        0x0d, 0x9f, 0x16, 0x95, 0x1a, 0x4c, 0xf7, 0xa0, 0x46, 0x92, 0x59, 0x5c, 0x13, 0x52, 0xf2, 0x54, 0x9e, 0x5a, 0xfb, 0x4e, 0xbf, 0xd7, 0x7a, 0x37, 0x95, 0x01,
        0x44, 0xe4, 0xc0, 0x26, 0x87, 0x4c, 0x65, 0x3e, 0x40, 0x7d, 0x7d, 0x23, 0x07, 0x44, 0x01, 0xf4, 0x84, 0xff, 0xd0, 0x8f, 0x7a, 0x1f, 0xa0, 0x52, 0x10, 0xd1,
        0xf4, 0xf0, 0xd5, 0xce, 0x79, 0x70, 0x29, 0x32, 0xe2, 0xca, 0xbe, 0x70, 0x1f, 0xdf, 0xad, 0x6b, 0x4b, 0xb7, 0x11, 0x01, 0xf4, 0x4b, 0xad, 0x66, 0x6a, 0x11,
        0x13, 0x0f, 0xe2, 0xee, 0x82, 0x9e, 0x4d, 0x02, 0x9d, 0xc9, 0x1c, 0xdd, 0x67, 0x16, 0xdb, 0xb9, 0x06, 0x18, 0x86, 0xed, 0xc1, 0xba, 0x94, 0x21, 0x02, 0x03,
        0x01, 0x00, 0x01, 0xa3, 0x52, 0x30, 0x50, 0x30, 0x0e, 0x06, 0x03, 0x55, 0x1d, 0x0f, 0x01, 0x01, 0xff, 0x04, 0x04, 0x03, 0x02, 0x05, 0xa0, 0x30, 0x1d, 0x06,
        0x03, 0x55, 0x1d, 0x25, 0x04, 0x16, 0x30, 0x14, 0x06, 0x08, 0x2b, 0x06, 0x01, 0x05, 0x05, 0x07, 0x03, 0x02, 0x06, 0x08, 0x2b, 0x06, 0x01, 0x05, 0x05, 0x07,
        0x03, 0x01, 0x30, 0x1f, 0x06, 0x03, 0x55, 0x1d, 0x23, 0x04, 0x18, 0x30, 0x16, 0x80, 0x14, 0x89, 0x4f, 0xde, 0x5b, 0xcc, 0x69, 0xe2, 0x52, 0xcf, 0x3e, 0xa3,
        0x00, 0xdf, 0xb1, 0x97, 0xb8, 0x1d, 0xe1, 0xc1, 0x46, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x0b, 0x05, 0x00, 0x03, 0x82,
        0x01, 0x01, 0x00, 0x59, 0x16, 0x45, 0xa6, 0x9a, 0x2e, 0x37, 0x79, 0xe4, 0xf6, 0xdd, 0x27, 0x1a, 0xba, 0x1c, 0x0b, 0xfd, 0x6c, 0xd7, 0x55, 0x99, 0xb5, 0xe7,
        0xc3, 0x6e, 0x53, 0x3e, 0xff, 0x36, 0x59, 0x08, 0x43, 0x24, 0xc9, 0xe7, 0xa5, 0x04, 0x07, 0x9d, 0x39, 0xe0, 0xd4, 0x29, 0x87, 0xff, 0xe3, 0xeb, 0xdd, 0x09,
        0xc1, 0xcf, 0x1d, 0x91, 0x44, 0x55, 0x87, 0x0b, 0x57, 0x1d, 0xd1, 0x9b, 0xdf, 0x1d, 0x24, 0xf8, 0xbb, 0x9a, 0x11, 0xfe, 0x80, 0xfd, 0x59, 0x2b, 0xa0, 0x39,
        0x8c, 0xde, 0x11, 0xe2, 0x65, 0x1e, 0x61, 0x8c, 0xe5, 0x98, 0xfa, 0x96, 0xe5, 0x37, 0x2e, 0xef, 0x3d, 0x24, 0x8a, 0xfd, 0xe1, 0x74, 0x63, 0xeb, 0xbf, 0xab,
        0xb8, 0xe4, 0xd1, 0xab, 0x50, 0x2a, 0x54, 0xec, 0x00, 0x64, 0xe9, 0x2f, 0x78, 0x19, 0x66, 0x0d, 0x3f, 0x27, 0xcf, 0x20, 0x9e, 0x66, 0x7f, 0xce, 0x5a, 0xe2,
        0xe4, 0xac, 0x99, 0xc7, 0xc9, 0x38, 0x18, 0xf8, 0xb2, 0x51, 0x07, 0x22, 0xdf, 0xed, 0x97, 0xf3, 0x2e, 0x3e, 0x93, 0x49, 0xd4, 0xc6, 0x6c, 0x9e, 0xa6, 0x39,
        0x6d, 0x74, 0x44, 0x62, 0xa0, 0x6b, 0x42, 0xc6, 0xd5, 0xba, 0x68, 0x8e, 0xac, 0x3a, 0x01, 0x7b, 0xdd, 0xfc, 0x8e, 0x2c, 0xfc, 0xad, 0x27, 0xcb, 0x69, 0xd3,
        0xcc, 0xdc, 0xa2, 0x80, 0x41, 0x44, 0x65, 0xd3, 0xae, 0x34, 0x8c, 0xe0, 0xf3, 0x4a, 0xb2, 0xfb, 0x9c, 0x61, 0x83, 0x71, 0x31, 0x2b, 0x19, 0x10, 0x41, 0x64,
        0x1c, 0x23, 0x7f, 0x11, 0xa5, 0xd6, 0x5c, 0x84, 0x4f, 0x04, 0x04, 0x84, 0x99, 0x38, 0x71, 0x2b, 0x95, 0x9e, 0xd6, 0x85, 0xbc, 0x5c, 0x5d, 0xd6, 0x45, 0xed,
        0x19, 0x90, 0x94, 0x73, 0x40, 0x29, 0x26, 0xdc, 0xb4, 0x0e, 0x34, 0x69, 0xa1, 0x59, 0x41, 0xe8, 0xe2, 0xcc, 0xa8, 0x4b, 0xb6, 0x08, 0x46, 0x36, 0xa0,
    };
    var fbs = std.io.fixedBufferStream(&cert);
    const r = fbs.reader();

    // Certificate Sequence
    try expectTag(r, .sequence, 801);

    // Certificate Info Sequence
    try expectTag(r, .sequence, 521);

    // Version
    try expectTag(r, asn1.Tag.extra(.constructed, .context, 0), 3);
    try expectTag(r, .integer, 1);
    assertEql(try r.readByte(), 2);

    // Serial Number
    try expectTag(r, .integer, 8);
    assertEql(try r.readIntBig(u64), 0x155a92adc2048f90);

    // Algorithm
    try expectTag(r, .sequence, 13);
    try expectTagStr(r, .object_identifier, 9, "\x2a\x86\x48\x86\xf7\x0d\x01\x01\x0b");
    try expectTag(r, .null, 0);

    // Issuer Sequence
    try expectTag(r, .sequence, 34);

    // Country
    try expectTag(r, .set, 11);
    try expectTag(r, .sequence, 9);
    try expectTagStr(r, .object_identifier, 3, "\x55\x04\x06");
    try expectTagStr(r, .printable_string, 2, "US");

    // Organizational Unit
    try expectTag(r, .set, 19);
    try expectTag(r, .sequence, 17);
    try expectTagStr(r, .object_identifier, 3, "\x55\x04\x0a");
    try expectTagStr(r, .printable_string, 10, "Example CA");

    // Validity
    try expectTag(r, .sequence, 30);
    try expectTagStr(r, .utc_time, 13, "181005013817Z");
    try expectTagStr(r, .utc_time, 13, "191005013817Z");

    // Subject Sequence
    try expectTag(r, .sequence, 43);

    // Country
    try expectTag(r, .set, 11);
    try expectTag(r, .sequence, 9);
    try expectTagStr(r, .object_identifier, 3, "\x55\x04\x06");
    try expectTagStr(r, .printable_string, 2, "US");

    // Common Name
    try expectTag(r, .set, 28);
    try expectTag(r, .sequence, 26);
    try expectTagStr(r, .object_identifier, 3, "\x55\x04\x03");
    try expectTagStr(r, .printable_string, 19, "example.ulfheim.net");

    // Public Key
    try expectTag(r, .sequence, 290);
    try expectTag(r, .sequence, 13);
    try expectTagStr(r, .object_identifier, 9, "\x2a\x86\x48\x86\xf7\x0d\x01\x01\x01");
    try expectTag(r, .null, 0);
    try expectTag(r, .bit_string, 271);
    assertEql(try r.readByte(), 0);
    try expectBytes(r, &[_]u8{
        0x30, 0x82, 0x01, 0x0a, 0x02, 0x82, 0x01, 0x01, 0x00, 0xc4, 0x80, 0x36, 0x06, 0xba, 0xe7, 0x47, 0x6b, 0x08, 0x94, 0x04, 0xec,
        0xa7, 0xb6, 0x91, 0x04, 0x3f, 0xf7, 0x92, 0xbc, 0x19, 0xee, 0xfb, 0x7d, 0x74, 0xd7, 0xa8, 0x0d, 0x00, 0x1e, 0x7b, 0x4b, 0x3a,
        0x4a, 0xe6, 0x0f, 0xe8, 0xc0, 0x71, 0xfc, 0x73, 0xe7, 0x02, 0x4c, 0x0d, 0xbc, 0xf4, 0xbd, 0xd1, 0x1d, 0x39, 0x6b, 0xba, 0x70,
        0x46, 0x4a, 0x13, 0xe9, 0x4a, 0xf8, 0x3d, 0xf3, 0xe1, 0x09, 0x59, 0x54, 0x7b, 0xc9, 0x55, 0xfb, 0x41, 0x2d, 0xa3, 0x76, 0x52,
        0x11, 0xe1, 0xf3, 0xdc, 0x77, 0x6c, 0xaa, 0x53, 0x37, 0x6e, 0xca, 0x3a, 0xec, 0xbe, 0xc3, 0xaa, 0xb7, 0x3b, 0x31, 0xd5, 0x6c,
        0xb6, 0x52, 0x9c, 0x80, 0x98, 0xbc, 0xc9, 0xe0, 0x28, 0x18, 0xe2, 0x0b, 0xf7, 0xf8, 0xa0, 0x3a, 0xfd, 0x17, 0x04, 0x50, 0x9e,
        0xce, 0x79, 0xbd, 0x9f, 0x39, 0xf1, 0xea, 0x69, 0xec, 0x47, 0x97, 0x2e, 0x83, 0x0f, 0xb5, 0xca, 0x95, 0xde, 0x95, 0xa1, 0xe6,
        0x04, 0x22, 0xd5, 0xee, 0xbe, 0x52, 0x79, 0x54, 0xa1, 0xe7, 0xbf, 0x8a, 0x86, 0xf6, 0x46, 0x6d, 0x0d, 0x9f, 0x16, 0x95, 0x1a,
        0x4c, 0xf7, 0xa0, 0x46, 0x92, 0x59, 0x5c, 0x13, 0x52, 0xf2, 0x54, 0x9e, 0x5a, 0xfb, 0x4e, 0xbf, 0xd7, 0x7a, 0x37, 0x95, 0x01,
        0x44, 0xe4, 0xc0, 0x26, 0x87, 0x4c, 0x65, 0x3e, 0x40, 0x7d, 0x7d, 0x23, 0x07, 0x44, 0x01, 0xf4, 0x84, 0xff, 0xd0, 0x8f, 0x7a,
        0x1f, 0xa0, 0x52, 0x10, 0xd1, 0xf4, 0xf0, 0xd5, 0xce, 0x79, 0x70, 0x29, 0x32, 0xe2, 0xca, 0xbe, 0x70, 0x1f, 0xdf, 0xad, 0x6b,
        0x4b, 0xb7, 0x11, 0x01, 0xf4, 0x4b, 0xad, 0x66, 0x6a, 0x11, 0x13, 0x0f, 0xe2, 0xee, 0x82, 0x9e, 0x4d, 0x02, 0x9d, 0xc9, 0x1c,
        0xdd, 0x67, 0x16, 0xdb, 0xb9, 0x06, 0x18, 0x86, 0xed, 0xc1, 0xba, 0x94, 0x21, 0x02, 0x03, 0x01, 0x00, 0x01,
    });

    // Extensions
    try expectTag(r, asn1.Tag.extra(.constructed, .context, 3), 82);
    try expectTag(r, .sequence, 80);

    // Extension - Key Usage
    try expectTag(r, .sequence, 14);
    try expectTagStr(r, .object_identifier, 3, "\x55\x1d\x0f");
    try expectTag(r, .boolean, 1);
    assertEql(try r.readByte(), 0xff);
    try expectTag(r, .octet_string, 4);
    try expectTag(r, .bit_string, 2);
    assertEql(try r.readByte(), 5);
    assertEql(try r.readByte(), 0xa0);

    // Extension - Extended Key Usage
    try expectTag(r, .sequence, 29);
    try expectTagStr(r, .object_identifier, 3, "\x55\x1d\x25");
    try expectTag(r, .octet_string, 22);
    try expectTag(r, .sequence, 20);
    try expectTagStr(r, .object_identifier, 8, "\x2b\x06\x01\x05\x05\x07\x03\x02");
    try expectTagStr(r, .object_identifier, 8, "\x2b\x06\x01\x05\x05\x07\x03\x01");

    // Extension - Authority Key Identifier
    try expectTag(r, .sequence, 31);
    try expectTagStr(r, .object_identifier, 3, "\x55\x1d\x23");
    try expectTag(r, .octet_string, 24);
    try expectTag(r, .sequence, 22);
    try expectTagStr(r, asn1.Tag.extra(.primitive, .context, 0), 20, &[_]u8{ 0x89, 0x4f, 0xde, 0x5b, 0xcc, 0x69, 0xe2, 0x52, 0xcf, 0x3e, 0xa3, 0x00, 0xdf, 0xb1, 0x97, 0xb8, 0x1d, 0xe1, 0xc1, 0x46 });

    // Signature Algorithm
    try expectTag(r, .sequence, 13);
    try expectTagStr(r, .object_identifier, 9, "\x2a\x86\x48\x86\xf7\x0d\x01\x01\x0b");
    try expectTag(r, .null, 0);

    // Signature
    try expectTag(r, .bit_string, 257);
    assertEql(try r.readByte(), 0);
    try expectBytes(r, &[_]u8{
        0x59, 0x16, 0x45, 0xa6, 0x9a, 0x2e, 0x37, 0x79, 0xe4, 0xf6, 0xdd, 0x27, 0x1a, 0xba, 0x1c, 0x0b,
        0xfd, 0x6c, 0xd7, 0x55, 0x99, 0xb5, 0xe7, 0xc3, 0x6e, 0x53, 0x3e, 0xff, 0x36, 0x59, 0x08, 0x43,
        0x24, 0xc9, 0xe7, 0xa5, 0x04, 0x07, 0x9d, 0x39, 0xe0, 0xd4, 0x29, 0x87, 0xff, 0xe3, 0xeb, 0xdd,
        0x09, 0xc1, 0xcf, 0x1d, 0x91, 0x44, 0x55, 0x87, 0x0b, 0x57, 0x1d, 0xd1, 0x9b, 0xdf, 0x1d, 0x24,
        0xf8, 0xbb, 0x9a, 0x11, 0xfe, 0x80, 0xfd, 0x59, 0x2b, 0xa0, 0x39, 0x8c, 0xde, 0x11, 0xe2, 0x65,
        0x1e, 0x61, 0x8c, 0xe5, 0x98, 0xfa, 0x96, 0xe5, 0x37, 0x2e, 0xef, 0x3d, 0x24, 0x8a, 0xfd, 0xe1,
        0x74, 0x63, 0xeb, 0xbf, 0xab, 0xb8, 0xe4, 0xd1, 0xab, 0x50, 0x2a, 0x54, 0xec, 0x00, 0x64, 0xe9,
        0x2f, 0x78, 0x19, 0x66, 0x0d, 0x3f, 0x27, 0xcf, 0x20, 0x9e, 0x66, 0x7f, 0xce, 0x5a, 0xe2, 0xe4,
        0xac, 0x99, 0xc7, 0xc9, 0x38, 0x18, 0xf8, 0xb2, 0x51, 0x07, 0x22, 0xdf, 0xed, 0x97, 0xf3, 0x2e,
        0x3e, 0x93, 0x49, 0xd4, 0xc6, 0x6c, 0x9e, 0xa6, 0x39, 0x6d, 0x74, 0x44, 0x62, 0xa0, 0x6b, 0x42,
        0xc6, 0xd5, 0xba, 0x68, 0x8e, 0xac, 0x3a, 0x01, 0x7b, 0xdd, 0xfc, 0x8e, 0x2c, 0xfc, 0xad, 0x27,
        0xcb, 0x69, 0xd3, 0xcc, 0xdc, 0xa2, 0x80, 0x41, 0x44, 0x65, 0xd3, 0xae, 0x34, 0x8c, 0xe0, 0xf3,
        0x4a, 0xb2, 0xfb, 0x9c, 0x61, 0x83, 0x71, 0x31, 0x2b, 0x19, 0x10, 0x41, 0x64, 0x1c, 0x23, 0x7f,
        0x11, 0xa5, 0xd6, 0x5c, 0x84, 0x4f, 0x04, 0x04, 0x84, 0x99, 0x38, 0x71, 0x2b, 0x95, 0x9e, 0xd6,
        0x85, 0xbc, 0x5c, 0x5d, 0xd6, 0x45, 0xed, 0x19, 0x90, 0x94, 0x73, 0x40, 0x29, 0x26, 0xdc, 0xb4,
        0x0e, 0x34, 0x69, 0xa1, 0x59, 0x41, 0xe8, 0xe2, 0xcc, 0xa8, 0x4b, 0xb6, 0x08, 0x46, 0x36, 0xa0,
    });

    // End
    try std.testing.expectError(error.EndOfStream, r.readByte());
}

fn assertEql(actual: anytype, expected: @TypeOf(actual)) void {
    if (actual != expected) std.log.err("actual: {any}, expected: {any}", .{ actual, expected });
    assert(actual == expected);
}

fn expectBytes(reader: anytype, expected: []const u8) !void {
    for (expected) |item| {
        try std.testing.expectEqual(item, try reader.readByte());
    }
}

fn expectTag(reader: anytype, tag: asn1.Tag, len: u64) !void {
    try std.testing.expectEqual(tag.int(), try reader.readByte());
    try std.testing.expectEqual(len, try asn1.Length.read(reader));
}

fn expectTagStr(reader: anytype, tag: asn1.Tag, len: u64, str: []const u8) !void {
    try expectTag(reader, tag, len);
    try std.testing.expectEqual(len, str.len);
    try expectBytes(reader, str);
}
