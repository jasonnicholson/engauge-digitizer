Discretize Dialog
=================

The Discretize dialog controls how the original image is converted into a
processed (black-and-white) image. The processed image is used by Segment Fill
and Point Match. To view the processed image select **View > Processed Image**.

Pixel Attribute
---------------

The Discretize settings determine which attribute of the picture decides whether
each pixel is "on" or "off":

**Intensity**
    Similar to Value; refers to the degree of lightness or darkness.

**Foreground**
    Any part of the image that is not the background color. The background color
    is defined as the color that appears most often in the original image.

**Hue**
    The color, ranging from red through the spectrum and back to red.

**Saturation**
    The degree of hue. Unsaturated colors are black, white, and shades of gray.

**Value**
    Similar to Intensity; refers to the degree of lightness or darkness.

Usage
-----

Select an attribute. A histogram of that attribute's values appears in the
histogram window. Click and drag the two tabs in the histogram to change the
attribute range. Changes appear immediately in the Preview window.

The Discretize settings that successfully clean up the ``pointplot.bmp`` sample
are shown below:

.. image:: ../_images/dlgdiscretize1.png
   :alt: Discretize dialog example
   :align: center
