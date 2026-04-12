Build and Release
=================

Distribution direction:

- **Windows** — static cross-build via MXE Qt6 plus Conan-managed third-party deps; produces a single portable ``.exe``
- **Linux** — dynamically linked against OS Qt6 packages with Conan-managed third-party deps

Building from Source
--------------------

Linux (system Qt6)
^^^^^^^^^^^^^^^^^^^

Install dependencies::

   sudo apt install qt6-base-dev qt6-tools-dev qt6-tools-dev-tools qt6-l10n-tools cmake pipx
   pipx install conan

Build::

   bash scripts/build_linux_systemqt.sh

Binary: ``build-linux-systemqt/engauge``

Windows (MXE Qt6 + Conan cross-compile)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Prerequisites: Setting up MXE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Windows build uses `MXE (M Cross Environment) <https://mxe.cc>`_ to cross-compile
from Linux. MXE provides a pre-built MinGW-w64 toolchain with Qt6 and other libraries
as static packages.

**Install MXE:**

1. Clone the MXE repository (or download a pre-built version)::

      git clone https://github.com/mxe/mxe.git
      cd mxe

2. Build MXE with Qt6 support for the x86_64 static target (this takes 30+ minutes)::

      make qt6 MXE_TARGETS=x86_64-w64-mingw32.static -j$(nproc)

   Alternatively, if you only need CMake (already included in the Qt6 build):

      make cmake MXE_TARGETS=x86_64-w64-mingw32.static -j$(nproc)

3. Add MXE to your environment (in your ``.bashrc`` or ``.zshrc``)::

      export MXE_ROOT=$HOME/mxe   # adjust path if installed elsewhere
      export PATH="$MXE_ROOT/usr/bin:$PATH"

   Verify the toolchain is available::

      x86_64-w64-mingw32.static-gcc --version
      x86_64-w64-mingw32.static-cmake --version

**MXE Build Options:**

- Use ``MXE_TARGETS=x86_64-w64-mingw32.shared`` for a shared-lib build (larger, but faster to link)
- Use ``MXE_TARGETS=i686-w64-mingw32.static`` for 32-bit Windows
- See `MXE documentation <https://mxe.cc>`_ for detailed build customization

Building engauge.exe
~~~~~~~~~~~~~~~~~~~~

From repository root::

   pipx install conan
   export MXE_ROOT=/path/to/your/mxe   # e.g. $HOME/workspace/mxe-qt6
   ./scripts/build_windows_conan.sh

Requires MXE built with Qt6 and CMake support for the x86_64 static target.
``MXE_ROOT`` must be set to your MXE installation directory.

Example MXE package install commands::

   make -C "$MXE_ROOT" qt6 MXE_TARGETS=x86_64-w64-mingw32.static

Unit tests are disabled automatically for this MXE build lane
(``-DBUILD_TESTING=OFF``) so cross-builds do not require ``Qt6::Test``.

See ``scripts/build_windows_conan.sh`` for all overridable variables.

Binary: ``build-win-conan/engauge.exe``

Building from Windows (native)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**To Be Determined (TBD).**

Native Windows build instructions are not finalized yet. Current documented
support is Linux-native builds and Linux-to-Windows cross-compilation via MXE.

Tests
-----

Linux unit tests (CMake / CTest)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Linux build script enables ``BUILD_TESTING=ON`` by default. After
building, run::

   cd build-linux-systemqt
   ctest --output-on-failure -j$(nproc)

Thirteen of the sixteen tests are pure math/utility tests that run without
a display server. ``TestExport`` and ``TestGuidelines`` instantiate
``MainWindow`` and require a display (real or virtual). On a headless CI
machine, wrap them in ``xvfb-run``::

   xvfb-run ctest --output-on-failure -j$(nproc)

Windows tests via Wine
^^^^^^^^^^^^^^^^^^^^^^

Unit tests are disabled for the MXE cross-build (``BUILD_TESTING=OFF``),
because Qt6::Test is not easily available under Wine. To smoke-test the
Windows binary interactively::

   xvfb-run wine build-win-conan/engauge.exe

Release Pipeline
----------------

All packaging, versioning, changelog, and deployment steps are automated by
``scripts/deploy.sh``.

Dry run (default)
^^^^^^^^^^^^^^^^^

Run from the repository root::

   scripts/deploy.sh

This builds Linux and Windows binaries, packages artifacts, calculates the
next version, and previews what *would* happen — but does not commit, push,
or create any release. Use this to verify everything before going live.

Live deployment
^^^^^^^^^^^^^^^

::

   scripts/deploy.sh --no-dry-run

The pipeline performs these steps:

1. **Determine version** — ``git-conventional-commits version`` calculates the next semver from commit history (or uses ``--version`` if given)
2. **Build Linux** — runs ``scripts/build_linux_systemqt.sh``
3. **Build Windows** — runs ``scripts/build_windows_conan.sh`` (requires ``MXE_ROOT``; pass ``--skip-windows`` to skip)
4. **Package artifacts** — copies binaries + translations into ``dist/``, creates ``.tar.gz`` / ``.zip`` archives, generates ``SHA256SUMS.txt``
5. **Update changelog** — ``git-conventional-commits changelog`` prepends the new release entry to ``CHANGELOG.md``
6. **Commit** — commits ``CHANGELOG.md`` as ``chore: bump version to vX.Y.Z``
7. **Push** — pushes to ``origin/main``
8. **Deploy docs** — runs ``scripts/deploy_docs.sh`` (orphan-commits Sphinx output to ``gh-pages``)
9. **Create GitHub release** — ``gh release create vX.Y.Z`` with the packaged archives

Options
^^^^^^^

``--no-dry-run``
  Execute all mutation steps (commit, push, release). Without this flag,
  the script only builds and previews.

``--skip-windows``
  Skip the Windows cross-build. Useful when ``MXE_ROOT`` is not available
  or you only need a Linux release.

``--version <X.Y.Z>``
  Use the given version instead of calculating it from commit history.

Deploying Documentation Only
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To rebuild and deploy the Sphinx site without a full release::

   scripts/deploy_docs.sh

The script builds Sphinx, then uses ``git commit-tree`` to create a parentless
commit and force-pushes it to ``gh-pages``.  The branch always contains exactly
one commit — no history accumulates, and rolling back means rebuilding from the
Sphinx sources on ``main``.
