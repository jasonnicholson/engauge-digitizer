#!/usr/bin/env bash
# deploy.sh — Full release pipeline: version, build, package, changelog,
#              commit, push, deploy docs, and create GitHub release.
#
# Usage:
#   scripts/deploy.sh                       # dry-run (default)
#   scripts/deploy.sh --no-dry-run          # live run
#   scripts/deploy.sh --version 13.2.0      # use explicit version
#
# Prerequisites:
#   - conan 2.x, cmake >= 3.16, pnpm, gh (GitHub CLI)
#   - MXE_ROOT set for Windows cross-build (or skipped with --skip-windows)

set -euo pipefail

# ── Parse arguments ──────────────────────────────────────────────────────────
DRY_RUN=true
SKIP_WINDOWS=false
USER_VERSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-dry-run)   DRY_RUN=false; shift ;;
    --skip-windows) SKIP_WINDOWS=true; shift ;;
    --version)
      if [[ -z "${2:-}" ]]; then
        echo "ERROR: --version requires a version number (e.g. --version 13.2.0)"
        exit 1
      fi
      USER_VERSION="$2"; shift 2
      ;;
    -h|--help)
      echo "Usage: scripts/deploy.sh [--no-dry-run] [--skip-windows] [--version <X.Y.Z>]"
      echo ""
      echo "  --no-dry-run         Perform real commits, pushes, and releases."
      echo "  --skip-windows       Skip the Windows cross-build step."
      echo "  --version <X.Y.Z>   Use the given version instead of calculating it."
      echo ""
      echo "By default runs in dry-run mode: builds and packages but does"
      echo "not commit, push, or create releases."
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
cd "$REPO_ROOT"

if $DRY_RUN; then
  echo "============================================"
  echo "  DRY RUN — no changes will be published"
  echo "============================================"
  echo ""
fi

# ── Sanity checks ────────────────────────────────────────────────────────────
for cmd in cmake conan pnpm gh; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: '$cmd' not found on PATH."
    exit 1
  fi
done

if ! $SKIP_WINDOWS && [[ -z "${MXE_ROOT:-}" ]]; then
  echo "ERROR: MXE_ROOT is not set and --skip-windows was not passed."
  echo "  export MXE_ROOT=/path/to/mxe   OR   scripts/deploy.sh --skip-windows"
  exit 1
fi

# ── 1. Determine version ────────────────────────────────────────────────────
echo "== Step 1: Determining version =="
if [[ -n "$USER_VERSION" ]]; then
  NEW_VERSION="$USER_VERSION"
  echo "Using user-supplied version: v${NEW_VERSION}"
else
  NEW_VERSION=$(pnpm git-conventional-commits version -c git-conventional-commits.yaml)
  if [[ -z "$NEW_VERSION" ]]; then
    echo "ERROR: git-conventional-commits returned an empty version."
    exit 1
  fi
  echo "Calculated version: v${NEW_VERSION}"
fi
TAG="v${NEW_VERSION}"

# Stamp the version into source files so the build picks it up.
sed -i 's/^set(ENGAUGE_VERSION_FULL "[^"]*"/set(ENGAUGE_VERSION_FULL "'"${NEW_VERSION}"'"/' CMakeLists.txt
sed -i 's/^  "version": "[^"]*"/  "version": "'"${NEW_VERSION}"'"/' package.json
echo "Updated CMakeLists.txt and package.json to ${NEW_VERSION}"
echo ""

# ── 2. Build Linux ──────────────────────────────────────────────────────────
echo "== Step 2: Building Linux =="
bash "$SCRIPT_DIR/build_linux_systemqt.sh"
echo ""

# ── 3. Build Windows ────────────────────────────────────────────────────────
if $SKIP_WINDOWS; then
  echo "== Step 3: Skipping Windows build (--skip-windows) =="
else
  echo "== Step 3: Building Windows (MXE cross-compile) =="
  bash "$SCRIPT_DIR/build_windows_conan.sh"
fi
echo ""

# ── 4. Package artifacts ────────────────────────────────────────────────────
echo "== Step 4: Packaging artifacts =="

rm -rf dist
mkdir -p dist/engauge-linux-x86_64/translations

