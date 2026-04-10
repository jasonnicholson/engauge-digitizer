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

Migration Plan: Qt6 and CMake (2026)
-------------------------------------

Phase 1: CMake and Qt6 Build System Migration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Remove all Qt5 and qmake-specific logic from build scripts and documentation.
2. Create a new CMake-based build system targeting Qt6 only.
3. Update all build scripts (Linux, Windows, MXE, etc.) to use CMake and Qt6 tools exclusively.
4. Update documentation to reference only Qt6 and CMake build instructions.

Phase 2: Source Compatibility and Modernization
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Replace all QRegExp usage with QRegularExpression in listed files.
2. Update QString::SkipEmptyParts usage to Qt6-compatible enum form.
3. Replace QSignalMapper with direct lambda connections where appropriate.
4. Raise C++ standard to at least C++17 in CMake configuration.

Phase 3: Dependency and Feature Updates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Integrate poppler-qt6 for PDF support (optional, Qt6 only).
2. Refresh all third-party dependency documentation and remove legacy advisories.
3. Validate builds and run CLI/GUI test suites on all supported platforms.

Phase 4: Documentation and Release Alignment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Update all documentation (build-and-release.rst, static-linux.rst, etc.) for Qt6 and CMake only.
2. Remove all Qt5 and qmake references from docs.
3. Prepare release notes and migration guide for users upgrading from Qt5/qmake to Qt6/CMake.
