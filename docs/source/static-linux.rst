Linux Static Build Strategy
===========================

The Linux build links dynamically against the distribution's Qt6 packages.
This page documents notes on fully static or near-static approaches that
have been explored but are **not actively maintained**.

Why Fully Static Is Hard
------------------------

- Standard distro Qt packages are shared-library builds.
- A true static link requires a custom static Qt build and static variants of
  all key dependencies.
- ``glibc`` static linking has portability caveats (NSS, resolver, locale,
  plugin behavior) that make the resulting binary fragile across Linux distros.

Decision
--------

- The primary Linux build uses system Qt6 (``build_linux_systemqt.sh``).
- AppImage/Flatpak is the preferred portable Linux deliverable if cross-distro
  portability is needed in the future.

Current Status
--------------

- Windows static build via MXE with Qt6: **working**.
- Linux dynamic build against distro Qt6: **working** (primary).
- Linux fully static build: **not achieved**; not actively pursued.

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
