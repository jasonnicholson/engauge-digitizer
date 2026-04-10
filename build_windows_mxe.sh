#!/usr/bin/env bash
set -euo pipefail

# Builds engauge.exe using an MXE static x86_64 toolchain.

if [[ -z "${MXE_ROOT:-}" ]]; then
  echo "ERROR: MXE_ROOT is not set. Export it to the directory where MXE is installed."
  echo "  Example: export MXE_ROOT=\$HOME/mxe"
  exit 1
fi
TARGET="${TARGET:-x86_64-w64-mingw32.static}"
QMAKE_BIN="${QMAKE_BIN:-$MXE_ROOT/usr/bin/${TARGET}-qmake-qt5}"
FFTW_HOME_DEFAULT="$MXE_ROOT/usr/${TARGET}"
FFTW_HOME="${FFTW_HOME:-$FFTW_HOME_DEFAULT}"
BUILD_DIR="${BUILD_DIR:-build-win-mxe}"

if [[ ! -x "$QMAKE_BIN" ]]; then
  echo "ERROR: qmake not found at: $QMAKE_BIN"
  echo "Wait for MXE build to finish, or set QMAKE_BIN to the correct path."
  exit 1
fi

if [[ ! -f "$FFTW_HOME/include/fftw3.h" ]]; then
  echo "ERROR: FFTW headers not found under: $FFTW_HOME/include"
  echo "Set FFTW_HOME to your MXE target prefix containing fftw3.h."
  exit 1
fi

if ! ls "$FFTW_HOME"/lib/libfftw3*.a >/dev/null 2>&1; then
  echo "ERROR: FFTW static libraries not found under: $FFTW_HOME/lib"
  echo "Build MXE package 'fftw' for your target first."
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

export PATH="$MXE_ROOT/usr/bin:$PATH"
export FFTW_HOME

echo "Using qmake: $QMAKE_BIN"
echo "Using FFTW_HOME: $FFTW_HOME"

"$QMAKE_BIN" ../engauge.pro CONFIG+=log4cpp_null
make -j"$(nproc)"

if [[ -f bin/engauge.exe ]]; then
  echo "SUCCESS: built $PWD/bin/engauge.exe"
else
  echo "ERROR: build completed but bin/engauge.exe was not found"
  exit 1
fi
