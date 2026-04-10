# Linux Static Build Plan (In Progress)

This document tracks the effort to produce a static Linux build for Engauge.

## Current Status

- Windows static build: achievable via MXE target toolchain.
- Linux fully static build: not yet achieved with current distro-shared Qt setup.
- Current Linux output remains dynamically linked.

## Why This Is Hard

- Standard distro Qt packages are shared-library builds.
- A true static link requires a static Qt build and static variants of key dependencies.
- glibc static linking has portability caveats (NSS, resolver, locale, plugin behavior).

## Target Outcome

Produce a reproducible Linux build process with near-static portability as the
primary goal:

1. Near-static binary plus documented runtime/system assumptions (preferred), or
2. Documented decision to ship AppImage/Flatpak as the portable Linux artifact, or
3. Fully static binary only if it proves practical and stable.

## Phase 1: Baseline Verification

From repository root:

```bash
qmake engauge.pro
make -j"$(nproc)"
file ./bin/engauge
ldd ./bin/engauge
```

Record here:

- Date:
- Branch/commit:
- qmake version:
- Binary type:
- Key dynamic deps:

## Phase 2: Build Static Qt

Prerequisites (static variants) typically needed:

- zlib
- libpng
- libjpeg
- freetype
- harfbuzz
- pcre2
- sqlite
- xcb/x11 stack (if using xcb platform plugin)

Example Qt configure shape (adjust to your environment):

```bash
./configure \
  -static \
  -release \
  -opensource -confirm-license \
  -prefix <qt-static-prefix> \
  -qt-zlib -qt-libpng -qt-libjpeg -qt-freetype -qt-pcre -qt-harfbuzz \
  -nomake examples -nomake tests
make -j"$(nproc)"
make install
```

Record here:

- Qt source version:
- Configure flags used:
- Platform plugin strategy (xcb/minimal/offscreen):
- Build errors and fixes:

## Phase 3: Build Engauge Against Static Qt

```bash
export PATH="<qt-static-prefix>/bin:$PATH"
qmake engauge.pro CONFIG+=log4cpp_null
make -j"$(nproc)"
file ./bin/engauge
ldd ./bin/engauge || true
```

Record here:

- Did link succeed?
- Is binary still dynamic?
- Missing static libs encountered:

## Phase 4: Runtime Validation

```bash
./bin/engauge
```

If headless check is needed:

```bash
QT_QPA_PLATFORM=offscreen ./bin/engauge
```

Record here:

- Launch result:
- Plugin/runtime errors:
- Workarounds:

## Decision Log

Use this section to make explicit ship/no-ship decisions.

- [x] Near-static with constraints is the primary direction.
- [ ] AppImage/Flatpak is the recommended portable Linux deliverable.
- [ ] Fully static Linux binary is practical and reproducible.

## Notes

- Document every command variant that was tried and why it failed/succeeded.
- Keep entries concise and factual so the process is reproducible.
