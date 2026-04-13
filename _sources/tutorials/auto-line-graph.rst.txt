Automatic Line Graph Tutorial
=============================

The following steps automatically digitize a linear Cartesian graph with one curve.

1. Import the ``testcase.png`` sample from the Samples directory using **File > Import**.
   Other import methods include the :doc:`-import command line option <../cli>`,
   copy-and-paste, and drag-and-drop.

   .. image:: ../_images/tutorautolinegraph1.png
      :alt: File Import menu

2. Click the **Axes Point** button before entering axes points. These define the
   coordinate system.

   .. image:: ../_images/tutorautolinegraph2.png
      :alt: Axes Point button

3. Click on one of the axes to add the first axes point, then enter its graph
   coordinates.

   .. image:: ../_images/tutorautolinegraph3.png
      :alt: First axis point dialog

4. Click on one of the axes to add the second axes point, then enter its graph
   coordinates.

   .. image:: ../_images/tutorautolinegraph4.png
      :alt: Second axis point dialog

5. Click on one of the axes to add the third axes point, then enter its graph
   coordinates.

   .. image:: ../_images/tutorautolinegraph5.png
      :alt: Third axis point dialog

6. View the filtered image by selecting **View > Background > Show Filtered Image**.

   .. image:: ../_images/tutorautolinegraph6.png
      :alt: Processed image view

7. Tune the color filter settings using **Settings > Color Filter...** so
   unwanted information in the image is removed.

   .. image:: ../_images/tutorautolinegraph7.png
      :alt: Discretize dialog

8. Click the **Segment Fill** button.

   .. image:: ../_images/tutorautolinegraph9.png
      :alt: Segment Fill button

9. Click on each segment of the curve to add regularly spaced curve points along
   that segment. Repeat until points have been created for all segments in the graph.

   .. image:: ../_images/tutorautolinegraph10.png
      :alt: Curve points added via segment fill

10. Export the curve points into a tabular text file using **File > Export...**.
    Other export methods include copy-and-paste and drag-and-drop from the
    Geometry Window.

    .. image:: ../_images/tutorautolinegraph11.png
       :alt: File Export menu
