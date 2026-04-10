Community Feedback
==================

The following are selected user comments from the Engauge Digitizer community
forums, illustrating real-world use cases and feature highlights.

----

   *"I have recently used Engauge Digitizer to extract x–y data from some
   graphs and the application is indeed awesome."*

   — Shekeine (feature request for multiple coordinate systems, which was
   subsequently implemented)

----

   *"Engauge can export interpolated data. That is a great feature."*

   — Dominique Libre

----

   *"I just discovered Engauge: it looks great."*

   — Jean Orloff, asking about PDF/EPS support

----

Use Cases from the Community
-----------------------------

These posts highlight real-world digitizing tasks users brought to Engauge:

- Extracting x–y data from scientific journal figures
- Digitizing faceted/multi-panel graphs (supported via multiple coordinate
  systems — see :doc:`faq/multiple-coord-systems`)
- Digitizing well log strip charts from geophysical surveys
- Recovering data from figures in papers (PDF/PS workflows)
- Digitizing vacuum tube and transistor characteristic curves

Tips from Community Discussions
--------------------------------

**Duplicate x-values in export:** If two manually-placed points share the
same x-value, the second may be dropped when exporting in interpolated mode.
Workaround: use **Raw Xs And Ys** export mode (**Settings > Export Setup**) to
get every point exactly as placed, then perform any desired interpolation
externally.

**Controlling interpolation range:** To avoid extrapolation beyond the
measured data range, export as **Raw Xs And Ys** and discard points outside
the range of your first and last measured points in post-processing.

**Automatic axis placement:** The ``--axes`` command-line flag can be combined
with ``--import`` to auto-generate three axis points when batch-processing
many images. See :doc:`cli` for details.

----

*These quotes and discussions are sourced from the original Engauge Digitizer
community forums (circa 2010–2020).*
