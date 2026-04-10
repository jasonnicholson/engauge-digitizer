# Engauge Digitizer (Maintained Fork)

This repository is an actively maintained work fork of Engauge Digitizer.

Current focus:

- reliable Linux and Windows builds
- portable distribution artifacts (zip/tar.gz)
- improved documentation and release workflow

Packaging into distro-specific packages and installers is welcome. If others want
to repackage this project for platform package managers or native installers,
that is encouraged.

## Documentation

Full documentation is at: **https://jasonnicholson.github.io/engauge-digitizer/**

Key sections:

- [Build and Release](https://jasonnicholson.github.io/engauge-digitizer/build-and-release.html)
- [Linux Runtime Troubleshooting](https://jasonnicholson.github.io/engauge-digitizer/linux-runtime.html)
- [Linux Static Build Strategy](https://jasonnicholson.github.io/engauge-digitizer/static-linux.html)
- [Developer Guide](https://jasonnicholson.github.io/engauge-digitizer/developer.html)

## Quick Build

**Linux** (distro Qt):

```bash
mkdir -p build-linux-systemqt && cd build-linux-systemqt
/usr/bin/x86_64-linux-gnu-qmake ../engauge.pro
make -j$(nproc)
```

**Windows** (MXE cross-compile):

```bash
./build_windows_mxe.sh
```

## Releases

Release artifacts (Linux and Windows binaries) are published on the
[GitHub Releases](https://github.com/jasonnicholson/engauge-digitizer/releases) page.

