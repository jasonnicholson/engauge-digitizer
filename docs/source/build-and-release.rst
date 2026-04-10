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

   bash build_linux_systemqt.sh

Binary: ``build-linux-systemqt/bin/engauge``

The script auto-detects ``x86_64-linux-gnu-qmake`` or ``qmake-qt5``. Override
with ``QMAKE_BIN`` if needed.

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
