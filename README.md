# Engauge Digitizer (Maintained Fork)

This repository is an actively maintained work fork of Engauge Digitizer.

Current focus:

- reliable Linux and Windows builds
- portable distribution artifacts (zip/tar.gz)
- improved documentation and release workflow

Packaging into distro-specific packages and installers is welcome. If others want
to repackage this project for platform package managers or native installers,
that is encouraged.

## Build and Release Docs

- Build instructions: BUILD
- Linux runtime troubleshooting: LINUX_RUNTIME_NOTES.md
- Linux static/near-static tracking: STATIC_BUILD_LINUX.md
- Release workflow (artifacts, gh-pages, GitHub Releases): RELEASE_WORKFLOW.md

## Distribution Direction

- Windows: static cross-build artifacts are supported via MXE workflow.
- Linux: near-static/portable distribution is the practical target; fully static
  glibc-linked GUI binaries are fragile across systems.

## Releases

Release artifacts are published on the GitHub Releases page for this fork.

## Documentation Site

Sphinx-based documentation scaffolding is provided under docs/ and is intended
to replace legacy generated root-level website files over time.
