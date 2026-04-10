Digitizing Line Graphs
======================

Typical Steps
-------------

The following steps digitize a linear Cartesian graph with one curve:

1. Obtain an image file (bitmap, JPEG, or other) showing one or more curves and
   both axes.

2. Import the image using one of:

   - **File > Import**
   - Copy-and-paste
   - Drag-and-drop

3. Click **Axes Point** and place three axes points (one per axis tick whose
   coordinates you know), entering the graph coordinate for each.

4. Click **Segment Fill** to automatically digitize entire curve segments at a
   time. Click on segments to fill them with curve points.

5. Click **Curve Points** to manually add additional curve points as needed.

6. Export curve points using one of:

   - **File > Export** — saves selected curves to a tabular text file
   - Copy-and-paste from the :doc:`../dialogs/curve-geometry` window
   - Drag-and-drop from the :doc:`../dialogs/curve-geometry` window

Optional Steps
--------------

To improve Segment Fill and Point Match performance:

- Select **View > Background > Show Filtered Image** to see the processed image.
- Adjust **Settings > Discretize** until unwanted image features disappear.
- Remove grid lines with **Settings > Grid Removal**.

For a logarithmic or polar graph:

- Open **Settings > Coords** (see :doc:`../coordinates`) and select the
  appropriate coordinate settings.

For a graph with more than one curve:

- Open **Settings > Curves** (see :doc:`../dialogs/curves`) and add curve names.
- Use the Curves combobox in the main window to select the active curve before
  digitizing each one.
