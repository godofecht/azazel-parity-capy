// Azazel builds capy's full GUI library from source. On macOS capy's backend is
// pure Zig over the zig-objc runtime (no Objective-C compile step), so the whole
// library is expressible via pkg_imports + native.frameworks + libc. A probe
// forces the AppKit backend to compile. Source staged by ./fetch.sh. Lane 0.14.
package build

toolchain: zig: {
	lanes: ["0.14"]
	preferred: "0.14"
}

capy: #Module & {
	kind: "module"
	root: "vendor/capy/src/capy.zig"
	pkg_imports: [
		{alias: "zigimg", package: "zigimg", module: "zigimg"},
		{alias: "objc", package: "zig-objc", module: "objc"},
	]
	native: {
		link_libc: true
		frameworks: ["CoreData","ApplicationServices","CoreFoundation","CoreGraphics","CoreText","CoreServices","Foundation","AppKit","ColorSync","ImageIO","CFNetwork"]
		system_libs: ["objc"]
	}
}

probe: #Module & {
	kind: "exe"
	root: "src/probe.zig"
	deps: ["capy"]
}
