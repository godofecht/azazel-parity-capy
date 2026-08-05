//! Forces capy's macOS AppKit backend (via zig-objc) to compile: references
//! capy.init and capy.Window so lazy analysis pulls in the objc-runtime backend,
//! proving the full GUI library compiles. Built, not run (CI is headless).
const std = @import("std");
const capy = @import("capy");

pub fn main() !void {
    try capy.init();
    var window = try capy.Window.init();
    _ = &window;
}
