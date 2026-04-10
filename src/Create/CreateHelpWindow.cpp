/******************************************************************************************************
 * (C) 2018 markummitchell@github.com. This file is part of Engauge Digitizer, which is released      *
 * under GNU General Public License version 2 (GPLv2) or (at your option) any later version. See file *
 * LICENSE or go to gnu.org/licenses for details. Distribution requires prior written permission.     *
 ******************************************************************************************************/

#include "CreateHelpWindow.h"
#include "Logger.h"
#include "MainWindow.h"

CreateHelpWindow::CreateHelpWindow()
{
}

void CreateHelpWindow::create (MainWindow &)
{
  LOG4CPP_INFO_S ((*mainCat)) << "CreateHelpWindow::create";
  // Help is now served via the online Sphinx documentation site.
  // The Help action opens a browser URL; no embedded QHelpEngine dock widget is used.
}

