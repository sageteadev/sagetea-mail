/**************************************************************************
   Copyright (C) 2016 Dan Chapman <dpniel@ubuntu.com>

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
**************************************************************************/
#ifndef UOAPLUGINFACTORY_H
#define UOAPLUGINFACTORY_H

#include <QObject>
#include <QMap>
#include <QSharedPointer>
#include <qmailpluginmanager.h>
#include "UOAService.h"

typedef QMap<QString, UOAService*> UOAPlugins;

class UOAPluginLoader;
class QMF_EXPORT UOAPluginFactory : public QObject
{
    Q_OBJECT
public:
    static QSharedPointer<UOAPluginFactory> instance();
    QStringList services();
    UOAService *createService(const QString &service, const quint32 &accountId);

private:
    UOAPluginLoader *m_loader;
};

class QMF_EXPORT UOAPluginLoader : public QObject
{
    Q_OBJECT
public:
    explicit UOAPluginLoader(QObject *parent = 0):
        QObject(parent), m_pluginMgr("uoa"), m_loaded(false){}

    UOAPlugins uoaPlugins();
    UOAService *get(const QString &service);
    bool loaded() const { return m_loaded; }

public slots:
    void loadPlugins();

private:
    QMailPluginManager m_pluginMgr;
    UOAPlugins m_plugins;
    bool m_loaded;
};

#endif // UOAPLUGINFACTORY_H
