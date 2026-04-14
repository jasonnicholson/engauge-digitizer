Segment Fill Dialog
===================

The Segment Fill dialog (**Settings > Segment Fill...**) controls how Segment
Fill is applied to line graphs. You can control:

- Minimum segment length — lines shorter than this are ignored
- Point separation — spacing of generated points along the segment
- Fill corners — whether to place extra points at corners
- Line width — thickness of the segment line displayed during Segment Fill
- Line color — color of the segment line displayed during Segment Fill
- Inactive opacity — how visible non-highlighted segments appear

A line in the filtered image is a candidate for Segment Fill if it is longer
than the specified minimum segment length. Clicking on that segment creates
points spaced by the specified point separation along the line.

The preview windows display the current settings for both active (hovered) and
inactive segments.

.. image:: dlgsegments1.png
   :alt: Segment Fill dialog example
   :align: center
