# Engauge Digitizer (Maintained Fork)

This repository is an actively maintained fork of Engauge Digitizer.

Current focus:

- reliable Linux and Windows builds
- portable distribution artifacts (zip/tar.gz)
- improved documentation and release workflow

Packaging into distro-specific packages and installers is welcome. If others want
to repackage this project for platform package managers or native installers,
that is encouraged.

## Why?

### Why am I maintaining a fork?

Mark Mitchell's version on GitHub disappeared. It was here: https://github.com/markummitchell/engauge-digitizer/releases/latest. I found a fork and stashed it around May 2025. As of 2026-04-11, Engauge Digitizer is maintained here: https://engaugedigitizer.com/.

### Why Engauge Digitizer? Why not just use another tool?

WebPlotDigitizer is a great tool, but you either have to upload sensitive data to a web service or download an AGPL-licensed binary. AGPL licenses give users access to all source code on servers running the software. Therefore, most corporations completely forbid use of AGPL software. Engauge is a great, free alternative with an acceptable license.

### Why not just use the original Engauge Digitizer?

Go ahead. That is a fine choice. My plan here is static builds and a Sphinx site for documentation. If this suits your needs, great. If not, the original may be a better fit.

I am upgrading from Qt5 to Qt6. v13.0.0 is Qt5 and works fine. v14.0.0 and beyond is Qt6.

I am dropping PDF support. The PDF support adds complexity disproportionate to the value it provides. Export an image from the PDF and import that instead.

I am also not going to build for macOS. I am going to cross-compile for Windows and build on Linux.

Overall, I don't have a lot of bandwidth to maintain or improve this project. My plan is to keep binaries working but not much more than that.

I have no plans to distribute this project through Linux distro package managers. I will provide static builds for Linux and Windows on GitHub Releases. If others want to repackage this project for platform package managers or native installers, that is encouraged.

No installer will be provided for any platform. Static builds mean the folder of files is standalone.


## Documentation

Full documentation is at: **https://jasonnicholson.github.io/engauge-digitizer/**

Key sections:

- [Build and Release](https://jasonnicholson.github.io/engauge-digitizer/build-and-release.html)
- [Linux Runtime Troubleshooting](https://jasonnicholson.github.io/engauge-digitizer/linux-runtime.html)
- [Developer Guide](https://jasonnicholson.github.io/engauge-digitizer/developer.html)

## Quick Build

**Linux** (system Qt + Conan for third-party deps):

```bash
pipx install conan   # one-time
bash build_linux_systemqt.sh
```

The script uses Conan to install `fftw` and `openjpeg` and then configures
CMake with the generated toolchain.

**Windows** (MXE cross-compile):

```bash
export MXE_ROOT=/path/to/your/mxe   # e.g. $HOME/workspace/mxe-qt6
./build_windows_mxe.sh
```

## Releases

Release artifacts (Linux and Windows binaries) are published on the
[GitHub Releases](https://github.com/jasonnicholson/engauge-digitizer/releases) page.

