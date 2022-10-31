const std = @import("std");
const deps = @import("./deps.zig");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const tests = b.addTest("test.zig");
    tests.setTarget(target);
    tests.setBuildMode(mode);
    deps.addAllTo(tests);

    const tests_step = b.step("test", "Run unit tests");
    tests_step.dependOn(&tests.step);
}
