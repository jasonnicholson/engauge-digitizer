Developer Guide
===============

This page provides an orientation to the Engauge Digitizer C++ source code for
contributors and maintainers.

Source Layout
-------------

All application code lives under ``src/``. Each subdirectory is a logical
module with a clear single responsibility:

**Core logic**

- ``Cmd/`` — Undo/redo command objects (QUndoCommand subclasses)
- ``Curve/`` — Curve data model and management
- ``Document/`` — The in-memory document (loaded image + digitized data)
- ``CoordSystem/`` — Coordinate system definitions and transformations
- ``Transformation/`` — Affine and nonlinear coordinate transformations
- ``Export/`` — CSV/TSV export formatting and logic

**Digitizing state machine**

- ``DigitizeState/`` — Application modes (axis points, curve points, point
  match, segment fill, …) implemented as a state machine
- ``Create/`` — Factory methods that wire up menus, toolbars, and the help
  window on startup
- ``Checklist/`` — The step-by-step checklist wizard

**Dialogs and UI**

- ``Dlg/`` — All QDialog subclasses (settings, export, about, …)
- ``Settings/`` — Persistent QSettings wrapper objects
- ``StatusBar/`` — Status bar message management
- ``View/`` — Custom QGraphicsView and scene overlays
- ``Window/`` — Secondary window helpers

**Import / image handling**

- ``Import/`` — Image import pipeline (JPEG, PNG, JPEG2000, …)
- ``NonPdf/`` — Raster-specific import cropping paths
- ``Jpeg2000/`` — Optional JPEG 2000 support via OpenJPEG
- ``Filter/`` / ``Color/`` — Image discretization and color filters
- ``Segment/`` — Segment-fill path tracing

**Graphics and interaction**

- ``Graphics/`` — Custom QGraphicsItem types for axis/curve/guide points
- ``Guideline/`` / ``GuidelineView/`` — Guideline overlays
- ``Cursor/`` — Custom cursor management
- ``Grid/`` — Grid line rendering

**Math / fitting**

- ``Matrix/`` — Small matrix operations for coordinate math
- ``Fitting/`` — Curve fitting helpers
- ``Spline/`` — Cubic spline interpolation
- ``Correlation/`` — Point-match correlation

**Utilities**

- ``Logger/`` / ``log4cpp_null/`` — Logging; the null backend removes the
  log4cpp dependency for release builds
- ``util/`` — Miscellaneous helpers
- ``Callback/`` — Functor callbacks used across the state machine

**Integration and tests**

- ``Test/`` — Unit test support classes
- ``main/`` — ``MainWindow`` (top-level QMainWindow) and ``main.cpp``

Build System
------------

The project uses **CMake** (>= 3.16) targeting **Qt6** only. The two supported
build configurations are:

.. code-block:: bash

  # Linux — system Qt6 + Conan-managed third-party deps
  pipx install conan   # one-time
  ./scripts/build_linux_systemqt.sh

  # Windows — MXE Qt6 + Conan-managed third-party deps
  pipx install conan   # one-time
  export MXE_ROOT=/path/to/your/mxe   # e.g. $HOME/workspace/mxe-qt6
  ./scripts/build_windows_conan.sh

The default scripts enable optional JPEG2000 support.
Dependencies such as FFTW3 and OpenJPEG are installed by Conan.

See the :doc:`build-and-release` page for full instructions.

API Documentation
-----------------

The source has sparse Doxygen-style comments (only in a handful of header
files). Full auto-generated API docs are **not currently published**.

If you want to browse the API locally, install `Doxygen <https://www.doxygen.nl>`_
and run it from ``src/``::

   cd src
   doxygen -g Doxyfile           # generate a default config
   doxygen Doxyfile              # builds HTML in doc/doxygen/html/

A future improvement would be to add `breathe
<https://breathe.readthedocs.io/>`_ integration to publish API docs here
automatically.

Sample Images (``samples/``)
-----------------------------

The ``samples/`` directory contains demonstration images that can be loaded
directly into Engauge for experimenting. They were produced by the gnuplot
scripts and helper programs in ``dev/`` and are tracked in Git LFS.

Adding a new sample image::

   # add the file — LFS handles it automatically via .gitattributes
   git add samples/myimage.png
   git commit -m "samples: add myimage"

Contributing
------------

Please open a `GitHub issue
<https://github.com/jasonnicholson/engauge-digitizer/issues>`_ before starting
large changes. For small bug fixes, a pull request is welcome directly.
