Fixing Axis Points
==================

If you are seeing unexpected values for the coordinates produced by Engauge
Digitizer, then there probably is a problem with the axis points. Axis point
problems include:

- An axis point was placed at the wrong location on the graph
- The X or Y coordinate of an axis point was entered incorrectly
- In a polar plot, the origin has a nonzero radius (so the default value of zero
  in the :doc:`../dialogs/coordinates` does not apply)

The Axes Checker usually reveals problems with axis points — a shape that is not
a rectangle (in cartesian coordinates) or annular disk (in polar coordinates) is
usually a symptom.

.. image:: /_images/fixingaxispoints.png
   :alt: Slanted grid lines indicating axis point problems

This trick is also helpful if your axis points are fine, but the problem lies in
the original image.
