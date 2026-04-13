Coordinate System
=================

Engauge Digitizer initially assumes that the two coordinates are linear and
Cartesian (linear X and Y). This is the default since most graphs follow this
behavior.

The Coordinates dialog is used to select other coordinate systems.

Cartesian Coordinates
---------------------

Either Cartesian coordinate may be linear or logarithmic.

The X coordinate may also be interpreted as:

- A plain number (the default)
- Degrees–Minutes–Seconds (DMS)
- Degrees–Minutes–Seconds with N/S/E/W suffix
- Date/Time (see below)

Engauge does not need to know the units of either Cartesian coordinate when
they are plain numbers.

Polar Coordinates
-----------------

Only the radius coordinate may be logarithmic in a polar plot.

Engauge needs to know the units of the angle coordinate. The available polar
angle units are:

- Degrees
- Degrees–Minutes
- Degrees–Minutes–Seconds
- Degrees–Minutes–Seconds with N/S/E/W suffix
- Gradians
- Radians
- Turns

By default the polar angle units are degrees. The angle coordinate must be
linear and cannot be logarithmic.

Normally the radius at the origin of a polar plot is zero. However, a nonzero
value may be appropriate when the radial units are decibels or in similar cases.

Date/Time Coordinates
---------------------

When one axis represents dates or times, select the **Date/Time** unit for that
coordinate. Separate combo boxes let you choose the date format and time format.
Set the ``TZ`` environment variable to adjust for timezone offsets (see
:doc:`../cli`).

Dialog
------

The coordinate system settings for a Cartesian graph with linear X values and
logarithmic Y values are shown below:

.. image:: ../_images/dlgcoordsys1.png
   :alt: Coordinates dialog showing linear X and logarithmic Y settings
   :align: center
