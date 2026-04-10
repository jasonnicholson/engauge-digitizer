Glossary
========

.. glossary::
   :sorted:

   advanced import mode
      The advanced Import mode offers the following advanced options for the
      imported file: floating axes and multiple coordinate systems. The advanced
      options are only used by a small percentage of users and are therefore not
      made available during the normal Import process. Once a file has been
      imported, the advanced mode settings cannot be changed.

   axes checker
      Red box that briefly appears whenever the coordinate system has just
      changed. The red box is drawn as a simple rectangle in cartesian
      coordinates, or as an annular arc in polar coordinates. The axes checker
      can indicate when there is a mistake with the axis points, especially data
      entry errors and accidental transposition. An axis point error usually
      makes the axes checker appear skewed.

   axis point
      Point that is added to a graph to define the scale. The two coordinate
      values must be defined for each axis point. Three axis points are needed
      to define the scales in the two coordinate directions.

   checklist guide
      List of steps to follow to digitize a graph, with checkmarks showing
      progress. This can be created during import, by running the checklist
      guide wizard.

   checklist guide wizard
      Wizard that can be used during import to create a checklist guide.

   collinear
      Collinear points lie along a straight line. The three axis points cannot
      be collinear because graph coordinates are therefore impossible to
      compute.

   collocated
      Collocated points are close to each other or at the same location.
      Multiple axis points cannot share the same location because graph
      coordinates are therefore impossible to compute, and should be widely
      separated so computed graph coordinates are most accurate.

   coordinate system
      A coordinate system is defined by a pair of x and y axes. A graph with
      multiple coordinate systems is digitized using the advanced
      :doc:`faq/multiple-coord-systems` steps.

   coordinates
      Two values used in a graph to specify position. If the coordinates are
      cartesian, the two values are X and Y. If the coordinates are polar, the
      two values are the radius R and the angle theta. The X, Y and R
      coordinates can be logarithmic.

   corner
      The point at the junction of two line segments in a piecewise linear
      curve.

   curve
      Continuous line in a graph or map. This is digitized by creating curve
      points along the line.

   curve point
      Point that is added to a graph on top of either a curve or point in the
      original image.

   digitize
      Process of converting non-digital data into numbers. The specific type of
      digitizing performed by Engauge Digitizer is the conversion of graph and
      map images into numbers. These numbers can be exported to spreadsheets and
      other math software.

   discretize
      Process that converts each pixel of an original image into either the
      black foreground, or the white background. The colors and grays of the
      original image are lost. By controlling discretizing, unwanted parts of
      the original image can be removed.

   engauge
      Process of converting an image file containing a graph or map into
      numbers. The word 'engauge' was invented to distinguish this process from
      other types of digitizing.

   export
      Process of copying digitized information from Engauge Digitizer to other
      software or a file.

   fast correlation
      A preferred method of performing template matching, which is identifying
      various places in an image where a template (or sample) appears. This
      method is fast because it uses a highly efficient `Fast Fourier Transform
      <http://www.fftw.org>`_, and is therefore used by Engauge to perform point
      matching.

   floating axis
      A floating axis is an x axis with unknown y value, or y axis with unknown
      x value. A graph with a floating axis is digitized according to
      :doc:`faq/floating-axes`.

   graph
      Image that normally has one coordinate system consisting of two coordinate
      directions. Three axis points define the scales in the two coordinate
      directions, and the location of the origin. Graphs have either points or
      curves. An image may also have multiple coordinate systems.

   grid display
      Grid lines may be added to a graph after the axis points have been
      defined. Any errors while creating the axis points are usually apparent
      when grid lines are displayed.

   grid removal
      Process that removes the grid from an original graph image so automated
      digitizing techniques perform better.

   import
      Process of loading an original graph or map image into Engauge Digitizer.

   line graph
      Graph containing lines.

   line segment
      Part of a straight line that lies between two end points.

   map
      Image without any coordinates, and having the same scale in any
      direction. A scale bar defines the scale in a map.

   measure
      Set of one or more connected line segments that is used to measure
      distance and/or area in a graph or map.

   piecewise linear
      Curve that is composed of multiple line segments. A graph of the absolute
      value function is a simple example of a piecewise linear curve.

   point graph
      Graph containing distinct points in the original image.

   point match
      Automated digitizing technique used on graphs containing points. The user
      selects a representative sample point, and then similar points are
      automatically digitized starting with the closest match.

   resolution
      The distance in graph units corresponding to the pixel separation of the
      original image. This distance is displayed in the status bar, since it
      represents the accuracy of the graph measurements.

   sample point
      The point, chosen by the user during point matching, that best represents
      the points to be matched.

   scale
      Relationship between the actual distance on the graph or map, and the
      represented units. Typically, actual distance is measured in pixels on the
      screen, or centimeters or inches on a printout. The represented units may
      be distance, time, percent, counts, etc.

   scale bar
      Line segment that defines the scale of a map.

   segment
      Piece of a curve, in a graph, that can be automatically digitized using
      segment fill mode. A segment is a set of adjoining points that lie between
      two endpoints.

   segment fill
      Process of automatically digitizing a curve in a graph, by creating curve
      points along each segment along the curve.

   select mode
      Digitizing mode in which existing points can be selected by clicking on
      individual points, or clicking and dragging to select all points in a box.
      Shift-click adds a new point to the points that are already selected. The
      control key temporarily hides points that do not belong to the currently
      selected curve.

   session
      Period of time spent using Engauge Digitizer, from starting the software
      to stopping it.
