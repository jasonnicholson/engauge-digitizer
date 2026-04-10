Command Line Options
====================

Engauge Digitizer accepts many command line options, and one environment variable,
for more flexibility and power.

Startup
-------

``-import FILE``
    Automatically import the specified image file at startup. Image files may
    also be imported manually using the menu.

``-open FILE``
    Automatically open the specified Engauge Digitizer document file at startup.
    Document files may also be opened manually using the menu.

``-help``
    Display a list of command line options with some brief comments, and then exit.

``-manual DIRECTORY``
    Look for the user manual in the specified directory. If Engauge Digitizer is
    run in a directory other than the installation directory, then the user manual
    directory must be specified using either this option or the
    ``ENGAUGE_USERMANUAL`` environment variable.

``-axes XMIN XMAX YMIN YMAX``
    Scan the imported file at startup, and locate the X and Y axes. Then digitize
    axis points assuming the X axis ranges from *XMIN* to *XMAX*, and the Y axis
    ranges from *YMIN* to *YMAX*. The X axis is assumed to be near the bottom of
    the image, and the Y axis is assumed to be on the left side. No rotation is
    attempted, so the digitized points may require adjustment. Useful when using
    scripts to digitize many images with known axis ranges.

``-lazysegments``
    Postpone scanning for segments that is normally performed during startup,
    until either the Segments dialog is used or the Segment Fill button is selected.

Shutdown
--------

``-export FILE``
    Automatically export the active document at shutdown. Documents may also be
    exported manually using the menu.

Settings
--------

``-reset``
    Reset all settings to the factory defaults. A fast way to restore a useful
    configuration when settings have become problematic.

``-text``
    Load settings from a text file at startup and save settings to the same text
    file when done, rather than using the Windows registry. On Linux and Unix,
    settings are always stored in a text file (e.g. ``$HOME/.qt/engaugerc``), so
    this option has no effect on those platforms.

Internationalization
--------------------

``-onlybmp``
    Import all images as bitmap (BMP) files. This is a fix for Chinese Windows.

Debugging
---------

``-pixels``
    Show cursor location in pixel coordinates rather than graph coordinates.

``-ctor``
    Trace constructor calls.

``-dtor``
    Trace destructor calls.

``-curvecmb``
    Trace curve combobox operations.

``-measurecmb``
    Trace measure combobox operations.

``-refresh``
    Trace screen refreshes.

``-scanning``
    Trace image scanning.

Environment Variables
---------------------

``ENGAUGE_BROWSER``
    Shell command that runs a JavaScript-capable browser, used to start the
    date/time converter from within Engauge. Not used on Windows. Examples:
    ``firefox``, ``konqueror``.

``ENGAUGE_USERMANUAL``
    Directory containing the user manual. Used when running Engauge Digitizer
    from a directory other than the installation directory.
