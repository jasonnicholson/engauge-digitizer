Export Setup
============

The Export Setup dialog controls how digitized data is written to a file,
making it easy to import into tools such as Excel and Gnumeric.

Only curves are exported; measures are ignored by this dialog.

Curve Selection
---------------

Every curve is included in the export by default. To exclude a curve, select
its name in the list and click **Exclude**. Click **Include** to return a curve
to the export list.

Point Selection
---------------

Curves are exported as a set of points. The user may control which points are
exported:

- X values from all curves
- X values from just the first curve
- X values from the grid lines (with corresponding Y values calculated)
- Raw X and Y values (less useful for most applications)

Delimiters
----------

A delimiter separates each pair of fields in the export file. The delimiter
type may be selected so the file is easily read by another application. Common
delimiters include commas, spaces, and tabs.

Header Line
-----------

By default a simple header line is inserted at the top of the exported file,
containing column names. Spreadsheet programs such as Excel and Gnumeric can
read column names from this header. The header can be removed, or adjusted for
Gnuplot compatibility. For full Gnuplot compatibility, use spaces as delimiters.

Dialog
------

An example of the Export Setup dialog is shown below:

.. image:: _images/dlgexport1.png
   :alt: Export Setup dialog example
   :align: center
