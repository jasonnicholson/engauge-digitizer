Build and Release
=================

Distribution direction:

- **Windows** — static cross-build via MXE Qt6 plus Conan-managed third-party deps; produces a single portable ``.exe``
- **Linux** — dynamically linked against OS Qt6 packages with Conan-managed third-party deps

Building from Source
--------------------

Linux (system Qt6)
^^^^^^^^^^^^^^^^^

Install dependencies::

   sudo apt install qt6-base-dev qt6-tools-dev qt6-tools-dev-tools qt6-l10n-tools cmake pipx
   pipx install conan

Build::

   bash build_linux_systemqt.sh

Binary: ``build-linux-systemqt/engauge``

Windows (MXE Qt6 + Conan cross-compile)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

From repository root::

   pipx install conan
   export MXE_ROOT=/path/to/your/mxe   # e.g. $HOME/workspace/mxe-qt6
   ./build_windows_conan.sh

Requires MXE built with Qt6 and CMake support for the x86_64 static target.
``MXE_ROOT`` must be set to your MXE installation directory.

Example MXE package install commands::

   make -C "$MXE_ROOT" qt6 MXE_TARGETS=x86_64-w64-mingw32.static

Unit tests are disabled automatically for this MXE build lane
(``-DBUILD_TESTING=OFF``) so cross-builds do not require ``Qt6::Test``.

See ``build_windows_conan.sh`` for all overridable variables.

Binary: ``build-win-conan/engauge.exe``

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

Legacy test scripts
^^^^^^^^^^^^^^^^^^^

Packaging Artifacts
-------------------

From repository root::

   mkdir -p dist
   cp build-win-conan/engauge.exe dist/engauge-windows-x86_64.exe
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
