Export Format
=============

The Export Format dialog (**Settings > Export Format...**) controls how
digitized data is written to a file,
making it easy to import into tools such as Excel, LibreOffice Calc, and
Gnuplot.

Only curves are exported; measures are ignored by this dialog.

Curve Selection
---------------

Every curve is included in the export by default. To exclude a curve, select
its name in the **Included** list and click **Exclude**. Click **Include** to
return a curve to the export list.

Functions Tab
-------------

The Functions tab controls how functional (single-valued) curves are exported.

**Point selection** — choose which X values appear in the export:

- Interpolate Y values at X values from **all** curves
- Interpolate Y values at X values from the **first** curve
- Interpolate Y values at **evenly spaced** X values (specify the interval and
  units)
- Interpolate Y values at X values on **grid lines**
- **Raw** X and Y values as digitized

An **Extrapolate outside endpoints** checkbox extends interpolation beyond the
first and last digitized points of each curve.

**Layout** — controls how columns are arranged:

- All curves on each line (one X column, then one Y column per curve)
- One curve on each line (each row has one X–Y pair for a single curve)

Relations Tab
-------------

The Relations tab controls how relational (multi-valued) curves are exported.

**Point selection:**

- Evenly spaced (specify interval)
- Raw values as digitized

Delimiters
----------

A delimiter separates each pair of fields in the export file. Available
delimiters are commas, spaces, tabs, and semicolons.

An **Override CSV/TSV** checkbox lets the delimiter adapt automatically when the
file extension is ``.csv`` or ``.tsv``.

Header Line
-----------

A header line may be inserted at the top of the exported file:

- **None** — no header
- **Simple** — column names (readable by Excel, LibreOffice, etc.)
- **Gnuplot** — column names prefixed with ``#`` for Gnuplot compatibility

An **X Label** field lets you customise the name of the X column in the header.

Dialog
------

An example of the Export Format dialog is shown below:

.. image:: dlgexport1.png
   :alt: Export Format dialog example
   :align: center
