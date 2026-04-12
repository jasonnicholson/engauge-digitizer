#include "CallbackAxisPointsAbstract.h"
#include "CallbackUpdateTransform.h"
#include "Logger.h"
#include <QtTest/QtTest>
#include "Test/TestGraphCoords.h"

QTEST_MAIN (TestGraphCoords)

const double EPSILON = 0.0;

TestGraphCoords::TestGraphCoords(QObject *parent) :
  QObject(parent)
{
  m_callback = new CallbackUpdateTransform (m_modelCoords,
                                            DOCUMENT_AXES_POINTS_REQUIRED_3);
}

void TestGraphCoords::cleanupTestCase ()
{
}

void TestGraphCoords::initTestCase ()
{
  const bool DEBUG_FLAG = false;

  initializeLogging ("engauge_test",
                     "engauge_test.log",
                     DEBUG_FLAG);
}

void TestGraphCoords::testAnyColumnsRepeatNo ()
{
  CoordPairVector vector;

  vector.push_back (QPointF (100, 100));
  vector.push_back (QPointF (300, 100));
  vector.push_back (QPointF (200, 200));

  QVERIFY (!m_callback->anyPointsRepeatPair (vector,
                                             EPSILON));
}

void TestGraphCoords::testAnyColumnsRepeatYes ()
{
  CoordPairVector vector;

  // First two points repeat
  vector.push_back (QPointF (100, 100));
  vector.push_back (QPointF (100, 100));
  vector.push_back (QPointF (200, 200));

  QVERIFY (m_callback->anyPointsRepeatPair (vector,
                                            EPSILON));
}

void TestGraphCoords::testThreeCollinearPointsNo ()
{
  // Points are not collinear
  QTransform m (100, 300, 200,
                100, 150, 200,
                1  , 1  , 1  );

  QVERIFY (!m_callback->threePointsAreCollinear (m,
                                                 CallbackAxisPointsAbstract::LinearOrLog::COORD_IS_LINEAR,
                                                 CallbackAxisPointsAbstract::LinearOrLog::COORD_IS_LINEAR));
}

void TestGraphCoords::testThreeCollinearPointsYes ()
{
  // Points are collinear
  QTransform m (100, 150, 200,
                100, 150, 200,
                1  , 1  , 1  );

  QVERIFY (m_callback->threePointsAreCollinear (m,
                                                CallbackAxisPointsAbstract::LinearOrLog::COORD_IS_LINEAR,
                                                CallbackAxisPointsAbstract::LinearOrLog::COORD_IS_LINEAR));
}
