const std = @import("std");

// capy's full GUI library built from source through the standard Zig build graph
// Zaza is built on. On macOS capy's backend is pure Zig over the zig-objc
// runtime, so Zaza's C/C++ target DSL does not apply; the Zig graph wires the
// package imports and the AppKit frameworks. A probe forces the backend to
// compile.
const frameworks = [_][]const u8{
    "CoreData", "ApplicationServices", "CoreFoundation", "CoreGraphics",
    "CoreText", "CoreServices", "Foundation", "AppKit", "ColorSync",
    "ImageIO", "CFNetwork",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zigimg = b.dependency("zigimg", .{ .target = target, .optimize = optimize }).module("zigimg");
    const objc = b.dependency("zig-objc", .{ .target = target, .optimize = optimize }).module("objc");

    const capy = b.createModule(.{
        .root_source_file = b.path("vendor/capy/src/capy.zig"),
        .target = target,
        .optimize = optimize,
    });
    capy.addImport("zigimg", zigimg);
    capy.addImport("objc", objc);
    capy.link_libc = true;
    inline for (frameworks) |fw| capy.linkFramework(fw, .{});
    capy.linkSystemLibrary("objc", .{});

    const exe = b.addExecutable(.{
        .name = "capy_probe",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.root_module.addImport("capy", capy);
    // Link the frameworks and libc on the executable that actually links, not
    // only on the capy module (module-level settings do not reliably reach the
    // exe link step on all hosts).
    exe.root_module.link_libc = true;
    inline for (frameworks) |fw| exe.root_module.linkFramework(fw, .{});
    exe.root_module.linkSystemLibrary("objc", .{});
    b.installArtifact(exe);

    const step = b.step("probe", "Build the capy backend probe");
    step.dependOn(&b.addInstallArtifact(exe, .{}).step);
}
