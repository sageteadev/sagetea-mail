#include "quickflux_plugin.h"
#include <QtQml/QtQml>
#include <QtQml/QQmlContext>
#include "QuickFlux"
#include "qfappdispatcher.h"
#include "qfapplistener.h"
#include "qfappscript.h"
#include "qfapplistenergroup.h"
#include "qfappscriptgroup.h"
#include "priv/qfappscriptrunnable.h"
#include "qffilter.h"
#include "qfkeytable.h"
#include "qfactioncreator.h"

static QObject *appDispatcherProvider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    QFAppDispatcher* object = new QFAppDispatcher();
    object->setEngine(engine);

    return object;
}

void QuickFluxPlugin::registerTypes(const char *uri)
{
    registerQuickFluxQmlTypes();
}

void QuickFluxPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
