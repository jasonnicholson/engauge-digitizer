This file gives details for building Engauge from source code.

Full build and release documentation:
  https://jasonnicholson.github.io/engauge-digitizer/build-and-release.html

Windows Build Instructions:
---------------------------

Cross-build using MXE from repository root:

  > ./build_windows_mxe.sh

Output: build-win-mxe/bin/engauge.exe

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

     > mkdir -p build-linux-systemqt
     > cd build-linux-systemqt
     > /usr/bin/x86_64-linux-gnu-qmake ../engauge.pro
     > make -j"$(nproc)"

4) Run engauge.

     > ./bin/engauge

Known Linux Runtime Issue:
--------------------------
Error message:

  'Could not find the Qt platform plugin "xcb"'

Solution:

  Unset Qt override variables before launch:

    > env -u LD_LIBRARY_PATH -u QT_PLUGIN_PATH -u QT_QPA_PLATFORM_PLUGIN_PATH ./bin/engauge

  See: https://jasonnicholson.github.io/engauge-digitizer/linux-runtime.html

Linux - Steps to build engauge test executables and perform tests:
------------------------------------------------------------------
1) Verify the standard executable builds and runs.

2) Run command-line tests.

     > cd src
     > ./build_and_run_all_cli_tests

3) Run GUI tests.

     > cd src
     > ./build_and_run_all_gui_tests

