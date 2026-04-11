#!/usr/bin/env bash
# Run all CLI regression tests and report PASS/FAIL.
#
# Usage: run_cli_regression.sh [--update] [filter...]
#   --update   overwrite csv_expected_N with csv_actual_N for all passing-format tests
#   filter     optional substring; only run tests whose name contains it
#
# Must be run from the repository root directory with the engauge binary at
# build-linux/engauge (or set ENGAUGE_BIN to override).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "$ROOT_DIR"

ENGAUGE_BIN="${ENGAUGE_BIN:-$ROOT_DIR/build-linux/engauge}"
TEST_DIR="$ROOT_DIR/test"

if [[ ! -x "$ENGAUGE_BIN" ]]; then
  echo "ERROR: engauge binary not found at $ENGAUGE_BIN"
  echo "  Set ENGAUGE_BIN or build with: cmake --build build-linux --parallel \$(nproc)"
  exit 1
fi

# Timezone used when the expected files were generated
export TZ='America/Los_Angeles'

# Use an accessible X display if available, otherwise offscreen
if [[ -z "${DISPLAY:-}" ]]; then
  if [[ -S "/tmp/.X11-unix/X1" ]]; then
    export DISPLAY=:1
  else
    export QT_QPA_PLATFORM=offscreen
  fi
fi

UPDATE=0
FILTERS=()
for arg in "$@"; do
  if [[ "$arg" == "--update" ]]; then UPDATE=1
  else FILTERS+=("$arg")
  fi
done

PASS=0
FAIL=0
SKIP=0

run_test() {
  local cmdfile="$1"
  local scriptname
  scriptname="$(basename "$cmdfile")"
  local root="${scriptname/.test.commandline/}"

  # Apply name filters
  if [[ ${#FILTERS[@]} -gt 0 ]]; then
    local matched=0
    for f in "${FILTERS[@]}"; do
      [[ "$root" == *"$f"* ]] && matched=1 && break
    done
    [[ $matched -eq 0 ]] && return
  fi

  # Skip tests that require network or pdf/jpeg2000 features
  [[ $root == *"drag_and_drop_http"* ]] && { (( SKIP += 1 )) || true; echo "SKIPPED: $root (network)"; return; }
  [[ $root == *"jpeg2000"* ]]           && { (( SKIP += 1 )) || true; echo "SKIPPED: $root (jpeg2000)"; return; }
  [[ $root == *"pdf"* ]]                && { (( SKIP += 1 )) || true; echo "SKIPPED: $root (pdf)"; return; }

  local args
  args="$(cat "$cmdfile")"

  # Run engauge in the build-linux directory so relative paths in the commandline file work
  # (commandline files use paths like ../test/..., relative to the binary's working directory)
  local logfile
  logfile="$(mktemp /tmp/engauge_XXXXXX.log)"

  (cd "$ROOT_DIR/build-linux" && eval "$ENGAUGE_BIN $args" > "$logfile" 2>&1) &
  local pid=$!

  # Wait up to 30 seconds for the test to finish
  local waited=0
  while kill -0 $pid 2>/dev/null; do
    sleep 1
    (( waited += 1 )) || true
    if [[ $waited -ge 30 ]]; then
      kill $pid 2>/dev/null || true
      echo "TIMEOUT: $root (30s)"
      rm -f "$logfile"
      (( FAIL += 1 )) || true
      return
    fi
  done
  wait $pid
  rm -f "$logfile"

  # Compare actual vs expected CSV output files
  local expected_files
  mapfile -t expected_files < <(find "$TEST_DIR" -name "${root}.csv_expected_*" | sort)

  if [[ ${#expected_files[@]} -eq 0 ]]; then
    echo "SKIPPED: $root (no expected files)"
    (( SKIP += 1 )) || true
    return
  fi

  local count=${#expected_files[@]}
  local counter=1
  local any_fail=0

  for expected in "${expected_files[@]}"; do
    local actual="${expected/expected/actual}"
    local counter_str=""
    [[ $count -gt 1 ]] && counter_str=" [$counter/$count]"

    if [[ ! -f "$actual" ]]; then
      echo "FAIL   : $root${counter_str} (actual file missing: $(basename "$actual"))"
      any_fail=1
    else
      # Filter XXX-marked lines (values too small to compare reliably)
      cp "$expected" /tmp/.expected_cmp
      cp "$actual"   /tmp/.actual_cmp
      local xxx_lines
      mapfile -t xxx_lines < <(grep -n 'XXX' /tmp/.expected_cmp | cut -d: -f1 | sort -rn)
      for line in "${xxx_lines[@]}"; do
        sed -i "${line}d" /tmp/.expected_cmp
        sed -i "${line}d" /tmp/.actual_cmp
      done

      if cmp --silent /tmp/.expected_cmp /tmp/.actual_cmp; then
        echo "PASS   : $root${counter_str}"
        if [[ $UPDATE -eq 1 ]]; then
          cp "$actual" "$expected"
        fi
      else
        echo "FAIL   : $root${counter_str}"
        diff -u /tmp/.expected_cmp /tmp/.actual_cmp || true
        any_fail=1
      fi
    fi
    (( counter += 1 )) || true
  done

  if [[ $any_fail -eq 1 ]]; then (( FAIL += 1 )) || true
  else (( PASS += 1 )) || true
  fi
}

# Iterate tests in sorted order
while IFS= read -r -d '' cmdfile; do
  run_test "$cmdfile"
done < <(find "$TEST_DIR" -name "*.test.commandline" -print0 | sort -z)

echo ""
echo "Results: $PASS passed, $FAIL failed, $SKIP skipped"

if [[ $FAIL -gt 0 ]]; then exit 1; fi
