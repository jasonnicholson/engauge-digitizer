Linux Static and Near-Static Strategy
=====================================

Near-static portability is the current primary target for Linux distribution.

Why Fully Static Is Hard
------------------------

- Standard distro Qt packages are shared-library builds.
- A true static link requires a custom static Qt build and static variants of
  all key dependencies.
- ``glibc`` static linking has portability caveats (NSS, resolver, locale,
  plugin behavior) that make the resulting binary fragile across Linux distros.

Decision
--------

- Near-static binary plus documented runtime/system assumptions is the
  **primary direction**.
- AppImage/Flatpak is the preferred portable Linux deliverable if near-static
  proves insufficient.
- Fully static Linux binary: not yet achieved; effort is tracked below.

Current Status
--------------

- Windows static build via MXE with Qt6: **in progress** (Qt6/CMake lane established).
- Linux dynamic build against distro Qt6: **working**.
- Linux almost-static bundle using custom Qt6 + bundled libs/plugins: **working**.
- Linux fully static build: **not yet achieved**.

Almost-Static Build (Current Working Path)
------------------------------------------

Use a custom Qt6 install (for example ``/opt/qt6-linux``), build Engauge
with CMake and that Qt6, then package Qt ``.so`` libraries and plugins alongside
the binary.

From repository root::

  sudo apt-get install patchelf
  bash build_linux_almoststaticqt.sh

Artifacts:

- ``build-linux-almoststaticqt/engauge``
- ``dist/almoststatic-linux-x86_64`` (self-contained bundle)
- ``dist/engauge-linux-almoststatic-x86_64.tar.gz``

This produces a portable Linux build that does not require distro Qt packages.

Building Against Fully Static Qt6 (Experimental Guide)
-------------------------------------------------------

Phase 1 — Baseline::

   cmake -B build-test -DCMAKE_BUILD_TYPE=Release .
   cmake --build build-test --parallel
   file ./build-test/engauge
   ldd ./build-test/engauge

Record the binary type and key dynamic deps before attempting static.

Phase 2 — Static Qt6 configure outline:

.. code-block:: bash

   # Adjust to your Qt source and prefix
   cmake -B qt6-build -S qt6-src \
     -DCMAKE_BUILD_TYPE=Release \
     -DQT_BUILD_SHARED_LIBS=OFF \
     -DCMAKE_INSTALL_PREFIX=<qt-static-prefix> \
     -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF
   cmake --build qt6-build --parallel
   cmake --install qt6-build

Phase 3 — Build Engauge against static Qt6:

.. code-block:: bash

   cmake -B build-static \
     -DCMAKE_BUILD_TYPE=Release \
     -DCMAKE_PREFIX_PATH=<qt-static-prefix> \
     -DENGAUGE_LOG4CPP_NULL=ON .
   cmake --build build-static --parallel
   file ./build-static/engauge
   ldd ./build-static/engauge || true

Phase 4 — Runtime validation::

   ./build-static/engauge
   # headless check:
   QT_QPA_PLATFORM=offscreen ./build-static/engauge

Notes
-----

- Document every command variant tried and whether it succeeded, so the process
  is reproducible.
- The ``xcb`` static platform plugin must be included in the static Qt6 build or
  the binary will fail to start on graphical desktops.
