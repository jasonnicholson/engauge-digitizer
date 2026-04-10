Qt6 Readiness Audit (2026-04-10)
================================

Current baseline
----------------

- Build system is qmake-based via engauge.pro.
- Linux and MXE build scripts are explicitly Qt5-oriented (qmake-qt5, libQt5* checks).
- Current portable Linux bundle uses /opt/qt-5.15.17-linux.
- C++ standard in engauge.pro is c++11.

Qt6 migration blockers found in source
--------------------------------------

1. QRegExp usage (replace with QRegularExpression)

- src/Checklist/ChecklistGuideBrowser.cpp:86
- src/Checklist/ChecklistGuideBrowser.cpp:107
- src/Checklist/ChecklistGuideBrowser.cpp:108
- src/Dlg/DlgSettingsExportFormat.cpp:511
- src/Format/FormatDegreesMinutesSecondsPolarTheta.cpp:12
- src/Format/FormatDegreesMinutesSecondsNonPolarTheta.cpp:12
- src/Format/FormatDateTime.cpp:34
- src/Format/FormatDateTime.cpp:110
- src/Format/FormatDegreesMinutesSecondsBase.cpp:101
- src/Format/FormatDegreesMinutesSecondsBase.cpp:102
- src/Format/FormatDegreesMinutesSecondsBase.cpp:191
- src/Format/FormatDegreesMinutesSecondsBase.cpp:202
- src/Format/FormatDegreesMinutesSecondsBase.cpp:216

2. QString::SkipEmptyParts API (Qt6 moved enum usage)

- src/Format/FormatDegreesMinutesSecondsBase.cpp:102

3. QSignalMapper still used (works but modern replacement recommended with lambdas)

- src/main/MainWindow.h:82
- src/main/MainWindow.h:598
- src/main/MainWindow.cpp:109
- src/Create/CreateActions.cpp:20
- src/Create/CreateActions.cpp:611

Out-of-date / at-risk dependencies
----------------------------------

High priority
^^^^^^^^^^^^^

- Qt5 toolchain assumptions throughout build and docs:
  - build_linux_systemqt.sh uses qmake-qt5 fallback and Qt5 install hints.
  - build_windows_mxe.sh expects <target>-qmake-qt5.
  - build_linux_almoststaticqt.sh validates libQt5Core.so.
  - docs/source/build-and-release.rst references Qt5 packages.
- poppler-qt5 integration in engauge.pro is Qt5-specific and likely unavailable on many modern distros that prioritize Qt6.
- c++11 in engauge.pro is behind modern Qt6 expectations (Qt6 generally assumes newer compilers and C++17 usage in practice).

Medium priority
^^^^^^^^^^^^^^^

- qmake-first build architecture. Qt6 supports qmake in some distributions, but ecosystem direction is CMake; long-term maintenance risk is increasing.
- Comments in engauge.pro reference very old OpenJPEG advisory context and historical package assumptions that should be refreshed.

Low priority
^^^^^^^^^^^^

- pnpm/tooling side looks current:
  - git-conventional-commits = 2.8.0 (latest currently).
  - pnpm lock is consistent.
- docs Python stack is healthy:
  - Sphinx 9.1.0, furo 2025.12.19, myst-parser 5.0.0.
  - uv lock check passes.

Tomorrow start plan
-------------------

Phase 1: Prepare dual build lanes (Qt5 + Qt6)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Add a Qt selector in build scripts (QT_MAJOR=5|6) instead of hardcoding qt5 names.
2. Keep current Qt5 lane working while adding a Qt6 lane in parallel.
3. Add a matrix section in docs for supported combinations.

Phase 2: Source compatibility pass
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Replace QRegExp with QRegularExpression in all listed files.
2. Update split behavior for SkipEmptyParts with Qt6-compatible enum form.
3. Optional cleanup: replace QSignalMapper with direct lambda connections.

Phase 3: Dependency updates
^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Validate/populate Qt6 equivalents for optional PDF path (poppler-qt6 where available), and keep PDF feature optional.
2. Raise language standard after compatibility pass (at least c++17 once Qt6 lane is validated).
3. Re-run Linux and MXE builds, then test CLI and GUI suites.

Phase 4: Release and docs alignment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Update build-and-release.rst and static-linux.rst to include Qt6 paths and package names.
2. Keep legacy Qt5 instructions as fallback until Qt6 lane is stable across targets.
