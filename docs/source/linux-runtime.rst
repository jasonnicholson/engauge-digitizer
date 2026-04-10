Linux Runtime Troubleshooting
=============================

xcb Plugin Failure
------------------

Symptom::

   qt.qpa.plugin: Could not find the Qt platform plugin "xcb" in ""
   This application failed to start because no Qt platform plugin could be initialized.

Cause
^^^^^

Environment variables can direct Qt to a custom or incomplete Qt installation
that does not include the ``xcb`` platform plugin:

- ``LD_LIBRARY_PATH``
- ``QT_PLUGIN_PATH``
- ``QT_QPA_PLATFORM_PLUGIN_PATH``

If these point to paths under ``/opt`` or a custom Qt build, the system xcb
plugin is bypassed.

Diagnose
^^^^^^^^

.. code-block:: bash

   echo "$LD_LIBRARY_PATH"
   echo "$QT_PLUGIN_PATH"
   echo "$QT_QPA_PLATFORM_PLUGIN_PATH"

If these point to ``/opt/qt-*`` paths, that is likely the cause.

Fix: Launch with overrides cleared
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   env -u LD_LIBRARY_PATH -u QT_PLUGIN_PATH -u QT_QPA_PLATFORM_PLUGIN_PATH \
     ./build-linux-systemqt/engauge

Optional shell alias for convenience:

.. code-block:: bash

   alias engauge='env -u LD_LIBRARY_PATH -u QT_PLUGIN_PATH -u QT_QPA_PLATFORM_PLUGIN_PATH \
     /path/to/engauge-digitizer/build-linux-systemqt/engauge'

Fix: Rebuild against distro Qt6
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the binary was not built against distro Qt6::

   cmake -B build-linux-systemqt -DCMAKE_BUILD_TYPE=Release .
   cmake --build build-linux-systemqt --parallel

Then run::

   env -u LD_LIBRARY_PATH -u QT_PLUGIN_PATH -u QT_QPA_PLATFORM_PLUGIN_PATH \
     ./build-linux-systemqt/bin/engauge
