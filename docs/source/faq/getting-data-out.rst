Getting Data Out
================

Reading Coordinates in the Status Bar
--------------------------------------

Once the three axes points are defined, the coordinates under the cursor are
always shown in the status bar at the bottom of the application. Move the
cursor over a point on the curve to read its coordinates.

The status bar coordinates must be recorded manually or typed into other
applications. This approach does not work for maps using scale bars.

Exporting Curves to a File
--------------------------

Use **File > Export** to save curves as a tabular text file, which can be
imported directly into tools like Excel and Gnumeric.

The format of the export file (delimiters, headers, point selection) is
controlled by **Settings > Export Format...** — see :doc:`../export`.

This approach does not work for maps using scale bars.

Copying from the Geometry Window
--------------------------------

All information in the :doc:`../dialogs/geometry-window` can be copied via the
system clipboard. Selected lines are automatically copied to the clipboard for
pasting into other applications. Open it from **View > Geometry Window**.

This approach works for both curves and maps using scale bars.
