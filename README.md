# azazel-parity-capy

[capy](https://github.com/capy-ui/capy)'s full GUI library (macOS AppKit backend)
built two ways, to prove and compare [azazel](https://github.com/godofecht/azazel)
and [zaza](https://github.com/godofecht/zaza).

On macOS capy's backend is pure Zig over the [zig-objc](https://github.com/mitchellh/zig-objc)
runtime — there is no Objective-C compile step — so the whole library is
expressible through package imports plus the AppKit frameworks. Both builds
compile a probe that references `capy.init` and `capy.Window`, forcing the
backend to compile (a ~1.4 MB executable).

## The zig-objc fix

capy's upstream pins a `zig-objc` commit whose `build.zig.zon` uses an old
string `.name` that Zig 0.14.1 rejects; newer `zig-objc` needs a 3-argument
`std.zig.system.darwin.getSdk` that 0.14.1 lacks. This repo pins the 0.14-era
commit `2329503` (enum-literal name + 2-argument `getSdk`), which threads
between the two and builds on 0.14.1.

## Pinned upstream

| | |
|---|---|
| Repository | capy (staged from https://github.com/godofecht/capy at a 0.14.1-compatible commit) |
| zig-objc | `2329503f692fd5c8ff4c0528b066a22c40dc58e8` |
| zigimg | `74caab5edd7c5f1d2f7d87e5717435ce0f0affa1` |
| Zig | 0.14.1 · macOS |

## Build it (macOS)

```sh
cd azazel && ./fetch.sh && sh gen_build_spec.sh && zig build   # -> zig-out/bin/probe
cd zaza  && ./fetch.sh && zig build probe                      # -> zig-out/bin/capy_probe
```

The probe is built, not run (it opens a window); building it compiles the full
AppKit backend.

## Comparison

Clean-cache builds with dependencies pre-fetched, Apple Silicon, fastest of two runs.


| Build | Clean build | Config |
|-------|-------------|--------|
| azazel | 4.5 s | `project.cue` — 28 lines · 1324 B |
| zaza | 4.1 s | `build.zig` — 51 lines · 2076 B |

The upstream's full build is not reproduced here (see the note below), so no native time is listed.

**azazel and zaza both compile capy's full AppKit backend in ~4 s; capy's own example targets are broken upstream at this commit, so its full build is not used as a baseline.**

