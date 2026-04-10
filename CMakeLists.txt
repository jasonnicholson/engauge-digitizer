cmake_minimum_required(VERSION 3.16)
project(engauge VERSION 13.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt6 only
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Help
    Network
    PrintSupport
    Widgets
    Xml
)

qt_standard_project_setup()

# ---------------------------------------------------------------------------
# Optional features
# ---------------------------------------------------------------------------
option(ENGAUGE_JPEG2000 "Enable JPEG2000 input support (requires OpenJPEG)" OFF)
option(ENGAUGE_PDF      "Enable PDF input support (requires poppler-qt6)"   OFF)
option(ENGAUGE_LOG4CPP_NULL "Use bundled log4cpp_null stub instead of system log4cpp" ON)
option(ENGAUGE_NETWORKING "Enable network features" ON)

# ---------------------------------------------------------------------------
# Core source files (from engauge.pro, excluding optional features)
# ---------------------------------------------------------------------------
set(ENGAUGE_SOURCES
    src/Background/BackgroundImage.cpp
    src/Background/BackgroundStateAbstractBase.cpp
    src/Background/BackgroundStateContext.cpp
    src/Background/BackgroundStateCurve.cpp
    src/Background/BackgroundStateNone.cpp
    src/Background/BackgroundStateOriginal.cpp
    src/Background/BackgroundStateUnloaded.cpp
    src/Callback/CallbackAddPointsInCurvesGraphs.cpp
    src/Callback/CallbackAxesCheckerFromAxesPoints.cpp
    src/Callback/CallbackAxisPointsAbstract.cpp
    src/Callback/CallbackBoundingRects.cpp
    src/Callback/CallbackCheckAddPointAxis.cpp
    src/Callback/CallbackCheckEditPointAxis.cpp
    src/Callback/CallbackDocumentHash.cpp
    src/Callback/CallbackDocumentScrub.cpp
    src/Callback/CallbackGatherXThetasAbstractBase.cpp
    src/Callback/CallbackGatherXThetasInCurves.cpp
    src/Callback/CallbackGatherXThetasInGridLines.cpp
    src/Callback/CallbackNextOrdinal.cpp
    src/Callback/CallbackPointOrdinal.cpp
    src/Callback/CallbackRemovePointsInCurvesGraphs.cpp
    src/Callback/CallbackScaleBar.cpp
    src/Callback/CallbackSceneUpdateAfterCommand.cpp
    src/Callback/CallbackUpdateTransform.cpp
    src/Checker/Checker.cpp
    src/Checker/CheckerMode.cpp
    src/Checklist/ChecklistGuideBrowser.cpp
    src/Checklist/ChecklistGuide.cpp
    src/Checklist/ChecklistGuidePageConclusion.cpp
    src/Checklist/ChecklistGuidePage.cpp
    src/Checklist/ChecklistGuidePageCurves.cpp
    src/Checklist/ChecklistGuidePageIntro.cpp
    src/Checklist/ChecklistGuideWizard.cpp
    src/Checklist/ChecklistLineEdit.cpp
    src/Checklist/ChecklistTemplate.cpp
    src/Cmd/CmdAbstract.cpp
    src/Cmd/CmdAddPointAxis.cpp
    src/Cmd/CmdAddPointGraph.cpp
    src/Cmd/CmdAddPointsGraph.cpp
    src/Cmd/CmdAddScale.cpp
    src/Cmd/CmdCopy.cpp
    src/Cmd/CmdCut.cpp
    src/Cmd/CmdDelete.cpp
    src/Cmd/CmdEditPointAxis.cpp
    src/Cmd/CmdEditPointGraph.cpp
    src/Cmd/CmdFactory.cpp
    src/Cmd/CmdGong.cpp
    src/Cmd/CmdGuidelineAddXT.cpp
    src/Cmd/CmdGuidelineAddYR.cpp
    src/Cmd/CmdGuidelineMoveXT.cpp
    src/Cmd/CmdGuidelineMoveYR.cpp
    src/Cmd/CmdGuidelineRemoveXT.cpp
    src/Cmd/CmdGuidelineRemoveYR.cpp
    src/Cmd/CmdGuidelineViewState.cpp
    src/Cmd/CmdMediator.cpp
    src/Cmd/CmdMoveBy.cpp
    src/Cmd/CmdPointChangeBase.cpp
    src/Cmd/CmdRedoForTest.cpp
    src/Cmd/CmdSelectCoordSystem.cpp
    src/Cmd/CmdSettingsAxesChecker.cpp
    src/Cmd/CmdSettingsColorFilter.cpp
    src/Cmd/CmdSettingsCoords.cpp
    src/Cmd/CmdSettingsCurveList.cpp
    src/Cmd/CmdSettingsCurveProperties.cpp
    src/Cmd/CmdSettingsDigitizeCurve.cpp
    src/Cmd/CmdSettingsExportFormat.cpp
    src/Cmd/CmdSettingsGeneral.cpp
    src/Cmd/CmdSettingsGridDisplay.cpp
    src/Cmd/CmdSettingsGridRemoval.cpp
    src/Cmd/CmdSettingsPointMatch.cpp
    src/Cmd/CmdSettingsSegments.cpp
    src/Cmd/CmdStackShadow.cpp
    src/Cmd/CmdUndoForTest.cpp
    src/Color/ColorFilter.cpp
    src/Color/ColorFilterHistogram.cpp
    src/Color/ColorFilterMode.cpp
    src/Color/ColorFilterSettings.cpp
    src/Color/ColorFilterSettingsStrategyAbstractBase.cpp
    src/Color/ColorFilterSettingsStrategyForeground.cpp
    src/Color/ColorFilterSettingsStrategyHue.cpp
    src/Color/ColorFilterSettingsStrategyIntensity.cpp
    src/Color/ColorFilterSettingsStrategySaturation.cpp
    src/Color/ColorFilterSettingsStrategyValue.cpp
    src/Color/ColorFilterStrategyAbstractBase.cpp
    src/Color/ColorFilterStrategyForeground.cpp
    src/Color/ColorFilterStrategyHue.cpp
    src/Color/ColorFilterStrategyIntensity.cpp
    src/Color/ColorFilterStrategySaturation.cpp
    src/Color/ColorFilterStrategyValue.cpp
    src/Color/ColorPalette.cpp
    src/Coord/CoordScale.cpp
    src/Coord/CoordsType.cpp
    src/Coord/CoordSymbol.cpp
    src/Coord/CoordUnitsDate.cpp
    src/Coord/CoordUnitsNonPolarTheta.cpp
    src/Coord/CoordUnitsPolarTheta.cpp
    src/Coord/CoordUnitsTime.cpp
    src/CoordSystem/CoordSystemContext.cpp
    src/CoordSystem/CoordSystem.cpp
    src/CoordSystem/CoordSystemInterface.cpp
    src/Correlation/Correlation.cpp
    src/Create/CreateActions.cpp
    src/Create/CreateCentralWidget.cpp
    src/Create/CreateCommandStackShadow.cpp
    src/Create/CreateDockableWidgets.cpp
    src/Create/CreateFacade.cpp
    src/Create/CreateIcons.cpp
    src/Create/CreateLoadImage.cpp
    src/Create/CreateMenus.cpp
    src/Create/CreateNetwork.cpp
    src/Create/CreateScene.cpp
    src/Create/CreateSettingsDialogs.cpp
    src/Create/CreateStateContexts.cpp
    src/Create/CreateStatusBar.cpp
    src/Create/CreateToolBars.cpp
    src/Create/CreateTutorial.cpp
    src/Create/CreateZoomMaps.cpp
    src/Cursor/CursorFactory.cpp
    src/Cursor/CursorSize.cpp
    src/Curve/CurveConnectAs.cpp
    src/Curve/Curve.cpp
    src/Curve/CurveNameList.cpp
    src/Curve/CurveSettingsInt.cpp
    src/Curve/CurvesGraphs.cpp
    src/Curve/CurveStyle.cpp
    src/Curve/CurveStyles.cpp
    src/DigitizeState/DigitizeStateAbstractBase.cpp
    src/DigitizeState/DigitizeStateAxis.cpp
    src/DigitizeState/DigitizeStateColorPicker.cpp
    src/DigitizeState/DigitizeStateContext.cpp
    src/DigitizeState/DigitizeStateCurve.cpp
    src/DigitizeState/DigitizeStateEmpty.cpp
    src/DigitizeState/DigitizeStatePointMatch.cpp
    src/DigitizeState/DigitizeStateScale.cpp
    src/DigitizeState/DigitizeStateSegment.cpp
    src/DigitizeState/DigitizeStateSelect.cpp
    src/Dlg/DlgAbout.cpp
    src/Dlg/DlgEditPointAxis.cpp
    src/Dlg/DlgEditPointGraph.cpp
    src/Dlg/DlgEditPointGraphLineEdit.cpp
    src/Dlg/DlgEditScale.cpp
    src/Dlg/DlgErrorReportAbstractBase.cpp
    src/Dlg/DlgErrorReportLocal.cpp
    src/Dlg/DlgFilterCommand.cpp
    src/Dlg/DlgFilterThread.cpp
    src/Dlg/DlgFilterWorker.cpp
    src/Dlg/DlgImportAdvanced.cpp
    src/Dlg/DlgRequiresTransform.cpp
    src/Dlg/DlgSettingsAbstractBase.cpp
    src/Dlg/DlgSettingsAxesChecker.cpp
    src/Dlg/DlgSettingsColorFilter.cpp
    src/Dlg/DlgSettingsCoords.cpp
    src/Dlg/DlgSettingsCurveList.cpp
    src/Dlg/DlgSettingsCurveProperties.cpp
    src/Dlg/DlgSettingsDigitizeCurve.cpp
    src/Dlg/DlgSettingsExportFormat.cpp
    src/Dlg/DlgSettingsGeneral.cpp
    src/Dlg/DlgSettingsGridDisplay.cpp
    src/Dlg/DlgSettingsGridRemoval.cpp
    src/Dlg/DlgSettingsMainWindow.cpp
    src/Dlg/DlgSettingsPointMatch.cpp
    src/Dlg/DlgSettingsSegments.cpp
    src/Dlg/DlgValidatorAboveZero.cpp
    src/Dlg/DlgValidatorAbstract.cpp
    src/Dlg/DlgValidatorDateTime.cpp
    src/Dlg/DlgValidatorDegreesMinutesSeconds.cpp
    src/Dlg/DlgValidatorFactory.cpp
    src/Dlg/DlgValidatorNumber.cpp
    src/Document/Document.cpp
    src/Document/DocumentHashGenerator.cpp
    src/Document/DocumentModelAbstractBase.cpp
    src/Document/DocumentModelAxesChecker.cpp
    src/Document/DocumentModelColorFilter.cpp
    src/Document/DocumentModelCoords.cpp
    src/Document/DocumentModelDigitizeCurve.cpp
    src/Document/DocumentModelExportFormat.cpp
    src/Document/DocumentModelGeneral.cpp
    src/Document/DocumentModelGridDisplay.cpp
    src/Document/DocumentModelGridRemoval.cpp
    src/Document/DocumentModelGuidelines.cpp
    src/Document/DocumentModelPointMatch.cpp
    src/Document/DocumentModelSegments.cpp
    src/Document/DocumentScrub.cpp
    src/Document/DocumentSerialize.cpp
    src/Export/ExportAlignLinear.cpp
    src/Export/ExportAlignLog.cpp
    src/Export/ExportDelimiter.cpp
    src/Export/ExportFileAbstractBase.cpp
    src/Export/ExportFileExtension.cpp
    src/Export/ExportFileExtensionOverride.cpp
    src/Export/ExportFileFunctions.cpp
    src/Export/ExportFileRelations.cpp
    src/Export/ExportHeader.cpp
    src/Export/ExportImageForRegression.cpp
    src/Export/ExportLayoutFunctions.cpp
    src/Export/ExportOrdinalsSmooth.cpp
    src/Export/ExportOrdinalsStraight.cpp
    src/Export/ExportPointsIntervalUnits.cpp
    src/Export/ExportPointsSelectionFunctions.cpp
    src/Export/ExportPointsSelectionRelations.cpp
    src/Export/ExportToClipboard.cpp
    src/Export/ExportToFile.cpp
    src/Export/ExportXThetaValuesMergedFunctions.cpp
    src/FileCmd/FileCmdAbstract.cpp
    src/FileCmd/FileCmdClose.cpp
    src/FileCmd/FileCmdExport.cpp
    src/FileCmd/FileCmdFactory.cpp
    src/FileCmd/FileCmdImport.cpp
    src/FileCmd/FileCmdOpen.cpp
    src/FileCmd/FileCmdScript.cpp
    src/FileCmd/FileCmdSerialize.cpp
    src/Filter/FilterImage.cpp
    src/Fitting/FittingCurve.cpp
    src/Fitting/FittingModel.cpp
    src/Fitting/FittingStatistics.cpp
    src/Fitting/FittingWindow.cpp
    src/Format/FormatCoordsUnits.cpp
    src/Format/FormatCoordsUnitsStrategyAbstractBase.cpp
    src/Format/FormatCoordsUnitsStrategyNonPolarTheta.cpp
    src/Format/FormatCoordsUnitsStrategyPolarTheta.cpp
    src/Format/FormatDateTime.cpp
    src/Format/FormatDegreesMinutesSecondsBase.cpp
    src/Format/FormatDegreesMinutesSecondsNonPolarTheta.cpp
    src/Format/FormatDegreesMinutesSecondsPolarTheta.cpp
    src/Geometry/GeometryModel.cpp
    src/Geometry/GeometryStrategyAbstractBase.cpp
    src/Geometry/GeometryStrategyContext.cpp
    src/Geometry/GeometryStrategyFunctionSmooth.cpp
    src/Geometry/GeometryStrategyFunctionStraight.cpp
    src/Geometry/GeometryStrategyRelationSmooth.cpp
    src/Geometry/GeometryStrategyRelationStraight.cpp
    src/Geometry/GeometryWindow.cpp
    src/Ghosts/GhostEllipse.cpp
    src/Ghosts/GhostPath.cpp
    src/Ghosts/GhostPolygon.cpp
    src/Ghosts/Ghosts.cpp
    src/Graphics/GraphicsArcItem.cpp
    src/Graphics/GraphicsItemsExtractor.cpp
    src/Graphics/GraphicsLinesForCurve.cpp
    src/Graphics/GraphicsLinesForCurves.cpp
    src/Graphics/GraphicsPointAbstractBase.cpp
    src/Graphics/GraphicsPoint.cpp
    src/Graphics/GraphicsPointEllipse.cpp
    src/Graphics/GraphicsPointFactory.cpp
    src/Graphics/GraphicsPointPolygon.cpp
    src/Graphics/GraphicsScene.cpp
    src/Graphics/GraphicsView.cpp
    src/Grid/GridClassifier.cpp
    src/Grid/GridCoordDisable.cpp
    src/Grid/GridHealerAbstractBase.cpp
    src/Grid/GridHealerHorizontal.cpp
    src/Grid/GridHealerVertical.cpp
    src/Grid/GridInitializer.cpp
    src/Grid/GridLine.cpp
    src/Grid/GridLineFactory.cpp
    src/Grid/GridLineLimiter.cpp
    src/Grid/GridLines.cpp
    src/Grid/GridLog.cpp
    src/Grid/GridRemoval.cpp
    src/Grid/GridTriangleFill.cpp
    src/Guideline/GuidelineAbstract.cpp
    src/Guideline/GuidelineDragCommandFactory.cpp
    src/Guideline/GuidelineEllipse.cpp
    src/Guideline/GuidelineFactory.cpp
    src/Guideline/GuidelineFormat.cpp
    src/Guideline/GuidelineIdentifierGenerator.cpp
    src/Guideline/GuidelineLine.cpp
    src/Guideline/GuidelineOffset.cpp
    src/Guideline/GuidelineProjectorAbstract.cpp
    src/Guideline/GuidelineProjectorConstantR.cpp
    src/Guideline/GuidelineProjectorConstantT.cpp
    src/Guideline/GuidelineProjectorConstantX.cpp
    src/Guideline/GuidelineProjectorConstantY.cpp
    src/Guideline/Guidelines.cpp
    src/Guideline/GuidelineStateAbstractBase.cpp
    src/Guideline/GuidelineStateContext.cpp
    src/Guideline/GuidelineState.cpp
    src/Guideline/GuidelineStateDeployedAbstract.cpp
    src/Guideline/GuidelineStateDeployedConstantRAbstract.cpp
    src/Guideline/GuidelineStateDeployedConstantRSelectEditAppearing.cpp
    src/Guideline/GuidelineStateDeployedConstantRSelectEdit.cpp
    src/Guideline/GuidelineStateDeployedConstantRSelectEditHover.cpp
    src/Guideline/GuidelineStateDeployedConstantRSelectHide.cpp
    src/Guideline/GuidelineStateDeployedConstantRSelectLock.cpp
    src/Guideline/GuidelineStateDeployedConstantRUnselectEdit.cpp
    src/Guideline/GuidelineStateDeployedConstantRUnselectHide.cpp
    src/Guideline/GuidelineStateDeployedConstantRUnselectLock.cpp
    src/Guideline/GuidelineStateDeployedConstantTAbstract.cpp
    src/Guideline/GuidelineStateDeployedConstantTSelectEditAppearing.cpp
    src/Guideline/GuidelineStateDeployedConstantTSelectEdit.cpp
    src/Guideline/GuidelineStateDeployedConstantTSelectEditHover.cpp
    src/Guideline/GuidelineStateDeployedConstantTSelectHide.cpp
    src/Guideline/GuidelineStateDeployedConstantTSelectLock.cpp
    src/Guideline/GuidelineStateDeployedConstantTUnselectEdit.cpp
    src/Guideline/GuidelineStateDeployedConstantTUnselectHide.cpp
    src/Guideline/GuidelineStateDeployedConstantTUnselectLock.cpp
    src/Guideline/GuidelineStateDeployedConstantXAbstract.cpp
    src/Guideline/GuidelineStateDeployedConstantXSelectEditAppearing.cpp
    src/Guideline/GuidelineStateDeployedConstantXSelectEdit.cpp
    src/Guideline/GuidelineStateDeployedConstantXSelectEditHover.cpp
    src/Guideline/GuidelineStateDeployedConstantXSelectHide.cpp
    src/Guideline/GuidelineStateDeployedConstantXSelectLock.cpp
    src/Guideline/GuidelineStateDeployedConstantXUnselectEdit.cpp
    src/Guideline/GuidelineStateDeployedConstantXUnselectHide.cpp
    src/Guideline/GuidelineStateDeployedConstantXUnselectLock.cpp
    src/Guideline/GuidelineStateDeployedConstantYAbstract.cpp
    src/Guideline/GuidelineStateDeployedConstantYSelectEditAppearing.cpp
    src/Guideline/GuidelineStateDeployedConstantYSelectEdit.cpp
    src/Guideline/GuidelineStateDeployedConstantYSelectEditHover.cpp
    src/Guideline/GuidelineStateDeployedConstantYSelectHide.cpp
    src/Guideline/GuidelineStateDeployedConstantYSelectLock.cpp
    src/Guideline/GuidelineStateDeployedConstantYUnselectEdit.cpp
    src/Guideline/GuidelineStateDeployedConstantYUnselectHide.cpp
    src/Guideline/GuidelineStateDeployedConstantYUnselectLock.cpp
    src/Guideline/GuidelineStateDiscarded.cpp
    src/Guideline/GuidelineStateHandleAbstract.cpp
    src/Guideline/GuidelineStateHandleR.cpp
    src/Guideline/GuidelineStateHandleT.cpp
    src/Guideline/GuidelineStateHandleX.cpp
    src/Guideline/GuidelineStateHandleY.cpp
    src/GuidelineView/GuidelineViewStateAbstractBase.cpp
    src/GuidelineView/GuidelineViewStateContext.cpp
    src/GuidelineView/GuidelineViewState.cpp
    src/GuidelineView/GuidelineViewStateEdit.cpp
    src/GuidelineView/GuidelineViewStateHide.cpp
    src/GuidelineView/GuidelineViewStateLock.cpp
    src/Help/HelpBrowser.cpp
    src/Help/HelpWindow.cpp
    src/Import/ImportCroppingUtilBase.cpp
    src/Import/ImportImageExtensions.cpp
    src/Line/LineStyle.cpp
    src/Load/LoadFileInfo.cpp
    src/Load/LoadImageFromUrl.cpp
    src/Logger/Logger.cpp
    src/Logger/LoggerUpload.cpp
    src/main/main.cpp
    src/main/MainDirectoryPersist.cpp
    src/main/MainWindow.cpp
    src/main/MainWindowModel.cpp
    src/Matrix/Matrix.cpp
    src/Mime/MimePointsDetector.cpp
    src/Mime/MimePointsExport.cpp
    src/Mime/MimePointsImport.cpp
    src/Ordinal/OrdinalGenerator.cpp
    src/Pdf/PdfResolution.cpp
    src/Point/Point.cpp
    src/Point/PointIdentifiers.cpp
    src/Point/PointMatchAlgorithm.cpp
    src/Point/PointMatchPixel.cpp
    src/Point/PointMatchTriplet.cpp
    src/Point/PointShape.cpp
    src/Point/PointStyle.cpp
    src/ScaleBar/ScaleBarAxisPointsUnite.cpp
    src/Segment/Segment.cpp
    src/Segment/SegmentFactory.cpp
    src/Segment/SegmentLine.cpp
    src/Settings/Settings.cpp
    src/Settings/SettingsForGraph.cpp
    src/Spline/SplineCoeff.cpp
    src/Spline/Spline.cpp
    src/Spline/SplineDrawer.cpp
    src/Spline/SplinePair.cpp
    src/StatusBar/StatusBar.cpp
    src/StatusBar/StatusBarMode.cpp
    src/Transformation/Transformation.cpp
    src/Transformation/TransformationStateAbstractBase.cpp
    src/Transformation/TransformationStateContext.cpp
    src/Transformation/TransformationStateDefined.cpp
    src/Transformation/TransformationStateUndefined.cpp
    src/Translator/TranslatorContainer.cpp
    src/Tutorial/TutorialButton.cpp
    src/Tutorial/TutorialButtonRect.cpp
    src/Tutorial/TutorialButtonText.cpp
    src/Tutorial/TutorialDlg.cpp
    src/Tutorial/TutorialStateAbstractBase.cpp
    src/Tutorial/TutorialStateAxisPoints.cpp
    src/Tutorial/TutorialStateChecklistWizardAbstract.cpp
    src/Tutorial/TutorialStateChecklistWizardLines.cpp
    src/Tutorial/TutorialStateChecklistWizardPoints.cpp
    src/Tutorial/TutorialStateColorFilter.cpp
    src/Tutorial/TutorialStateContext.cpp
    src/Tutorial/TutorialStateCurveSelection.cpp
    src/Tutorial/TutorialStateCurveType.cpp
    src/Tutorial/TutorialStateIntroduction.cpp
    src/Tutorial/TutorialStatePointMatch.cpp
    src/Tutorial/TutorialStateSegmentFill.cpp
    src/util/DataKey.cpp
    src/util/EllipseParameters.cpp
    src/util/EnumsToQt.cpp
    src/util/gnuplot.cpp
    src/util/InactiveOpacity.cpp
    src/util/LinearToLog.cpp
    src/util/MigrateToVersion6.cpp
    src/util/mmsubs.cpp
    src/util/Pixels.cpp
    src/util/QtToString.cpp
    src/util/Version.cpp
    src/util/Xml.cpp
    src/util/ZValues.cpp
    src/View/ViewPointStyle.cpp
    src/View/ViewPreview.cpp
    src/View/ViewProfile.cpp
    src/View/ViewProfileDivider.cpp
    src/View/ViewProfileParameters.cpp
    src/View/ViewProfileScale.cpp
    src/View/ViewSegmentFilter.cpp
    src/Window/WindowAbstractBase.cpp
    src/Window/WindowModelBase.cpp
    src/Window/WindowTable.cpp
    src/Zoom/ZoomLabels.cpp
    src/Zoom/ZoomTransition.cpp
)

