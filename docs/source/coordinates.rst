Coordinate System
=================

When a scale bar is used, there is no coordinate system to worry about.
When axes points are used, two coordinates are involved.

Engauge Digitizer initially assumes that the two coordinates are linear and
Cartesian (linear X and Y). This is the default since most graphs follow this
behavior.

The Coordinates dialog is used to select other coordinate systems.

Cartesian Coordinates
---------------------

Either Cartesian coordinate may be linear or logarithmic.

Engauge does not need to know the units of either Cartesian coordinate.

Polar Coordinates
-----------------

Only the radius coordinate may be logarithmic in a polar plot.

Engauge needs to know the units of the angle coordinate. By default the polar
angle units are degrees; they may also be changed to gradians or radians. The
angle coordinate must be linear and cannot be logarithmic.

Normally the radius at the origin of a polar plot is zero. However, a nonzero
value may be appropriate when the radial units are decibels or in similar cases.

Dialog
------

The coordinate system settings for a Cartesian graph with linear X values and
logarithmic Y values are shown below:

.. image:: _images/dlgcoordsys1.png
   :alt: Coordinates dialog showing linear X and logarithmic Y settings
   :align: center
