Better Accuracy
===============

To get better accuracy in the digitized output data exported from Engauge
Digitizer, it is helpful to understand that all points are only as accurate as
the pixel size (you can see that accuracy in the status bar). If the distance in
graph units from one pixel to the next is D, then theoretically the best
possible accuracy is also D.

It is not possible to define points that are 'between' pixels, even by zooming
in closer. That is a constraint imposed by the graphics library that is used in
Engauge Digitizer.

Fortunately, there are some tricks to improve the accuracy. In order of
increasing difficulty:

- If the axis points are not correctly defined then
  :doc:`fix them <fixing-axis-points>`.
- Use a graphics application like Microsoft Paint (Windows) or GIMP (Linux) to
  scale the original up in size so each pixel is smaller, and therefore the
  accuracy of each point is correspondingly better. The larger image is then
  imported into Engauge Digitizer. This step can be performed using just the
  command line using the powerful ImageMagick tool.
