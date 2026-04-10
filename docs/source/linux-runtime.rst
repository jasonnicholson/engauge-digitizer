Linux Runtime Troubleshooting
=============================

Known issue: xcb plugin load failure
------------------------------------

Symptom:

- ``Could not find the Qt platform plugin \"xcb\"``

Cause:

- Qt runtime/plugin environment overrides can point to an incompatible or
  incomplete Qt installation.

Fix:

- Launch with overrides removed:

.. code-block:: bash

   env -u LD_LIBRARY_PATH -u QT_PLUGIN_PATH -u QT_QPA_PLATFORM_PLUGIN_PATH ./bin/engauge

If your regular build still has runtime issues, rebuild against distro Qt and
run from that output.

Reference:

- See ``LINUX_RUNTIME_NOTES.md`` in repository root.