# ---------------------------------------------------------------------------
# Qt resources
# ---------------------------------------------------------------------------
set(ENGAUGE_RESOURCES src/engauge.qrc)

# ---------------------------------------------------------------------------
# Translations
# ---------------------------------------------------------------------------
set(ENGAUGE_TRANSLATIONS
    translations/engauge_ar.ts
    translations/engauge_cs.ts
    translations/engauge_de.ts
    translations/engauge_en.ts
    translations/engauge_es.ts
    translations/engauge_fa_IR.ts
    translations/engauge_fr.ts
    translations/engauge_hi.ts
    translations/engauge_it.ts
    translations/engauge_ja.ts
    translations/engauge_kk.ts
    translations/engauge_ko.ts
    translations/engauge_nb.ts
    translations/engauge_pt.ts
    translations/engauge_ru.ts
    translations/engauge_zh.ts
)

# Process translations: generate .qm files from .ts files
qt_add_translations(engauge
    TS_FILES ${ENGAUGE_TRANSLATIONS}
)

# ---------------------------------------------------------------------------
# Executable target
# ---------------------------------------------------------------------------
qt_add_executable(engauge
    ${ENGAUGE_SOURCES}
    ${ENGAUGE_RESOURCES}
)

# ---------------------------------------------------------------------------
# Include directories (mirrors INCLUDEPATH in engauge.pro)
# ---------------------------------------------------------------------------
target_include_directories(engauge PRIVATE
    src
    src/Background
    src/Callback
    src/Checker
    src/Checklist
    src/Cmd
    src/Color
    src/Coord
    src/CoordSystem
    src/Correlation
    src/Create
    src/Cursor
    src/Curve
    src/DigitizeState
    src/Dlg
    src/Document
    src/Export
    src/FileCmd
    src/Filter
    src/Fitting
    src/Format
    src/Geometry
    src/Ghosts
    src/Graphics
    src/Grid
    src/Guideline
    src/GuidelineView
    src/Help
    src/img
    src/Import
    src/include
    src/Line
    src/Load
    src/Logger
    src/main
    src/Matrix
    src/Mime
    src/Network
    src/NonPdf
    src/Ordinal
    src/Pdf
    src/Plot
    src/Point
    src/ScaleBar
    src/Segment
    src/Settings
    src/Spline
    src/StatusBar
    src/Transformation
    src/Translator
    src/Tutorial
    src/util
    src/View
    src/Window
    src/Zoom
)

