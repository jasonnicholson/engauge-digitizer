#!/usr/bin/env bash
set -euo pipefail

# Builds engauge.exe by cross-compiling on Linux.
#
# Qt6 comes from MXE (MXE_ROOT must be set and built with Qt6).
# Third-party deps (fftw, openjpeg) are managed by Conan.
#
# Prerequisites:
#   export MXE_ROOT=$HOME/mxe   # MXE built with: make MXE_TARGETS=x86_64-w64-mingw32.static qt6
#   conan 2.x in PATH           # e.g. pipx install conan
#   cmake >= 3.16 in PATH

if [[ -z "${MXE_ROOT:-}" ]]; then
  echo "ERROR: MXE_ROOT is not set. Export it to the MXE installation directory."
  echo "  Example: export MXE_ROOT=\$HOME/mxe"
  exit 1
fi

TARGET="${TARGET:-x86_64-w64-mingw32.static}"
MXE_TARGET_DIR="$MXE_ROOT/usr/$TARGET"
BUILD_DIR="${BUILD_DIR:-build-win-conan}"
BUILD_TYPE="${BUILD_TYPE:-Release}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# ---------------------------------------------------------------------------
# Sanity checks
# ---------------------------------------------------------------------------
if ! command -v cmake >/dev/null 2>&1; then
  echo "ERROR: cmake not found. Install cmake (>= 3.16)."
  exit 1
fi

if ! command -v conan >/dev/null 2>&1; then
  echo "ERROR: conan not found. Install Conan 2.x first (for example: pipx install conan)."
  exit 1
fi

MXE_GCC="$MXE_ROOT/usr/bin/${TARGET}-gcc"
MXE_GPP="$MXE_ROOT/usr/bin/${TARGET}-g++"
if [[ ! -x "$MXE_GCC" ]]; then
  echo "ERROR: MXE cross-compiler not found: $MXE_GCC"
  echo "Ensure MXE is built with the '$TARGET' target."
  exit 1
fi

# ---------------------------------------------------------------------------
# Detect MXE GCC version for the Conan profile
# ---------------------------------------------------------------------------
GCC_VERSION=$("$MXE_GCC" -dumpversion 2>/dev/null | grep -oP '^\d+')
if [[ -z "$GCC_VERSION" ]]; then
  echo "ERROR: Failed to determine MXE GCC version from: $MXE_GCC"
  exit 1
fi
echo "Detected MXE GCC version: $GCC_VERSION"

# ---------------------------------------------------------------------------
# Prepare build directory; clear stale CMake cache
# ---------------------------------------------------------------------------
mkdir -p "$BUILD_DIR"
rm -f "$BUILD_DIR/CMakeCache.txt"
rm -rf "$BUILD_DIR/CMakeFiles"

# ---------------------------------------------------------------------------
# Conan build profile (Linux host)
# ---------------------------------------------------------------------------
CONAN_BUILD_PROFILE="${CONAN_BUILD_PROFILE:-default}"
if ! conan profile list | grep -qx "$CONAN_BUILD_PROFILE"; then
  echo "Conan build profile '$CONAN_BUILD_PROFILE' not found. Detecting one automatically."
  conan profile detect --force
fi

# ---------------------------------------------------------------------------
# Conan host profile: Windows/MinGW cross-compile via MXE
# Written fresh each invocation so MXE_ROOT / TARGET changes are picked up.
# ---------------------------------------------------------------------------
CONAN_HOST_PROFILE="$BUILD_DIR/conan_profile_windows_mxe"
cat > "$CONAN_HOST_PROFILE" << PROFILE
[settings]
os=Windows
arch=x86_64
compiler=gcc
compiler.version=${GCC_VERSION}
compiler.libcxx=libstdc++11
build_type=${BUILD_TYPE}

[buildenv]
CC=$MXE_ROOT/usr/bin/${TARGET}-gcc
CXX=$MXE_ROOT/usr/bin/${TARGET}-g++
AR=$MXE_ROOT/usr/bin/${TARGET}-ar
STRIP=$MXE_ROOT/usr/bin/${TARGET}-strip
RANLIB=$MXE_ROOT/usr/bin/${TARGET}-ranlib
RC=$MXE_ROOT/usr/bin/${TARGET}-windres
PROFILE

# ---------------------------------------------------------------------------
# Install Conan dependencies (cross-compiled for Windows/MinGW via MXE)
# ---------------------------------------------------------------------------
echo "== Installing Conan dependencies (Windows/MinGW cross-compile via MXE) =="
conan install . \
  --output-folder "$BUILD_DIR" \
  --build=missing \
  -s build_type="$BUILD_TYPE" \
  -pr:h "$CONAN_HOST_PROFILE" \
  -pr:b "$CONAN_BUILD_PROFILE"

if [[ -f "$BUILD_DIR/conanbuild.sh" ]]; then
  # shellcheck source=/dev/null
  source "$BUILD_DIR/conanbuild.sh"
fi

# Add MXE host tools to PATH so CMake can invoke lrelease, rcc, moc, etc.
export PATH="$MXE_ROOT/usr/bin:$PATH"

# ---------------------------------------------------------------------------
# Configure with CMake
#
# - CMAKE_TOOLCHAIN_FILE: Conan-generated; sets CMAKE_SYSTEM_NAME=Windows,
#   CMAKE_C/CXX_COMPILER to the MXE cross-compiler, and prepends the Conan
#   build folder to CMAKE_PREFIX_PATH so find_package(FFTW3/OpenJPEG) works.
#
# - CMAKE_PREFIX_PATH: MXE target sysroot so find_package(Qt6) finds the
#   MXE-built Qt6.  Conan's toolchain prepends its own paths on top of this.
#
# - CMAKE_FIND_ROOT_PATH / _MODE_PACKAGE=BOTH: allows CMake to search both
#   the MXE sysroot (for Qt6) and the normal prefix path list (for Conan
#   packages) when resolving find_package() calls in cross-compile mode.
# ---------------------------------------------------------------------------
cmake -B "$BUILD_DIR" -S . \
  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
  -DCMAKE_TOOLCHAIN_FILE="$BUILD_DIR/conan_toolchain.cmake" \
  -DCMAKE_PREFIX_PATH="$MXE_TARGET_DIR" \
  -DCMAKE_FIND_ROOT_PATH="$MXE_TARGET_DIR" \
  -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=BOTH \
  -DBUILD_TESTING=OFF \
  -DENGAUGE_LOG4CPP_NULL=ON \
  -DENGAUGE_JPEG2000=ON

cmake --build "$BUILD_DIR" --parallel "$(nproc)"

if [[ -f "$BUILD_DIR/engauge.exe" ]]; then
  echo "SUCCESS: built $ROOT_DIR/$BUILD_DIR/engauge.exe"
else
  echo "ERROR: build completed but $BUILD_DIR/engauge.exe was not found"
  exit 1
fi
