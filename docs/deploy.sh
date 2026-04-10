#!/usr/bin/env bash
# deploy.sh — Build Sphinx docs and deploy to gh-pages as a single orphan commit.
#
# Strategy: use a throwaway index to stage docs/build/, extract its tree with
# git-write-tree --prefix, then create a parentless commit via git-commit-tree
# and force-push the ref.  No history accumulates; rollback = rebuild from source.

set -euo pipefail

DOCS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "$DOCS_DIR" rev-parse --show-toplevel)"
BUILD_DIR="$DOCS_DIR/build"
DOCS_REL="docs/build"   # path relative to repo root

# ── 1. Build ─────────────────────────────────────────────────────────────────
cd "$DOCS_DIR"
rm -rf "$BUILD_DIR"
uv run sphinx-build -b html source "$BUILD_DIR" -W

# Suppress GitHub Pages Jekyll processing
touch "$BUILD_DIR/.nojekyll"

# ── 2. Stage build output into a throwaway index ─────────────────────────────
# mktemp gives us a unique path; remove the empty file so git creates its own
TMPINDEX=$(mktemp)
rm -f "$TMPINDEX"
trap 'rm -f "$TMPINDEX"' EXIT

cd "$REPO_ROOT"

# Add every file in docs/build/ with --force so .gitignore doesn't skip them
GIT_INDEX_FILE="$TMPINDEX" git add --force -- "$DOCS_REL/"

# Extract only the subtree rooted at docs/build/ — result is suitable as a
# standalone repo root (index.html at /, _static/ at /, etc.)
TREE=$(GIT_INDEX_FILE="$TMPINDEX" git write-tree --prefix="$DOCS_REL/")

# ── 3. Create a parentless (orphan) commit ───────────────────────────────────
DEPLOY_DATE=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
COMMIT=$(git commit-tree "$TREE" -m "docs(site): deploy $DEPLOY_DATE")

# ── 4. Point the local gh-pages branch at the new commit ─────────────────────
git branch -f gh-pages "$COMMIT"

# ── 5. Force-push — gh-pages will always be exactly one commit ───────────────
git push origin gh-pages --force

echo "Deployed $COMMIT to gh-pages ($DEPLOY_DATE)"
