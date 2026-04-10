Build and Release
=================

Distribution direction:

- **Windows** — static cross-build via MXE toolchain; produces a single portable ``.exe``
- **Linux (distro Qt)** — dynamically linked against the OS Qt5 packages; simple and fast
- **Linux (almost-static)** — linked against a self-built static Qt; portable across distros

Building from Source
--------------------

Linux — distro Qt (quick build)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install dependencies::

   sudo apt install qtbase5-dev qtbase5-dev-tools qttools5-dev qttools5-dev-tools \
                    libfftw3-dev libjpeg-dev

Build::

   bash build_linux_systemqt.sh

Binary: ``build-linux-systemqt/bin/engauge``

The script auto-detects ``x86_64-linux-gnu-qmake`` or ``qmake-qt5``. Override
with ``QMAKE_BIN`` if needed.

Linux — almost-static Qt (portable build)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Builds against a static Qt so the resulting binary has no runtime dependency on
the distro's Qt5 packages.  Only system libraries (``libxcb``, ``libGL``,
``libX11``, glibc) remain as dynamic dependencies.

Step 1 — build and install the static Qt (one-time, ~60–90 min):

.. code-block:: bash

   mkdir ~/workspace/qt-5.15.17-build-static
   cd    ~/workspace/qt-5.15.17-build-static
   ~/workspace/qt-everywhere-src-5.15.17/configure \
     -prefix /opt/qt-5.15.17-static \
     -release -static -opensource -confirm-license \
     -xcb -opengl desktop -no-fontconfig \
     -qt-zlib -qt-libpng -qt-libjpeg -qt-freetype -qt-pcre -qt-harfbuzz \
     -no-openssl -nomake examples -nomake tests \
     -skip qt3d -skip qtactiveqt -skip qtandroidextras \
     -skip qtcharts -skip qtdatavis3d -skip qtdeclarative \
     -skip qtdoc -skip qtgamepad -skip qtlocation -skip qtlottie \
     -skip qtmultimedia -skip qtquick3d -skip qtquickcontrols \
     -skip qtquickcontrols2 -skip qtscript -skip qtscxml \
     -skip qtsensors -skip qtserialbus -skip qtserialport \
     -skip qtspeech -skip qtvirtualkeyboard -skip qtwayland \
     -skip qtwebchannel -skip qtwebengine -skip qtwebglplugin \
     -skip qtwebsockets -skip qtwebview
   make -j$(nproc) && sudo make install

Required apt packages for the xcb platform plugin::

   sudo apt install libxcb-dev libxcb1-dev libxcb-shape0-dev libxcb-xfixes0-dev \
     libxcb-sync-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-icccm4-dev \
     libxcb-randr0-dev libxcb-xinerama0-dev libxcb-render0-dev \
     libxcb-render-util0-dev libxcb-util-dev libxcb-xkb-dev libxcb-cursor-dev \
     libxcb-glx0-dev libx11-dev libx11-xcb-dev libxi-dev libxrender-dev \
     libxkbcommon-dev libxkbcommon-x11-dev libgl1-mesa-dev libfontconfig1-dev

Step 2 — build Engauge::

   bash build_linux_almoststaticqt.sh

Binary: ``build-linux-almoststaticqt/bin/engauge``

Set ``STATIC_QT_PREFIX`` if Qt was installed to a different path.

Windows (MXE cross-compile)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

From repository root::

   ./build_windows_mxe.sh

Requires MXE with the Qt5 static x86_64 target. ``MXE_ROOT`` must be set to
your MXE installation directory. See ``build_windows_mxe.sh`` for all
overridable variables.

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