# ---------------------------------------------------------------------------
# Qt6 link libraries (core always required)
# ---------------------------------------------------------------------------
target_link_libraries(engauge PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Help
    Qt6::Network
    Qt6::PrintSupport
    Qt6::Widgets
    Qt6::Xml
)

# Always define NETWORKING on Linux (matches original .pro logic)
if(UNIX AND NOT APPLE)
    target_compile_definitions(engauge PRIVATE NETWORKING)
endif()

# ---------------------------------------------------------------------------
# Release build definitions
# ---------------------------------------------------------------------------
target_compile_definitions(engauge PRIVATE
    $<$<CONFIG:Release>:QT_NO_DEBUG>
)

# ---------------------------------------------------------------------------
# Optional: JPEG2000 support
# ---------------------------------------------------------------------------
if(ENGAUGE_JPEG2000)
    find_path(OPENJPEG_INCLUDE openjpeg.h REQUIRED)
    find_library(OPENJPEG_LIB openjp2 REQUIRED)
    target_compile_definitions(engauge PRIVATE ENGAUGE_JPEG2000)
    target_include_directories(engauge PRIVATE ${OPENJPEG_INCLUDE} src/Jpeg2000)
    target_link_libraries(engauge PRIVATE ${OPENJPEG_LIB})
    target_sources(engauge PRIVATE
        src/Jpeg2000/Jpeg2000.cpp
        src/Jpeg2000/Jpeg2000Callbacks.cpp
        src/Jpeg2000/Jpeg2000Color.cpp
        src/Jpeg2000/Jpeg2000Convert.cpp
    )
    message(STATUS "JPEG2000 support: enabled")
