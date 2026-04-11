#!/usr/bin/env bash
set -euo pipefail

# Builds engauge (Linux) against the system Qt6 installation using CMake.

BUILD_DIR="${BUILD_DIR:-build-linux-systemqt}"
BUILD_TYPE="${BUILD_TYPE:-Release}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v cmake >/dev/null 2>&1; then
  echo "ERROR: cmake not found. Install cmake (>= 3.16)."
  exit 1
fi

if ! command -v pkg-config >/dev/null 2>&1; then
  echo "ERROR: pkg-config not found. Install pkg-config first."
  exit 1
fi

# Extend PKG_CONFIG_PATH to include ~/.local where poppler-qt6 is installed.
# This is needed because Ubuntu 22.04 does not ship libpoppler-qt6-dev in apt.
export PKG_CONFIG_PATH="${HOME}/.local/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"

if ! pkg-config --exists libopenjp2; then
  echo "ERROR: JPEG2000 dependency not found (pkg-config package 'libopenjp2')."
  echo "Install OpenJPEG dev files, for example: sudo apt-get install -y libopenjp2-7-dev"
  exit 1
fi

if ! pkg-config --exists poppler-qt6; then
  echo "ERROR: PDF dependency not found (pkg-config package 'poppler-qt6')."
  echo "Install poppler-qt6 development files or set PKG_CONFIG_PATH to their .pc directory."
  exit 1
fi

cmake -B "$BUILD_DIR" -S . \
  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
  -DBUILD_TESTING=OFF \
  -DENGAUGE_LOG4CPP_NULL=ON \
  -DENGAUGE_JPEG2000=ON \
  -DENGAUGE_PDF=ON

cmake --build "$BUILD_DIR" --parallel "$(nproc)"

if [[ -f "$BUILD_DIR/engauge" ]]; then
  echo "SUCCESS: built $ROOT_DIR/$BUILD_DIR/engauge"
else
  echo "ERROR: build completed but $BUILD_DIR/engauge was not found"
  exit 1
fi
