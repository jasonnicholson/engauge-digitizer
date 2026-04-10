#!/usr/bin/env bash
set -euo pipefail

# Builds engauge with a custom Qt6 install, then bundles Qt runtime files next
# to the binary to create a near-self-contained Linux build.

QT_PREFIX="${QT_PREFIX:-/opt/qt6-linux}"
BUILD_DIR="${BUILD_DIR:-build-linux-almoststaticqt}"
BUILD_TYPE="${BUILD_TYPE:-Release}"
DIST_DIR="${DIST_DIR:-dist/almoststatic-linux-x86_64}"

if [[ ! -f "$QT_PREFIX/lib/libQt6Core.so" ]] && [[ ! -f "$QT_PREFIX/lib/libQt6Core.so.6" ]]; then
  echo "ERROR: libQt6Core.so not found under $QT_PREFIX/lib"
  echo "Set QT_PREFIX to your custom Qt6 install prefix."
  exit 1
fi

if ! command -v cmake >/dev/null 2>&1; then
  echo "ERROR: cmake not found. Install cmake (>= 3.16)."
  exit 1
fi

if ! command -v patchelf >/dev/null 2>&1; then
  echo "ERROR: patchelf is required but not installed."
  echo "Install it with: sudo apt-get install patchelf"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "Using Qt6 prefix: $QT_PREFIX"

cmake -B "$BUILD_DIR" -S . \
  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
  -DCMAKE_PREFIX_PATH="$QT_PREFIX" \
  -DENGAUGE_LOG4CPP_NULL=ON

cmake --build "$BUILD_DIR" --parallel "$(nproc)"

BINARY="$BUILD_DIR/engauge"
if [[ -f "$BINARY" ]]; then
  SIZE=$(du -sh "$BINARY" | cut -f1)
  echo "SUCCESS: built $ROOT_DIR/$BINARY ($SIZE)"
else
  echo "ERROR: build completed but $BINARY was not found"
  exit 1
fi

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR/lib" "$DIST_DIR/plugins"

cp "$BINARY" "$DIST_DIR/engauge"

# Copy Qt6 shared libraries required by the executable from the custom Qt6 prefix.
while read -r qtlib; do
  [[ -n "$qtlib" ]] || continue
  cp -a "$qtlib" "$DIST_DIR/lib/"
  real_qtlib=$(readlink -f "$qtlib")
  cp -a "$real_qtlib" "$DIST_DIR/lib/"
done < <(ldd "$BINARY" | awk '{print $3}' | grep "^$QT_PREFIX/lib/libQt" | sort -u)

# Bundle plugins required at runtime for GUI and image loading.
for plugin_dir in platforms imageformats iconengines printsupport; do
  if [[ -d "$QT_PREFIX/plugins/$plugin_dir" ]]; then
    mkdir -p "$DIST_DIR/plugins/$plugin_dir"
    cp -a "$QT_PREFIX/plugins/$plugin_dir"/* "$DIST_DIR/plugins/$plugin_dir/"
  fi
done

# Configure Qt to resolve libraries and plugins from this package root.
cat > "$DIST_DIR/qt.conf" <<'EOF'
[Paths]
Prefix=.
Libraries=lib
Plugins=plugins
EOF

# Ensure the executable resolves packaged libraries first.
patchelf --set-rpath '$ORIGIN/lib' "$DIST_DIR/engauge"

PACKAGE_TAR="dist/engauge-linux-almoststatic-x86_64.tar.gz"
mkdir -p dist
tar -C dist -czf "$PACKAGE_TAR" "$(basename "$DIST_DIR")"

echo ""
echo "Near-static package created: $ROOT_DIR/$PACKAGE_TAR"
echo "Run with: $ROOT_DIR/$DIST_DIR/engauge"
echo ""
echo "Qt dependencies inside executable after patching:"
env -u LD_LIBRARY_PATH ldd "$DIST_DIR/engauge" | grep -E 'Qt6|not found' || true
