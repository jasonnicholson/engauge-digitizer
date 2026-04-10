Windows Build Status
====================

Windows build instructions are currently under reconstruction in ``BUILD``.

Current supported path:

- Cross-build from Linux using MXE and ``build_windows_mxe.sh``.

Current result:

- ``build-win-mxe/bin/engauge.exe`` produced successfully in this fork.

Notes:

- Legacy Windows/MSVC/MSI instructions were removed from ``BUILD`` because they
  were stale relative to the current workflow.
- If you need installer workflows, treat those as separate downstream packaging
  tasks.
