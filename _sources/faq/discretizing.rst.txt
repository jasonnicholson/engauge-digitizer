Discretizing
============

What Is Discretizing?
---------------------

When an image is imported, Engauge Digitizer processes it by converting each
pixel into black or white. Since most images use black writing on a white
background, the black pixels are assumed to represent curves and the white
pixels represent the background. This process is called *discretizing*.

The resulting processed image can be automatically digitized using Segment Fill
and Point Match.

Usually the default discretizing settings correctly separate the foreground from
the background:

.. list-table::
   :class: borderless

   * - .. image:: ../_images/discretize_ok_before.png
          :alt: Original image before discretizing
     - .. image:: ../_images/discretize_ok_after.png
          :alt: Processed image after discretizing
   * - Before discretizing
     - After discretizing

However, a color image might not be correctly discretized. The relatively dark
green in the original may be mistaken for foreground:

.. list-table::
   :class: borderless

   * - .. image:: ../_images/discretize_bad_color_before.png
          :alt: Color image before discretizing
     - .. image:: ../_images/discretize_bad_color_after.png
          :alt: Featureless result after discretizing
   * - Before discretizing
     - After discretizing (bad)

Even a black-and-white image can produce poor results. One curve may break into
short disconnected segments while another disappears entirely:

.. list-table::
   :class: borderless

   * - .. image:: ../_images/discretize_bad_gray_before.png
          :alt: Low-contrast image before discretizing
     - .. image:: ../_images/discretize_bad_gray_after.png
          :alt: Poor result after discretizing
   * - Before discretizing
     - After discretizing (bad)

How Do I Control Discretizing?
-------------------------------

By changing the discretizing settings, curves can often be extracted from color,
low-contrast, and low-resolution images — such as those produced by fax
machines, microfiche, cheap scanners, or excessive enlarging.

Use **Settings > Discretize** to experiment with various settings. See
:doc:`../dialogs/discretize` for a full description of the Discretize dialog.
