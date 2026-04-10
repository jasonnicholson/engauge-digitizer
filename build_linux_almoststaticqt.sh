#!/usr/bin/env bash
set -euo pipefail

# Builds engauge with a custom Qt install (not distro Qt), then bundles Qt
# runtime files next to the binary to create a near-self-contained Linux build.

QT_PREFIX="${QT_PREFIX:-/opt/qt-5.15.17-linux}"
QMAKE_BIN="${QMAKE_BIN:-$QT_PREFIX/bin/qmake}"
BUILD_DIR="${BUILD_DIR:-build-linux-almoststaticqt}"
DIST_DIR="${DIST_DIR:-dist/almoststatic-linux-x86_64}"

if [[ ! -x "$QMAKE_BIN" ]]; then
  echo "ERROR: qmake not found at: $QMAKE_BIN"
  echo "Set QT_PREFIX to your custom Qt install prefix, or set QMAKE_BIN directly."
  exit 1
fi

if [[ ! -f "$QT_PREFIX/lib/libQt5Core.so" ]]; then
  echo "ERROR: libQt5Core.so not found under $QT_PREFIX/lib"
  echo "Expected a shared Qt install at QT_PREFIX=$QT_PREFIX"
  exit 1
fi

if ! command -v patchelf >/dev/null 2>&1; then
  echo "ERROR: patchelf is required but not installed."
  echo "Install it with: sudo apt-get install patchelf"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "Using qmake: $QMAKE_BIN"
echo "Using Qt prefix: $QT_PREFIX"

"$QMAKE_BIN" ../engauge.pro \
  CONFIG+=log4cpp_null

make -j"$(nproc)"

BINARY="bin/engauge"
if [[ -f "$BINARY" ]]; then
  SIZE=$(du -sh "$BINARY" | cut -f1)
  echo "SUCCESS: built $PWD/$BINARY ($SIZE)"
else
  echo "ERROR: build completed but $BINARY was not found"
  exit 1
fi

cd "$ROOT_DIR"
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR/lib" "$DIST_DIR/plugins"

cp "$BUILD_DIR/$BINARY" "$DIST_DIR/engauge"

# Copy Qt shared libraries required by the executable from the custom Qt prefix.
while read -r qtlib; do
  [[ -n "$qtlib" ]] || continue
  cp -a "$qtlib" "$DIST_DIR/lib/"
  real_qtlib=$(readlink -f "$qtlib")
  cp -a "$real_qtlib" "$DIST_DIR/lib/"
done < <(ldd "$BUILD_DIR/$BINARY" | awk '{print $3}' | grep "^$QT_PREFIX/lib/libQt" | sort -u)

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

# Ensure the executable always resolves packaged libraries first.
patchelf --set-rpath '$ORIGIN/lib' "$DIST_DIR/engauge"

PACKAGE_TAR="dist/engauge-linux-almoststatic-x86_64.tar.gz"
mkdir -p dist
tar -C dist -czf "$PACKAGE_TAR" "$(basename "$DIST_DIR")"

echo ""
echo "Near-static package created: $ROOT_DIR/$PACKAGE_TAR"
echo "Run with: $ROOT_DIR/$DIST_DIR/engauge"
echo ""
echo "Qt dependencies inside executable after patching:"
env -u LD_LIBRARY_PATH ldd "$DIST_DIR/engauge" | grep -E 'Qt5|not found' || true