cp build-linux-systemqt/engauge dist/engauge-linux-x86_64/
if ls build-linux-systemqt/translations/engauge_*.qm 1>/dev/null 2>&1; then
  cp build-linux-systemqt/translations/engauge_*.qm dist/engauge-linux-x86_64/translations/
fi

if ! $SKIP_WINDOWS; then
  mkdir -p dist/engauge-windows-x86_64/translations
  cp build-win-conan/engauge.exe dist/engauge-windows-x86_64/
  if ls build-win-conan/translations/engauge_*.qm 1>/dev/null 2>&1; then
    cp build-win-conan/translations/engauge_*.qm dist/engauge-windows-x86_64/translations/
  fi
fi

cd dist
tar -czf engauge-linux-x86_64.tar.gz engauge-linux-x86_64
if ! $SKIP_WINDOWS; then
  zip -9 -r engauge-windows-x86_64.zip engauge-windows-x86_64
fi
sha256sum *.tar.gz *.zip 2>/dev/null > SHA256SUMS.txt || sha256sum *.tar.gz > SHA256SUMS.txt
cd "$REPO_ROOT"

echo "Artifacts in dist/:"
ls -lh dist/*.tar.gz dist/*.zip dist/SHA256SUMS.txt 2>/dev/null
echo ""

# ── 5. Update changelog ─────────────────────────────────────────────────────
echo "== Step 5: Updating changelog =="
if $DRY_RUN; then
  echo "[dry-run] Would prepend v${NEW_VERSION} changelog entry to CHANGELOG.md"
  echo "[dry-run] Preview:"
  pnpm git-conventional-commits changelog -c git-conventional-commits.yaml -r "$NEW_VERSION" 2>&1 || true
else
  pnpm git-conventional-commits changelog -c git-conventional-commits.yaml \
    -r "$NEW_VERSION" -f CHANGELOG.md
  echo "CHANGELOG.md updated."
fi
echo ""

# ── 6. Commit version bump ───────────────────────────────────────────────────
echo "== Step 6: Committing version bump =="
if $DRY_RUN; then
  echo "[dry-run] Would run: git add CHANGELOG.md CMakeLists.txt package.json"
  echo "[dry-run] Would run: git commit -m 'chore: bump version to v${NEW_VERSION}'"
else
  git add CHANGELOG.md CMakeLists.txt package.json
  git commit -m "chore: bump version to v${NEW_VERSION}"
  echo "Committed version bump."
fi
echo ""

# ── 7. Push to remote ───────────────────────────────────────────────────────
echo "== Step 7: Pushing to remote =="
if $DRY_RUN; then
  echo "[dry-run] Would run: git push origin main"
else
  git push origin main
  echo "Pushed to origin/main."
fi
echo ""

# ── 8. Deploy documentation ─────────────────────────────────────────────────
echo "== Step 8: Deploying documentation =="
if $DRY_RUN; then
  echo "[dry-run] Would run: scripts/deploy_docs.sh"
else
  bash "$SCRIPT_DIR/deploy_docs.sh"
  echo "Documentation deployed to gh-pages."
fi
echo ""

# ── 9. Create GitHub release ────────────────────────────────────────────────
echo "== Step 9: Creating GitHub release =="
ASSETS=(dist/engauge-linux-x86_64.tar.gz dist/SHA256SUMS.txt)
if ! $SKIP_WINDOWS; then
  ASSETS+=(dist/engauge-windows-x86_64.zip)
fi

if $DRY_RUN; then
  echo "[dry-run] Would run:"
  echo "  gh release create $TAG \\"
  for a in "${ASSETS[@]}"; do
    echo "    $a \\"
  done
  echo "    --title \"Engauge Digitizer $TAG\" \\"
  echo "    --notes-file <changelog excerpt>"
else
  gh release create "$TAG" \
    "${ASSETS[@]}" \
    --title "Engauge Digitizer $TAG" \
    --generate-notes
  echo "GitHub release $TAG created."
fi
echo ""

# ── Done ─────────────────────────────────────────────────────────────────────
if $DRY_RUN; then
  echo "============================================"
  echo "  DRY RUN COMPLETE — nothing was published"
  echo "============================================"
  echo ""
  echo "To perform a real deployment, run:"
  echo "  scripts/deploy.sh --no-dry-run"
else
  echo "Release v${NEW_VERSION} deployed successfully."
fi
