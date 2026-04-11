Qt6 and CMake Migration (2026)
==============================

Current status (2026-04-11)
---------------------------

Qt6/CMake migration is now merged to ``main`` and tagged as
``v14.0.0-beta.1``.

Build system
^^^^^^^^^^^^

- **CMakeLists.txt** created; targets Qt6 exclusively (``find_package(Qt6 REQUIRED)``).
- C++ standard raised to C++17.
- All build scripts (``build_linux_systemqt.sh``, ``build_linux_almoststaticqt.sh``,
  ``build_windows_mxe.sh``) converted to CMake/Qt6; no qmake or Qt5 references remain.
- Optional PDF support now requires ``poppler-qt6`` (configured via CMake option
  ``-DENGAUGE_PDF=ON``), and optional JPEG2000 support uses ``libopenjp2``
  (``-DENGAUGE_JPEG2000=ON``).

Source compatibility
^^^^^^^^^^^^^^^^^^^^

All Qt6 migration blockers resolved:

- **QRegExp → QRegularExpression**: replaced in all files
  (``ChecklistGuideBrowser.cpp``, ``DlgSettingsExportFormat.cpp``,
  ``FormatDegreesMinutesSecondsBase.cpp``, ``FormatDateTime.cpp``).
  Unused ``#include <QRegExp>`` removed from
  ``FormatDegreesMinutesSecondsPolarTheta.cpp`` and
  ``FormatDegreesMinutesSecondsNonPolarTheta.cpp``.
- **QString::SkipEmptyParts → Qt::SkipEmptyParts**: fixed in
  ``FormatDegreesMinutesSecondsBase.cpp``.
- **QSignalMapper → lambda connections**: all zoom-factor action connections in
  ``CreateActions.cpp`` replaced with direct ``connect(..., &QAction::triggered, ...)``
  lambda calls. ``QSignalMapper`` member and forward declaration removed from
  ``MainWindow.h``.

Documentation
^^^^^^^^^^^^^

- ``build-and-release.rst``, ``static-linux.rst``, ``linux-runtime.rst``,
  and ``developer.rst`` updated to reference Qt6 and CMake only.

Validation status
-----------------

- Linux system-Qt build succeeds with ``ENGAUGE_JPEG2000=ON`` and
  ``ENGAUGE_PDF=ON``.
- Windows MXE cross-build succeeds with ``openjpeg`` and ``poppler-qt6`` in
  the target sysroot.
- ``build_windows_mxe.sh`` now checks for required MXE dependencies up front
  (``fftw``, ``openjpeg``, ``poppler-qt6``).
