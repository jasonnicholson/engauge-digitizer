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

- Windows static build via MXE: **working**.
- Linux dynamic build against distro Qt: **working**.
- Linux almost-static bundle using custom Qt + bundled libs/plugins: **working**.
- Linux fully static build: **not yet achieved**.

Almost-Static Build (Current Working Path)
------------------------------------------

Use a custom Qt install (for example ``/opt/qt-5.15.17-linux``), build Engauge
with that Qt, then package Qt ``.so`` libraries and plugins alongside the
binary.

From repository root::

  sudo apt-get install patchelf
  bash build_linux_almoststaticqt.sh

Artifacts:

- ``build-linux-almoststaticqt/bin/engauge``
- ``dist/almoststatic-linux-x86_64`` (self-contained bundle)
- ``dist/engauge-linux-almoststatic-x86_64.tar.gz``

This produces a portable Linux build that does not require distro Qt packages.

Building Against Fully Static Qt (Experimental Guide)
-----------------------------------------------------

Phase 1 — Baseline::

   qmake engauge.pro
   make -j$(nproc)
   file ./bin/engauge
   ldd ./bin/engauge

Record the binary type and key dynamic deps before attempting static.

Phase 2 — Static Qt configure outline:

.. code-block:: bash

   # Adjust to your Qt source and prefix
   ./configure \
     -static -release -opensource -confirm-license \
     -prefix <qt-static-prefix> \
     -qt-zlib -qt-libpng -qt-libjpeg -qt-freetype -qt-pcre -qt-harfbuzz \
     -nomake examples -nomake tests
   make -j$(nproc) && make install

Phase 3 — Build Engauge against static Qt:

.. code-block:: bash

   export PATH="<qt-static-prefix>/bin:$PATH"
   qmake engauge.pro CONFIG+=log4cpp_null
   make -j$(nproc)
   file ./bin/engauge
   ldd ./bin/engauge || true

Phase 4 — Runtime validation::

   ./bin/engauge
   # headless check:
   QT_QPA_PLATFORM=offscreen ./bin/engauge

Notes
-----

- Document every command variant tried and whether it succeeded, so the process
  is reproducible.
- The ``xcb`` static platform plugin must be included in the static Qt build or
  the binary will fail to start on graphical desktops.
