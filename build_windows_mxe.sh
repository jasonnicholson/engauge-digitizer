#!/usr/bin/env bash
set -euo pipefail

# Builds engauge.exe using an MXE x86_64 toolchain with Qt6 and CMake.
# MXE must be built with Qt6 support: make MXE_TARGETS=x86_64-w64-mingw32.static qt6

if [[ -z "${MXE_ROOT:-}" ]]; then
  echo "ERROR: MXE_ROOT is not set. Export it to the directory where MXE is installed."
  echo "  Example: export MXE_ROOT=\$HOME/mxe"
  exit 1
fi

TARGET="${TARGET:-x86_64-w64-mingw32.static}"
MXE_TARGET_DIR="$MXE_ROOT/usr/$TARGET"
BUILD_DIR="${BUILD_DIR:-build-win-mxe}"
BUILD_TYPE="${BUILD_TYPE:-Release}"

MXE_CMAKE="$MXE_ROOT/usr/bin/${TARGET}-cmake"
if [[ ! -x "$MXE_CMAKE" ]]; then
  echo "ERROR: MXE cmake wrapper not found: $MXE_CMAKE"
  echo "Ensure MXE was built with CMake support and Qt6."
  exit 1
fi

if [[ ! -f "$MXE_TARGET_DIR/include/fftw3.h" ]]; then
  echo "ERROR: FFTW headers not found under: $MXE_TARGET_DIR/include"
  echo "Build MXE package 'fftw' for your target first."
  exit 1
fi

if [[ ! -f "$MXE_TARGET_DIR/lib/libopenjp2.a" ]]; then
  echo "ERROR: JPEG2000 dependency not found: $MXE_TARGET_DIR/lib/libopenjp2.a"
  echo "Build MXE package 'openjpeg' for your target first."
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

export PATH="$MXE_ROOT/usr/bin:$PATH"

echo "Using MXE target: $TARGET"
echo "Using MXE cmake: $MXE_CMAKE"

# Suppress MXE toolchain "direct use" warning (false positive when MXE is behind
# a symlink, since CMAKE_COMMAND resolves symlinks but the toolchain path doesn't).
export _MXE_CMAKE_TOOLCHAIN_INCLUDED=TRUE

"$MXE_CMAKE" --no-warn-unused-cli -B "$BUILD_DIR" -S . \
  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
  -DENGAUGE_LOG4CPP_NULL=ON \
  -DBUILD_TESTING=OFF \
  -DENGAUGE_JPEG2000=ON

cmake --build "$BUILD_DIR" --parallel "$(nproc)"

if [[ -f "$BUILD_DIR/engauge.exe" ]]; then
  echo "SUCCESS: built $ROOT_DIR/$BUILD_DIR/engauge.exe"
else
  echo "ERROR: build completed but $BUILD_DIR/engauge.exe was not found"
  exit 1
fi
