#include "dekkodserviceplugin.h"
#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QProcess>
#include <QRegExp>
#include <QSettings>
#include <SnapStandardPaths.h>

DekkodService::DekkodService(QObject *parent): ServicePlugin(parent)
{
    m_service = QStringLiteral("dekkod");
    m_serviceFile = QString("%1/.config/upstart/%2.conf").arg(QDir::homePath(), m_service);
}

QString DekkodService::pluginId() const
{
    return QStringLiteral("dekkod-service");
}

QString DekkodService::location() const
{
    return QStringLiteral("Dekko::Service");
}

QString DekkodService::i18n() const
{
    return QString();
}

void DekkodService::start()
{
    if (newVersion()) {
        qDebug() << "[DekkodService] Stopping service for version upgrade";
        stopService();
    }

    if (!serviceRunning()) {
        // The service is started on login, so actually it should already be running.
        // Overwrite service file to make sure thats not causing the problem.
        // see also issue #114
        qDebug() << "[DekkodService] Installing service file";
        installServiceFile();

        qDebug() << "[DekkodService] Starting dekkod service";
        startService();
    }
}

void DekkodService::stop()
{
//    if (serviceRunning()) {
//        stopService();
//    }

//    if (serviceFileInstalled()) {
//        removeServiceFile();
//    }
}

bool DekkodService::serviceFileInstalled() const
{
    return QFile(m_serviceFile).exists();
}

bool DekkodService::installServiceFile() const
{
    QFile f(m_serviceFile);
    if (!f.open(QFile::WriteOnly | QFile::Truncate)) {
        qDebug() << "[DekkodService] Cannot create service file";
        return false;
    }

    QString appDir = QCoreApplication::applicationDirPath();
    appDir.replace(QRegExp("dekko2.dekkoproject/[^/]+/"), "dekko2.dekkoproject/current/");
    f.write("start on started unity8\n");
    f.write("pre-start script\n");
    f.write("   initctl set-env LD_LIBRARY_PATH=" + appDir.toUtf8() + "/../:$LD_LIBRARY_PATH\n");
    f.write("   initctl set-env DEKKO_PLUGINS=" + appDir.toUtf8() + "/../Dekko/plugins\n");
    f.write("   initctl set-env QMF_PLUGINS=" + appDir.toUtf8() + "/../qmf/plugins5\n");
    f.write("   initctl set-env QMF_DATA=$HOME/.cache/dekko2.dekkoproject\n");
    f.write("end script\n");
    f.write("exec " + appDir.toUtf8() + "/" + m_service.toUtf8() + "\n");
    f.close();
    return true;
}

bool DekkodService::removeServiceFile() const
{
    if (serviceFileInstalled()) {
        return QFile(m_serviceFile).remove();
    }
    return true;
}

bool DekkodService::serviceRunning() const
{
    QProcess p;
    p.start("initctl", {"status", m_service});
    p.waitForFinished();
    QByteArray output = p.readAll();
    qDebug() << output;
    return output.contains("running");
}

bool DekkodService::startService()
{
    qDebug() << "[DekkodService] should start service";
    int ret = QProcess::execute("start", {m_service});
    return ret == 0;
}

bool DekkodService::restartService()
{
    qDebug() << "[DekkodService] should restart service";
    int ret = QProcess::execute("restart", {m_service});
    return ret == 0;
}

bool DekkodService::stopService()
{
    qDebug() << "[DekkodService] should stop service";
    int ret = QProcess::execute("stop", {m_service});
    return ret == 0;
}

bool DekkodService::newVersion()
{
    static const QString path = SnapStandardPaths::writableLocation(SnapStandardPaths::AppConfigLocation) + QStringLiteral("/dekkod/settings.ini");
    QSettings settings(path, QSettings::IniFormat);
    if (!settings.contains(QStringLiteral("version"))) {
        settings.setValue(QStringLiteral("version"), QStringLiteral(DEKKO_VERSION));
        // Dekkod may already be running as we previously didn't version it.
        // So we still need to stop it if running.
        return serviceRunning();
    }

    // We also want to support downgrades so just check the version doesn't match DEKKO_VERSION
    const bool result = settings.value(QStringLiteral("version")).toString() != QStringLiteral(DEKKO_VERSION);
    if (result) {
        settings.setValue(QStringLiteral("version"), QStringLiteral(DEKKO_VERSION));
    }
    settings.sync();
    return result;
}

QVariantMap DekkodService::documentation() const
{
    return QVariantMap();
}

QString DekkodServicePlugin::name() const
{
    return QStringLiteral("dekkod-service");
}

QString DekkodServicePlugin::description() const
{
    return QStringLiteral("Dekko's messaging server");
}

PluginInfo *DekkodServicePlugin::create(QObject *parent) const
{
    return new DekkodService(parent);
}


