Command Line Options
====================

Engauge Digitizer accepts command line options and one environment variable
for more flexibility and power.

::

   engauge [OPTIONS] [FILE ...]

Any positional arguments are treated as document or image files to open at
startup.

General
-------

``-help``
    Display a list of command line options and exit.

``-reset``
    Reset all settings to the factory defaults, including window positions.
    Useful when windows start up offscreen or settings have become problematic.

``-style <STYLE>``
    Set the window style. Qt processes this flag automatically.

``-styles``
    List the available window styles that may be passed to ``-style``, then
    exit.

Batch Processing
----------------

``-exportonly``
    Export each loaded startup file (which must have all axis points defined),
    then exit. Requires one or more load files.

``-extractimageonly <EXTENSION>``
    Extract the embedded image in each loaded startup file to a file with the
    given extension (e.g. ``png``), then exit. Requires one or more load files.

``-upgrade``
    Upgrade each loaded startup file to the most recent document format, then
    exit.

Debugging and Testing
---------------------

``-debug``
    Enable extra debug information.

``-errorreport <FILE>``
    Load the specified error report file for replay. Used for debugging and
    regression testing.

``-filecmdscript <FILE>``
    Execute the specified file command script. Used for debugging and testing.

``-gnuplot``
    Output diagnostic gnuplot input files.

``-regression``
    Execute the loaded error report file or file command script automatically.
    Used for regression testing.

``-dropregression``
    Treat files opened at startup as drag-and-drop test inputs. Used for
    regression testing.

Environment Variables
---------------------

``TZ``
    Set the timezone to add or subtract hours in time values. Values are listed
    as "TZ Database Names" on Wikipedia.
