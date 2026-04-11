Qt6 and CMake Migration (2026)
==============================

Current status (2026-04-10)
---------------------------

All phases have been implemented on the ``Qt6`` branch.

Build system
^^^^^^^^^^^^

- **CMakeLists.txt** created; targets Qt6 exclusively (``find_package(Qt6 REQUIRED)``).
- C++ standard raised to C++17.
- All build scripts (``build_linux_systemqt.sh``, ``build_linux_almoststaticqt.sh``,
  ``build_windows_mxe.sh``) converted to CMake/Qt6; no qmake or Qt5 references remain.
- Optional PDF support now requires ``poppler-qt6`` (configured via CMake option
  ``-DENGAUGE_PDF=ON``).

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

Remaining work
--------------

- **Validate CMake build** on a system with Qt6 installed (first ``cmake -B build`` run).
- **MXE Qt6 toolchain**: MXE must be built with Qt6 support before the Windows lane can
  be tested; Qt6 in MXE is experimental as of 2026.
- **poppler-qt6**: validate PDF feature on a machine with ``libpoppler-qt6-dev`` installed
  (``cmake -DENGAUGE_PDF=ON``).
- **Run test suites** after first successful Qt6 CMake build.
- **Update release notes / CHANGELOG** once first Qt6 release is verified.
