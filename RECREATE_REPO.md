# Repo Delete & Recreate Guide (LFS Fix)

This guide converts the GitHub fork to a standalone repo so that Git LFS
object uploads work. After completion, `GIT_LFS_SKIP_PUSH=1` can be dropped
from all push commands.

## Why

GitHub blocks LFS uploads to public forks. The repo must be a standalone
(non-fork) repository for LFS to work.

## Prerequisites

- `gh` CLI authenticated (`gh auth status`)
- Local backup exists: `~/engauge-full-backup-20260409.bundle`
- LFS objects live in `.git/lfs/` locally — **do not delete the local repo**
  until after the new repo is fully pushed.

## Step 1 — Delete the Fork on GitHub

> **Warning**: this is irreversible. The backup bundle is your safety net.

```bash
gh repo delete jasonnicholson/engauge-digitizer --yes
```

## Step 2 — Create a New Standalone Repo

```bash
gh repo create jasonnicholson/engauge-digitizer \
  --public \
  --description "Actively maintained fork of Engauge Digitizer" \
  --homepage "https://jasonnicholson.github.io/engauge-digitizer/"
```

## Step 3 — Enable LFS on the New Repo

Git LFS is enabled per-account, not per-repo, but confirm it is tracked:

```bash
cd /home/jason/Desktop/engauge-digitizer
git lfs ls-files | wc -l   # should show 205
```

## Step 4 — Push Everything (with LFS)

```bash
cd /home/jason/Desktop/engauge-digitizer

# Push master branch + LFS objects
git push origin master

# Push gh-pages (Sphinx site) — no LFS needed here
git push origin gh-pages
```

Git LFS will upload all 205 binary objects on the first push. This may take
a few minutes depending on connection speed.

## Step 5 — Re-enable GitHub Pages

In the GitHub repo settings → Pages:

- Source: `Deploy from a branch`
- Branch: `gh-pages` / `/ (root)`

If you have the custom domain `jasonhnicholson.com`:

- Add it under Custom domain
- The `docs/` build will push a `CNAME` file automatically via ghp-import `-n`

## Step 6 — Verify

```bash
# LFS objects visible on GitHub
gh api repos/jasonnicholson/engauge-digitizer | jq .size

# Site loads
curl -I https://jasonnicholson.github.io/engauge-digitizer/
```

## After Completion

Drop `GIT_LFS_SKIP_PUSH=1` from all commands:

```bash
# Normal push going forward
git push origin master

# Docs deploy
cd docs
rm -rf build
uv run sphinx-build -b html source build -W
uv run ghp-import -n -p -f build -m "docs(site): update"
```

## Recovery (if something goes wrong)

Restore from the bundle:

```bash
git clone ~/engauge-full-backup-20260409.bundle engauge-digitizer-restored
cd engauge-digitizer-restored
git remote set-url origin https://github.com/jasonnicholson/engauge-digitizer.git
git push origin master gh-pages
```
