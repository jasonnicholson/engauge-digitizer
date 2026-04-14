Point Match Dialog
==================

The Point Match dialog controls how Point Match is applied to point graphs. You
can control:

- Maximum point size
- Accepted point color
- Rejected point color
- Candidate color

Maximum Point Size
------------------

The maximum point size prevents sample points from being too large. When a
sample point lies on top of a grid line or axis line, Engauge cannot distinguish
the point from the grid or axis line. The maximum point size limits the width
and height of the sample point so that only a few pixels of the grid or axis
line are attached.

.. tip::
   For the best point matching, make the maximum point size as small as
   possible — just large enough to include the entire sample point within the
   point match circle.

Colors
------

Colors distinguish accepted points, rejected points, and the candidate point
from each other. The Preview window reflects the current settings.

.. image:: dlgpointmatch1.png
   :alt: Point Match dialog example
   :align: center
