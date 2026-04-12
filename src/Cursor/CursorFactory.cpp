/******************************************************************************************************
 * (C) 2014 markummitchell@github.com. This file is part of Engauge Digitizer, which is released      *
 * under GNU General Public License version 2 (GPLv2) or (at your option) any later version. See file *
 * LICENSE or go to gnu.org/licenses for details. Distribution requires prior written permission.     *
 ******************************************************************************************************/

#include "CursorFactory.h"
#include "CursorSize.h"
#include "DocumentModelDigitizeCurve.h"
#include <QPainter>
#include <QPixmap>

CursorFactory::CursorFactory()
{
}

QCursor CursorFactory::generate (const DocumentModelDigitizeCurve &modelDigitizeCurve) const
{
  // To prevent hideous drawing errors when the line is thicker, we
  // leave a padding region around the outside equal in size to the line width
  int innerRadius = modelDigitizeCurve.cursorInnerRadius();
  int size = CursorSizeToPixels (modelDigitizeCurve.cursorSize());
  int halfSize = size / 2;
  int lineWidth = modelDigitizeCurve.cursorLineWidth();
  int halfLineWidth = lineWidth / 2;

  if (modelDigitizeCurve.cursorStandardCross()) {

    // Standard cursor
    return QCursor (Qt::CrossCursor);

  } else {

    // Custom cursor drawn on a transparent pixmap
    QPixmap pic (size, size);
    pic.fill (Qt::transparent);

    QPainter painter (&pic);
    QPen pen (Qt::black, modelDigitizeCurve.cursorLineWidth());
    painter.setPen (pen);

    painter.drawLine (QPointF (halfSize,
                               halfSize - innerRadius - halfLineWidth),
                      QPointF (halfSize,
                               lineWidth)); // Up
    painter.drawLine (QPointF (halfSize - innerRadius - halfLineWidth,
                               halfSize),
                      QPointF (lineWidth,
                               halfSize)); // Left
    painter.drawLine (QPointF (halfSize,
                               halfSize + innerRadius + halfLineWidth),
                      QPointF (halfSize,
                               size - 1 - lineWidth)); // Down
    painter.drawLine (QPointF (halfSize + innerRadius + halfLineWidth,
                               halfSize),
                      QPointF (size - 1 - lineWidth,
                               halfSize)); // Right
    painter.end ();

    return QCursor (pic, halfSize, halfSize);
  }
}
