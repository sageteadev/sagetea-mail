#include "DekkoWebContextPlugin.h"
#include "DekkoWebContext.h"
#include <QtQml/QtQml>
#include <QtQml/QQmlContext>

void DekkoWebContextPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("Dekko.WebContext"));
    // @uri Dekko.WebContext
    qmlRegisterType<DekkoWebContext>(uri, 1, 0, "DekkoWebContext");
}

void DekkoWebContextPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
