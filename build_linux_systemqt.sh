#!/usr/bin/env bash
set -euo pipefail

# Builds engauge (Linux) against the system Qt5 installation.

QMAKE_BIN="${QMAKE_BIN:-$(command -v x86_64-linux-gnu-qmake qmake-qt5 2>/dev/null | head -1)}"
BUILD_DIR="${BUILD_DIR:-build-linux-systemqt}"

if [[ -z "${QMAKE_BIN:-}" ]] || [[ ! -x "$QMAKE_BIN" ]]; then
  echo "ERROR: qmake not found. Install qt5-qmake / qtbase5-dev-tools, or set QMAKE_BIN."
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "Using qmake: $QMAKE_BIN"
"$QMAKE_BIN" ../engauge.pro
make -j"$(nproc)"

if [[ -f bin/engauge ]]; then
  echo "SUCCESS: built $PWD/bin/engauge"
else
  echo "ERROR: build completed but bin/engauge was not found"
  exit 1
fi
