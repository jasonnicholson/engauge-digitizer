This file gives details for building Engauge from source code.

   *****************************************************************
   *                                                               *
   *  Build instructions are being actively revised. Use this file *
   *  for current, verified workflows only.                        *
   *                                                               *
   *****************************************************************

Windows Build Instructions:
---------------------------
Under Re-Construction.

The previous Windows build instructions (including legacy MSVC/MSI guidance)
were removed because they were stale relative to the current toolchain and
release workflow.

For now, use the current release artifacts and the repository release workflow
notes until this section is rebuilt.

Linux - Steps to build and run engauge executable:
--------------------------------------------------
These steps build and run, in Linux, the standard engauge executable.

1) Install Qt5 development tools and required build dependencies with your
   package manager.

   Common requirements:

     --Package(s)--       --Comment--
     qtbase5-dev          Qt base headers and libs
     qtbase5-dev-tools    qmake and base Qt tools
     qttools5-dev         Qt tools headers and libs
     qttools5-dev-tools   additional Qt tools
     libfftw3-dev         FFT support
     libjpeg-dev          JPEG support
     liblog4cpp-dev       logging (or use CONFIG+=log4cpp_null)

2) In mixed Qt4/Qt5 environments, ensure Qt5 is selected.

   Example:

     > export QT_SELECT=qt5

3) Generate makefiles and build from the repository root.

     > qmake engauge.pro
     > make -j"$(nproc)"

4) Run engauge.

     > ./bin/engauge

Known Linux Runtime Issue:
--------------------------
Error message:

  'Could not find the Qt platform plugin "xcb"'

Description:

  Environment variables can force Engauge to load an incompatible or incomplete
  Qt runtime/plugin path.

Solution:

  Unset Qt override variables before launch:

    > env -u LD_LIBRARY_PATH -u QT_PLUGIN_PATH -u QT_QPA_PLATFORM_PLUGIN_PATH ./bin/engauge

  If needed, rebuild with distro Qt and run from that build output.

Static Build Notes (Linux and Windows):
---------------------------------------
Windows:

- Cross-builds can be produced with MXE static targets.
- See RELEASE_WORKFLOW.md for the current release packaging flow.

Linux:

- Fully static Linux builds are under active reconstruction.
- With standard distro Qt (shared libraries), outputs remain dynamically linked.
- For now, use dynamic Linux builds or portable packaging (AppImage/Flatpak).
- See STATIC_BUILD_LINUX.md for the active static-build plan and progress log.

Linux - Steps to build engauge test executables and perform tests:
------------------------------------------------------------------
1) Verify the standard executable builds and runs.

2) Run command-line tests.

     > cd src
     > ./build_and_run_all_cli_tests

3) Run GUI tests.

     > cd src
     > ./build_and_run_all_gui_tests

Steps to generate doxygen documentation:
----------------------------------------
1) Run doxygen.

     > cd src
     > doxygen

2) Open doc/doxygen/html/index.html in a browser.
