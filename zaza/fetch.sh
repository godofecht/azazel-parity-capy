#!/bin/sh
# Stage capy source into vendor/capy (git-ignored). Uses the pinned commit that
# builds on Zig 0.14.1; capy's upstream pins a zig-objc incompatible with 0.14.1,
# so this repo's build.zig.zon pins the 0.14-era zig-objc (2329503) instead.
set -eu
DIR=$(cd "$(dirname "$0")" && pwd)
VENDOR="$DIR/vendor/capy"
if [ -f "$VENDOR/src/capy.zig" ]; then echo "already staged"; exit 0; fi
rm -rf "$VENDOR"; mkdir -p "$DIR/vendor"
git clone --filter=blob:none https://github.com/godofecht/capy "$VENDOR"
git -C "$VENDOR" checkout -q cdb3f2688752c20c842eaba3e3ac31d7bdd60f85
echo "capy source staged"
