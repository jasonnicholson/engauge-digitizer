Automatic Point Graph Tutorial
===============================

.. note::
   Not all point graphs work well with automatic point matching in Engauge.
   Review the point match requirements before proceeding.

The following steps automatically digitize a linear Cartesian graph with one curve.

1. Import the ``pointplot.bmp`` sample from the Samples directory using
   **File > Import**.

   .. image:: ../_images/tutorautopointgraph1.png
      :alt: File Import menu

2. Click the **Axes Point** button before entering axes points. These define the
   coordinate system.

   .. image:: ../_images/tutorautopointgraph2.png
      :alt: Axes Point button

3. Click on one of the axes to add the first axes point, then enter its graph
   coordinates.

   .. image:: ../_images/tutorautopointgraph3.png
      :alt: First axis point dialog

4. Click on one of the axes to add the second axes point, then enter its graph
   coordinates.

   .. image:: ../_images/tutorautopointgraph4.png
      :alt: Second axis point dialog

5. Click on one of the axes to add the third axes point, then enter its graph
   coordinates.

   .. image:: ../_images/tutorautopointgraph5.png
      :alt: Third axis point dialog

6. View the processed image by selecting **View > Background > Filtered Image**.

   .. image:: ../_images/tutorautopointgraph6.png
      :alt: Filtered image view

7. Tune the discretize settings using **Settings > Discretize** to remove
   unwanted information. For the PointPlot sample, use Intensity from 90 to 99.

   .. image:: ../_images/tutorautopointgraph7.png
      :alt: Discretize dialog

8. Click the **Point Match** button.

   .. image:: ../_images/tutorautopointgraph9.png
      :alt: Point Match button

9. Click on the point in the filtered image that best represents the type of
   point you want to match. A blue box will appear around the best candidate.

   .. image:: ../_images/tutorautopointgraph10.png
      :alt: Candidate point with blue box

10. Mark each candidate point as **Accepted** (Right Arrow or Space Bar) or
    **Rejected**. Accepted points turn green; rejected points turn red.
    Press Left Arrow to unmark the previously marked point.

    .. image:: ../_images/tutorautopointgraph11.png
       :alt: Accepted and rejected point candidates

11. Leave Point Match mode to assign all accepted points to the current curve
    by clicking the **Select** button or any other Digitize toolbar button.

    .. image:: ../_images/tutorautopointgraph12.png
       :alt: Leaving Point Match mode

12. Export the curve points using **File > Export As**.

    .. image:: ../_images/tutorautopointgraph13.png
       :alt: File Export As menu
