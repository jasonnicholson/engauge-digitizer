#!/usr/bin/env bash
set -euo pipefail

# Builds engauge against a static Qt build, producing a near-self-contained
# binary that does not depend on the distro's Qt5 packages.
#
# Prerequisites:
#   A static Qt 5.x build installed at STATIC_QT_PREFIX (default below).
#   Build it once from source:
#
#     mkdir ~/workspace/qt-5.15.17-build-static
#     cd    ~/workspace/qt-5.15.17-build-static
#     ~/workspace/qt-everywhere-src-5.15.17/configure \
#       -prefix /opt/qt-5.15.17-static \
#       -release -static -opensource -confirm-license \
#       -xcb -opengl desktop -no-fontconfig \
#       -qt-zlib -qt-libpng -qt-libjpeg -qt-freetype -qt-pcre -qt-harfbuzz \
#       -no-openssl -nomake examples -nomake tests \
#       -skip qt3d -skip qtactiveqt -skip qtandroidextras \
#       -skip qtcharts -skip qtdatavis3d -skip qtdeclarative \
#       -skip qtdoc -skip qtgamepad -skip qtlocation -skip qtlottie \
#       -skip qtmultimedia -skip qtquick3d -skip qtquickcontrols \
#       -skip qtquickcontrols2 -skip qtscript -skip qtscxml \
#       -skip qtsensors -skip qtserialbus -skip qtserialport \
#       -skip qtspeech -skip qtvirtualkeyboard -skip qtwayland \
#       -skip qtwebchannel -skip qtwebengine -skip qtwebglplugin \
#       -skip qtwebsockets -skip qtwebview
#     make -j$(nproc) && sudo make install
#
# Override STATIC_QT_PREFIX if your static Qt is installed elsewhere.

STATIC_QT_PREFIX="${STATIC_QT_PREFIX:-/opt/qt-5.15.17-static}"
QMAKE_BIN="${QMAKE_BIN:-$STATIC_QT_PREFIX/bin/qmake}"
BUILD_DIR="${BUILD_DIR:-build-linux-almoststaticqt}"

if [[ ! -x "$QMAKE_BIN" ]]; then
  echo "ERROR: qmake not found at: $QMAKE_BIN"
  echo "Set STATIC_QT_PREFIX to your static Qt installation prefix,"
  echo "or set QMAKE_BIN directly."
  exit 1
fi

if [[ ! -f "$STATIC_QT_PREFIX/lib/libQt5Core.a" ]]; then
  echo "ERROR: libQt5Core.a not found under $STATIC_QT_PREFIX/lib"
  echo "The Qt at $STATIC_QT_PREFIX does not appear to be a static build."
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "Using qmake: $QMAKE_BIN ($(${QMAKE_BIN} --version | tail -1))"

# QTPLUGIN.platforms=qxcb ensures the xcb platform plugin is imported into the
# binary at link time (required for static Qt — dynamic plugin loading is disabled).
"$QMAKE_BIN" ../engauge.pro \
  CONFIG+=log4cpp_null \
  "QTPLUGIN.platforms=qxcb"

make -j"$(nproc)"

BINARY="bin/engauge"
if [[ -f "$BINARY" ]]; then
  SIZE=$(du -sh "$BINARY" | cut -f1)
  echo "SUCCESS: built $PWD/$BINARY ($SIZE)"
  echo ""
  echo "Dynamic dependencies (should be only system/X11/GL libs, no Qt):"
  ldd "$BINARY" | grep -v "not a dynamic executable" || true
else
  echo "ERROR: build completed but $BINARY was not found"
  exit 1
fi
