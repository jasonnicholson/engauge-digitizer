#include <QApplication>
#include <QDir>
#include <QLibraryInfo>
#include <QSettings>
#include <QTranslator>
#include "Settings.h"
#include "TranslatorContainer.h"

TranslatorContainer::TranslatorContainer(QApplication & /* app */)
{
  QLocale localeDefault;

  QSettings settings (SETTINGS_ENGAUGE, SETTINGS_DIGITIZER);
  settings.beginGroup(SETTINGS_GROUP_MAIN_WINDOW);

  // Restore locale using bcp47 name (e.g. "en_US"). Old integer keys are ignored because
  // QLocale::Language enum was renumbered in Qt6, so Qt5-saved integers map to wrong languages.
  QString localeName = settings.value (SETTINGS_LOCALE_NAME, QString()).toString();
  QLocale locale = localeName.isEmpty() ? localeDefault : QLocale(localeName);
  if (locale.language() == QLocale::AnyLanguage) {
    locale = localeDefault;
  }
  
  settings.endGroup();

  // For some reason, some built-in strings get translated into German by the first call to installTranslator,
  // when the locale is english. So we skip translation for unless user has either
  // 1) default language is not english
  // 2) default language and selected language are not the same
  if ((localeDefault.name().toLower() != "en_us") ||
      (localeDefault.name().toLower() != locale.name().toLower())) {

    QString localeName = locale.name().toLower();

    // Basic translators, like buttons in QWizard
    m_translatorGeneric = new QTranslator;
    if (!m_translatorGeneric->load ("qt_" + localeName,
                                     QLibraryInfo::path (QLibraryInfo::TranslationsPath))) {
      // Translations not found is not fatal — English will be used
    }
    QApplication::installTranslator (m_translatorGeneric);

    // Engauge-specific translators. As documented in engauge.pro, the country-specific engauge_XX_YY locale is loaded
    // if available, otherwise engauge_XX is loaded if available
    //
    // In OSX, QDir::currentPath points to /Users/?/Library/Containers/Digitizer/Data and
    // QCoreApplication::applicationDirPath points to ../Engauge Digitizer.app/Contents/MacOS (which we want)
    QString delimiters ("._");
    m_translatorEngauge = new QTranslator;
    // Handle usual translations like es_es
    bool rtn = m_translatorEngauge->load ("engauge_" + localeName,
                                           qmDirectory(),
                                           delimiters);
    if (!rtn) {
      // Handle country-specific translations like fa_IR. Transifex capitalizes the last two characters
      QString localeNameUpper = QString ("%1%2")
          .arg (localeName.left (localeName.length() - 2))
          .arg (localeName.right (2).toUpper ());
      (void) m_translatorEngauge->load ("engauge_" + localeNameUpper,
                                 qmDirectory(),
                                 delimiters);
    }
    QApplication::installTranslator (m_translatorEngauge);
  }
}

QString TranslatorContainer::qmDirectory()
{
#if defined(OSX_DEBUG) || defined(OSX_RELEASE)
    return QCoreApplication::applicationDirPath () + "/../Resources/translations";
#else
    return QCoreApplication::applicationDirPath () + "/translations";
#endif
}
