# Linux Runtime Notes

## Problem

When launching Engauge on Linux, startup can fail with a Qt platform plugin error similar to this:

qt.qpa.plugin: Could not find the Qt platform plugin "xcb" in ""

This application failed to start because no Qt platform plugin could be initialized.

## Root Cause

The shell environment may force Qt to use a custom Qt install under /opt that does not include the xcb platform plugin.

Common environment variables that cause this:

- LD_LIBRARY_PATH
- QT_PLUGIN_PATH
- QT_QPA_PLATFORM_PLUGIN_PATH

If these point to an incomplete Qt runtime, Engauge cannot initialize the xcb plugin.

## Confirm Current Environment

Run:

echo "$LD_LIBRARY_PATH"
echo "$QT_PLUGIN_PATH"
echo "$QT_QPA_PLATFORM_PLUGIN_PATH"

If these point to /opt/qt-5.15.17-linux paths, that is likely the source of the issue.

## Working Build And Run Path

Build Engauge against distro Qt (which includes libqxcb.so):

cd /home/jason/Desktop/engauge-digitizer
mkdir -p build-linux-systemqt
cd build-linux-systemqt
/usr/bin/x86_64-linux-gnu-qmake ../engauge.pro
make -j"$(nproc)"

Run with Qt override variables removed:

cd /home/jason/Desktop/engauge-digitizer/build-linux-systemqt/bin
env -u LD_LIBRARY_PATH -u QT_PLUGIN_PATH -u QT_QPA_PLATFORM_PLUGIN_PATH ./engauge

## Optional Convenience Alias

If you want a one-command launcher in your shell:

alias engauge-systemqt='env -u LD_LIBRARY_PATH -u QT_PLUGIN_PATH -u QT_QPA_PLATFORM_PLUGIN_PATH /home/jason/Desktop/engauge-digitizer/build-linux-systemqt/bin/engauge'

Then run:

engauge-systemqt

## Notes

- The existing binary under bin/engauge may still fail if your shell exports incompatible Qt paths.
- The system-Qt build under build-linux-systemqt/bin/engauge was validated to start without the xcb plugin error.