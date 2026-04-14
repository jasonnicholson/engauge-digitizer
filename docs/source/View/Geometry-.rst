Geometry Window
===============

The Geometry Window shows distances, areas, and other geometric measurements for
the currently active curve or measure (as displayed in the Digitize toolbar).
Open it from **View > Geometry Window**.

Regions in the window may be selected and exported to other applications by
copying (Ctrl+C) or dragging.

Columns
-------

**X / Y**
    Graph coordinates of each point. Until axes points or a scale bar are
    defined, coordinates are shown in screen pixels.

**Index**
    Sequential index of each point (starting at 1).

**Distance (Forward / Backward)**
    Cumulative arc length along the curve from the first (or last) point.

**Percent (Forward / Backward)**
    Each point's arc-length distance expressed as a percentage of the total
    curve length.

Header Values
-------------

**CurveName**
    Name of the currently displayed curve or measure.

**FunctionArea**
    Area calculated by integrating under the curve (useful for function-type
    curves).

**PolygonArea**
    Area within the polygon formed by connecting all points.

.. image:: ../_images/dlgcurvegeometry1.png
   :alt: Geometry Window example
   :align: center
