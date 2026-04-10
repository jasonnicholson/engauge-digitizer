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

cmake -B "$BUILD_DIR" -S . \
  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
  -DENGAUGE_LOG4CPP_NULL=ON

cmake --build "$BUILD_DIR" --parallel "$(nproc)"

if [[ -f "$BUILD_DIR/engauge" ]]; then
  echo "SUCCESS: built $ROOT_DIR/$BUILD_DIR/engauge"
else
  echo "ERROR: build completed but $BUILD_DIR/engauge was not found"
  exit 1
fi