else()
    message(STATUS "JPEG2000 support: disabled")
endif()

# ---------------------------------------------------------------------------
# Optional: PDF support via poppler-qt6
# ---------------------------------------------------------------------------
if(ENGAUGE_PDF)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(POPPLER REQUIRED poppler-qt6)
    target_compile_definitions(engauge PRIVATE ENGAUGE_PDF)
    target_include_directories(engauge PRIVATE ${POPPLER_INCLUDE_DIRS} src/Pdf)
    target_link_libraries(engauge PRIVATE ${POPPLER_LIBRARIES})
    target_link_directories(engauge PRIVATE ${POPPLER_LIBRARY_DIRS})
    target_sources(engauge PRIVATE
        src/Dlg/DlgImportCroppingPdf.cpp
        src/Import/ImportCroppingUtilPdf.cpp
        src/Pdf/Pdf.cpp
        src/Pdf/PdfCropping.cpp
        src/Pdf/PdfFrameHandle.cpp
    )
    message(STATUS "PDF support: enabled (poppler-qt6)")
else()
    message(STATUS "PDF support: disabled")
endif()

# ---------------------------------------------------------------------------
# Optional: log4cpp_null stub (bundled, recommended for most builds)
# ---------------------------------------------------------------------------
if(ENGAUGE_LOG4CPP_NULL)
    target_include_directories(engauge PRIVATE src/log4cpp_null/include)
    target_sources(engauge PRIVATE
        src/log4cpp_null/src/Appender.cpp
        src/log4cpp_null/src/Category.cpp
        src/log4cpp_null/src/CategoryStream.cpp
        src/log4cpp_null/src/Configurator.cpp
        src/log4cpp_null/src/FileAppender.cpp
        src/log4cpp_null/src/Layout.cpp
        src/log4cpp_null/src/LayoutAppender.cpp
        src/log4cpp_null/src/LoggingEvent.cpp
        src/log4cpp_null/src/PatternLayout.cpp
        src/log4cpp_null/src/PropertyConfigurator.cpp
        src/log4cpp_null/src/RollingFileAppender.cpp
    )
    message(STATUS "log4cpp: using bundled null stub")
else()
    find_library(LOG4CPP_LIB log4cpp REQUIRED)
    find_path(LOG4CPP_INCLUDE log4cpp/Category.hh REQUIRED)
    target_include_directories(engauge PRIVATE ${LOG4CPP_INCLUDE})
    target_link_libraries(engauge PRIVATE ${LOG4CPP_LIB})
    message(STATUS "log4cpp: using system library")
endif()

# ---------------------------------------------------------------------------
# FFTW3 (required)
# ---------------------------------------------------------------------------
find_package(PkgConfig REQUIRED)
pkg_check_modules(FFTW3 REQUIRED fftw3)
target_include_directories(engauge PRIVATE ${FFTW3_INCLUDE_DIRS})
target_link_libraries(engauge PRIVATE ${FFTW3_LIBRARIES})
target_link_directories(engauge PRIVATE ${FFTW3_LIBRARY_DIRS})

# ---------------------------------------------------------------------------
# Installation
# ---------------------------------------------------------------------------
install(TARGETS engauge
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
qt_generate_deploy_app_script(
    TARGET engauge
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT ${deploy_script})
