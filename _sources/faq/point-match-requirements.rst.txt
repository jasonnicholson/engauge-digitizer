Point Match Requirements
========================

Separation of Points
--------------------

Engauge is limited in terms of types of point graphs that can be automatically
digitized in :doc:`point graph mode <../tutorials/auto-point-graph>`.

The point graph on the left below may be automatically digitized by Engauge,
because each point is easily distinguished from its closest neighbors. Engauge
will recognize the 22 points.

The point graph on the right below cannot be automatically digitized by Engauge,
because every point is connected to its neighbors. Even worse, some points are
overlapping. In this case, Engauge will not be able to distinguish each curve
point from its neighbors, and from the curve line.

.. image:: /_images/pointmatchrequirements.png
   :alt: Good graph points are separated

Your point graph should look more like the left figure if you wish to use point
graph mode.

Image Size
----------

Point Matching involves a lot of mathematical calculations, and a lot of
computer memory, especially for larger images.

Engauge can easily handle a 2000×2000 pixel image, on a 512 megabyte Linux
system. However, larger images and reduced memory may cause problems.
