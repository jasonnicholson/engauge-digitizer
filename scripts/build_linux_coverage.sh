#!/usr/bin/env bash
set -euo pipefail

# Builds engauge with gcov instrumentation and produces an lcov coverage report.
# Prerequisites: gcc, gcov, lcov, genhtml (apt-get install lcov)

BUILD_DIR="${BUILD_DIR:-build-linux-coverage}"
REPORT_DIR="${REPORT_DIR:-coverage-report}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/../ && pwd)"
cd "$ROOT_DIR"

for tool in cmake gcov lcov genhtml; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "ERROR: $tool not found. Install it first."
    exit 1
  fi
done

echo "== Configuring with coverage flags =="
cmake -B "$BUILD_DIR" -S . \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_FLAGS="--coverage" \
  -DCMAKE_EXE_LINKER_FLAGS="--coverage" \
  -DBUILD_TESTING=ON \
  -DENGAUGE_LOG4CPP_NULL=ON \
  -DENGAUGE_JPEG2000=ON

echo "== Building =="
cmake --build "$BUILD_DIR" --parallel "$(nproc)"

echo "== Zeroing counters =="
lcov --zerocounters --directory "$BUILD_DIR"

echo "== Running tests =="
cd "$BUILD_DIR"
ctest --output-on-failure
cd "$ROOT_DIR"

echo "== Capturing coverage data =="
lcov --capture \
     --directory "$BUILD_DIR" \
     --output-file "$BUILD_DIR/coverage.info" \
     --ignore-errors mismatch

echo "== Filtering to project sources only =="
lcov --extract "$BUILD_DIR/coverage.info" \
     "$(pwd)/src/*" \
     --output-file "$BUILD_DIR/coverage_filtered.info" \
     --ignore-errors unused

echo "== Generating HTML report =="
genhtml "$BUILD_DIR/coverage_filtered.info" \
        --output-directory "$REPORT_DIR" \
        --title "Engauge Digitizer Coverage"

echo ""
echo "SUCCESS: coverage report at $REPORT_DIR/index.html"
echo "  Open with: xdg-open $REPORT_DIR/index.html"
