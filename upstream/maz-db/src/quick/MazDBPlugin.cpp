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
#include "MazDBPlugin.h"

#include <QtQml/QtQml>
#include <QtQml/QQmlContext>
#include <MazDB.h>
#include <MazDBBatch.h>
#include <MazDBListModel.h>
#include <MazDBSettings.h>
#include <MazDBSortProxy.h>
#include <MazOptions.h>
#include <MazDBQueryEngine.h>
#include <MazDBQuery.h>

void MazDBPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("MazDB"));
    // @uri MazDB
    qmlRegisterType<MazDB>("MazDB", 1, 0, "MazDB");
    qmlRegisterType<MazDBListModel>("MazDB", 1, 0, "MazDBListModel");
    qmlRegisterType<MazDBSettings>("MazDB", 1, 0, "MazDBSettings");
    qmlRegisterType<MazDBSortProxy>("MazDB", 1, 0, "MazDBSortProxy");
    qmlRegisterType<MazDBQueryEngine>("MazDB", 1, 0, "MazDBQueryEngine");
    qmlRegisterType<MazDBQuery>("MazDB", 1, 0, "MazDBQuery");
    qmlRegisterType<WhereQuery>("MazDB", 1, 0, "WHERE");
    qmlRegisterType<AndQuery>("MazDB", 1, 0, "AND");
    qmlRegisterType<OrQuery>("MazDB", 1, 0, "OR");
    qmlRegisterUncreatableType<MazOptions>("MazDB", 1, 0, "MazOptions", QObject::tr("Cannot create separate instance of Options"));
    qmlRegisterUncreatableType<MazDBBatch>("MazDB", 1, 0, "MazDBBatch", QObject::tr("Cannot create separate instance of Batch"));
    qmlRegisterUncreatableType<QueryBase>("MazDB", 1, 0, "Query", QObject::tr("Cannot create separate instance of QueryBase"));
    qmlRegisterUncreatableType<Range>("MazDB", 1, 0, "Range", QObject::tr("Cannot create separate instance of Range"));
}

void MazDBPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
