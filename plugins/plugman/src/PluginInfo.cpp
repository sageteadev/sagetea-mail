/* Copyright (C) 2017 Dan Chapman <dpniel@ubuntu.com>

   This file is part of Dekko email client for Ubuntu devices

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License or (at your option) version 3

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
#include "PluginInfo.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonParseError>
#include <QByteArray>
#include <QStringBuilder>

Q_LOGGING_CATEGORY(PLUGIN_INFO, "sageteamail.plugman.info")

PluginInfo::PluginInfo(QObject *parent) : QObject(parent)
{
}


DekkoPlugin::DekkoPlugin(QObject *parent) : PluginInfo(parent)
{
}

DekkoPlugin* DekkoPlugin::fromSpec(const QString &specPath, QObject *parent)
{
    QFile specFile(specPath);
    specFile.open(QFile::ReadOnly);
    QJsonParseError error;
    QJsonDocument p_spec = QJsonDocument().fromJson(specFile.readAll(), &error);
    if (p_spec.isObject()) {
        QJsonObject spec = p_spec.object();
        DekkoPlugin *p = new DekkoPlugin(parent);
        p->setSpec(spec);
        return p;
    } else {
        qCWarning(PLUGIN_INFO) << "Plugin failed to load at >> " << specPath;
        if (!error.errorString().isEmpty()) {
            qCWarning(PLUGIN_INFO) << "Error: " << error.errorString();
        } else {
            qCWarning(PLUGIN_INFO) << "Plugin Spec not a json object!!!!!!!!";
        }
        return Q_NULLPTR;
    }
}

QString DekkoPlugin::pluginId() const
{
    return m_spec.value(QStringLiteral("id")).toString();
}

QString DekkoPlugin::location() const
{
    return m_spec.value(QStringLiteral("register")).toString();
}

QString DekkoPlugin::component()
{
    const QString path = m_pluginPath % "/" % m_spec.value(QStringLiteral("component")).toString();
    if (QFileInfo(path).exists()) {
        return path;
    } else {
        qCWarning(PLUGIN_INFO) << "Failed to find component component: " << path;
        return QString();
    }
}

QString DekkoPlugin::i18n() const
{
    return m_spec.value(QStringLiteral("i18n")).toString();
}

QVariantMap DekkoPlugin::documentation() const
{
    return m_spec.value(QStringLiteral("documentation")).toObject().toVariantMap();
}

QVariantMap DekkoPlugin::settings() const
{
    return m_spec.value(QStringLiteral("settings")).toObject().toVariantMap();
}

QString DekkoPlugin::pluginPath() const
{
    return m_pluginPath;
}

void DekkoPlugin::setSpec(const QJsonObject &spec)
{
    m_spec = spec;
}

void DekkoPlugin::setPluginDirectory(const QString &path)
{
    m_pluginPath = path;
}

ServicePlugin::ServicePlugin(QObject *parent) : PluginInfo(parent)
{
}

void ServicePlugin::messageReceived(const QString &key, const QVariant &value)
{
    Q_UNUSED(key);
    Q_UNUSED(value);
}
