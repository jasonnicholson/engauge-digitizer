Build and Release
=================

Distribution direction:

- **Windows** — static cross-build via MXE toolchain with Qt6; produces a single portable ``.exe``
- **Linux (distro Qt)** — dynamically linked against the OS Qt6 packages; simple and fast
- **Linux (almost-static)** — linked against a self-built Qt6 install; portable across distros

Building from Source
--------------------

Linux — distro Qt (quick build)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install dependencies::

   sudo apt install qt6-base-dev qt6-tools-dev qt6-tools-dev-tools qt6-l10n-tools \
                    libfftw3-dev libjpeg-dev libopenjp2-7-dev cmake

For PDF support (``-DENGAUGE_PDF=ON`` in the build script), install
``poppler-qt6`` development files. On Ubuntu 22.04 this is typically built
from source and installed under ``$HOME/.local``. Ensure ``PKG_CONFIG_PATH``
contains that location (the Linux build script already prepends
``$HOME/.local/lib/pkgconfig``).

Build::

   bash build_linux_systemqt.sh

Binary: ``build-linux-systemqt/engauge``

Linux — almost-static Qt6 (portable build)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Builds against a custom Qt6 install (for example ``/opt/qt6-linux``),
then bundles Qt ``.so`` libraries and plugins next to the executable. This
removes runtime dependency on distro Qt packages while still relying on core
system libraries (``glibc``, X11, OpenGL, etc.).

Prerequisite::

   sudo apt-get install patchelf

Build and package::

   bash build_linux_almoststaticqt.sh

Binary: ``build-linux-almoststaticqt/engauge``
Tarball: ``dist/engauge-linux-almoststatic-x86_64.tar.gz``
Bundle root: ``dist/almoststatic-linux-x86_64``

Set ``QT_PREFIX`` if your Qt6 install is not under ``/opt/qt6-linux``.

Windows (MXE cross-compile with Qt6)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

From repository root::

   export MXE_ROOT=$HOME/mxe
   ./build_windows_mxe.sh

Requires MXE built with Qt6 and CMake support for the x86_64 static target.
``MXE_ROOT`` must be set to your MXE installation directory.

The script expects these MXE target packages to be present:

- ``fftw``
- ``openjpeg`` (JPEG2000)
- ``poppler-qt6`` (PDF)

Example MXE package install commands::

   make -C "$MXE_ROOT" qt6 MXE_TARGETS=x86_64-w64-mingw32.static
   make -C "$MXE_ROOT" fftw openjpeg poppler-qt6 MXE_TARGETS=x86_64-w64-mingw32.static

Unit tests are disabled automatically for this MXE build lane
(``-DBUILD_TESTING=OFF``) so cross-builds do not require ``Qt6::Test``.

See ``build_windows_mxe.sh`` for all overridable variables.

Binary: ``build-win-mxe/engauge.exe``

Tests
-----

Command-line tests::

   cd src
   ./build_and_run_all_cli_tests

GUI tests::

   cd src
   ./build_and_run_all_gui_tests

Packaging Artifacts
-------------------

From repository root::

   mkdir -p dist
   cp build-win-mxe/engauge.exe dist/engauge-windows-x86_64.exe
   cp build-linux-systemqt/engauge dist/engauge-linux-x86_64

   cd dist
   sha256sum engauge-windows-x86_64.exe engauge-linux-x86_64 > SHA256SUMS.txt
   zip -9 engauge-windows-x86_64.zip engauge-windows-x86_64.exe
   tar -czf engauge-linux-x86_64.tar.gz engauge-linux-x86_64

GitHub Release Upload
-----------------------

.. code-block:: bash

   # Create a new release
   gh release create vYYYY.MM.DD \
     dist/engauge-windows-x86_64.zip \
     dist/engauge-linux-x86_64.tar.gz \
     dist/SHA256SUMS.txt \
     --title "Engauge build vYYYY.MM.DD" \
     --notes "Automated build artifacts for Linux and Windows."

   # Or upload to an existing tag
   gh release upload vTAG \
     dist/engauge-windows-x86_64.zip \
     dist/engauge-linux-x86_64.tar.gz \
     dist/SHA256SUMS.txt \
     --clobber

Deploying the Documentation Site
---------------------------------

Run the deploy script from the repository root::

   docs/deploy.sh

The script builds Sphinx, then uses ``git commit-tree`` to create a parentless
commit and force-pushes it to ``gh-pages``.  The branch always contains exactly
one commit — no history accumulates, and rolling back means rebuilding from the
Sphinx sources on ``master``.

**How it works:**

1. ``git rev-parse --show-toplevel`` — locate the repository root portably.
2. Stage ``docs/build/`` into a throwaway ``GIT_INDEX_FILE`` so the real index
   is untouched (``--force`` bypasses ``.gitignore``).
3. ``git write-tree --prefix=docs/build/`` — extract the subtree as a tree
   object rooted at ``/`` (``index.html``, ``_static/``, etc. at the top level).
4. ``git commit-tree <tree>`` with no ``-p`` parent — creates the orphan commit.
5. ``git branch -f gh-pages <commit>`` — advance (or create) the local ref.
6. ``git push origin gh-pages --force`` — publish.
