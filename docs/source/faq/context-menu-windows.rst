Windows Explorer Context Menu
=============================

.. note::
   These instructions reference older versions of Windows Explorer and may need
   adjustment for current Windows versions.

Introduction
------------

In Windows Explorer a simple right-click on an image file will bring up a
context menu that lists some software applications. Clicking on one of those
applications starts that application, and loads the image file.

Engauge Digitizer can be inserted into that context menu, where it is easily
available for processing image file formats such as BMP, GIF, JPEG, PNG and XPM.

Frequent users of Engauge Digitizer will appreciate the speed of context menus.

Steps
-----

Follow these ten steps to add Engauge Digitizer to the Windows Explorer context
menu:

1. Open up Windows Explorer
2. Select **Tools** > **Folder Options** > **File Types**
3. Select an image file type from the list of registered file types
4. Click on the **Advanced** button
5. Select the **open** action
6. Click on the **Edit** button
7. In the "Application used to perform action" field, enter the path to the
   Engauge executable followed by ``"%1"``, being careful to include the
   quotation marks::

      "C:\path\to\engauge.exe" "%1"

8. Click on the **OK** button to finish editing the open action
9. Click on the **OK** button to finish modifying the file type actions
10. Click on the **OK** button to finish modifying folder options, or select
    another image file type and repeat starting at step 4

.. image:: /_images/windowscontexta.jpg
   :alt: Windows context menu setup step A

.. image:: /_images/windowscontextb.jpg
   :alt: Windows context menu setup step B

.. image:: /_images/windowscontextc.jpg
   :alt: Windows context menu setup step C
