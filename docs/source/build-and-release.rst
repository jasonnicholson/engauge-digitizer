Build and Release
=================

Distribution direction:

- **Windows** — static cross-build artifacts via MXE toolchain
- **Linux** — dynamically linked build against distro Qt; near-static portability is the target

Building from Source
--------------------

Linux
^^^^^

Install dependencies::

   sudo apt install qtbase5-dev qtbase5-dev-tools qttools5-dev qttools5-dev-tools \
                    libfftw3-dev libjpeg-dev

Build::

   mkdir -p build-linux-systemqt
   cd build-linux-systemqt
   /usr/bin/x86_64-linux-gnu-qmake ../engauge.pro
   make -j$(nproc)

Binary: ``build-linux-systemqt/bin/engauge``

In environments with mixed Qt4/Qt5 set ``QT_SELECT=qt5`` before running qmake.

Windows (MXE cross-compile)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

From repository root::

   ./build_windows_mxe.sh

Requires MXE with the Qt5 static x86_64 target. Set ``MXE_ROOT`` if installed
outside the default ``/home/jason/workspace/mxe``. See ``build_windows_mxe.sh``
for all overridable variables.

Binary: ``build-win-mxe/bin/engauge.exe``

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
   cp build-win-mxe/bin/engauge.exe dist/engauge-windows-x86_64.exe
   cp build-linux-systemqt/bin/engauge dist/engauge-linux-x86_64

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

From the ``docs/`` directory::

   rm -rf build
   uv run sphinx-build -b html source build -W
   GIT_LFS_SKIP_PUSH=1 uv run ghp-import -n -p -f build -m "docs(site): update"

.. note::

   ``GIT_LFS_SKIP_PUSH=1`` is required while the repository is a GitHub fork
   (forks cannot upload LFS objects). After converting to a standalone repo,
   the variable can be dropped.
