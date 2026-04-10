# Release Workflow

This document captures the workflow used to build binaries, publish the project website via gh-pages, and upload artifacts to GitHub Releases.

## 1) Build Artifacts

### Windows (static cross-build with MXE)

From repository root:

```bash
./build_windows_mxe.sh
```

Expected artifact:

- `build-win-mxe/bin/engauge.exe`

### Linux (standard runtime build)

From repository root:

```bash
mkdir -p build-linux-systemqt
cd build-linux-systemqt
/usr/bin/x86_64-linux-gnu-qmake ../engauge.pro
make -j"$(nproc)"
```

Expected artifact:

- `build-linux-systemqt/bin/engauge`

## 2) Package Artifacts

From repository root:

```bash
mkdir -p dist
cp build-win-mxe/bin/engauge.exe dist/engauge-windows-x86_64.exe
cp build-linux-systemqt/bin/engauge dist/engauge-linux-x86_64

cd dist
sha256sum engauge-windows-x86_64.exe engauge-linux-x86_64 > SHA256SUMS.txt
zip -9 engauge-windows-x86_64.zip engauge-windows-x86_64.exe
chmod +x engauge-linux-x86_64
.tar_name="engauge-linux-x86_64.tar.gz"
tar -czf "$tar_name" engauge-linux-x86_64
```

## 3) Redeploy Website to gh-pages

If the generated website files are already present in the repository root while on branch `gh-pages`:

```bash
git checkout gh-pages
git add -A
git commit -m "docs(site): refresh gh-pages content"
git push origin gh-pages
```

## 4) Upload Binaries to GitHub Release

List releases first:

```bash
gh release list
```

Upload to an existing tag (example tag `v12.0`):

```bash
gh release upload v12.0 \
  dist/engauge-windows-x86_64.zip \
  dist/engauge-linux-x86_64.tar.gz \
  dist/SHA256SUMS.txt \
  --clobber
```

Or create a new release and upload in one step:

```bash
gh release create vYYYY.MM.DD \
  dist/engauge-windows-x86_64.zip \
  dist/engauge-linux-x86_64.tar.gz \
  dist/SHA256SUMS.txt \
  --title "Engauge build vYYYY.MM.DD" \
  --notes "Automated build artifacts for Linux and Windows."
```
