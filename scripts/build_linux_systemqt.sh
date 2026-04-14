#!/usr/bin/env bash
set -euo pipefail

# Builds engauge (Linux) against system Qt6 and Conan-managed third-party deps.

BUILD_DIR="${BUILD_DIR:-build-linux-systemqt}"
BUILD_TYPE="${BUILD_TYPE:-Release}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/../ && pwd)"
cd "$ROOT_DIR"

mkdir -p "$BUILD_DIR"

# Toolchain changes are ignored when an existing CMake cache is reused.
# rm -f "$BUILD_DIR/CMakeCache.txt"
# rm -rf "$BUILD_DIR/CMakeFiles"

if ! command -v cmake >/dev/null 2>&1; then
  echo "ERROR: cmake not found. Install cmake (>= 3.16)."
  exit 1
fi

if ! command -v conan >/dev/null 2>&1; then
  echo "ERROR: conan not found. Install Conan 2.x first (for example: pipx install conan)."
  exit 1
fi

CONAN_PROFILE="${CONAN_PROFILE:-default}"

if ! conan profile list | grep -qx "$CONAN_PROFILE"; then
  echo "Conan profile '$CONAN_PROFILE' not found. Detecting one automatically."
  conan profile detect --force
fi

echo "== Installing Conan dependencies =="
conan install . \
  --output-folder "$BUILD_DIR" \
  --build=missing \
  -cc core:skip_warnings='["deprecated"]' \
  -s build_type="$BUILD_TYPE" \
  -pr:h "$CONAN_PROFILE" \
  -pr:b "$CONAN_PROFILE"

if [[ -f "$BUILD_DIR/conanbuild.sh" ]]; then
  # shellcheck source=/dev/null
  source "$BUILD_DIR/conanbuild.sh"
fi

cmake -B "$BUILD_DIR" -S . \
  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
  -DCMAKE_TOOLCHAIN_FILE="$BUILD_DIR/conan_toolchain.cmake" \
  -DBUILD_TESTING=ON \
  -DENGAUGE_LOG4CPP_NULL=ON \
  -DENGAUGE_JPEG2000=ON

cmake --build "$BUILD_DIR" --parallel "$(nproc)"

if [[ -f "$BUILD_DIR/engauge" ]]; then
  echo "SUCCESS: built $ROOT_DIR/$BUILD_DIR/engauge"
else
  echo "ERROR: build completed but $BUILD_DIR/engauge was not found"
  exit 1
fi
