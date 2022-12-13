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
#include "MazDBQueryEngine.h"
#include <QDebug>
#include "QJsEngineShim.h"

MazDBQueryEngine::MazDBQueryEngine(QObject *parent) : QObject(parent),
    m_db(Q_NULLPTR), m_query(Q_NULLPTR)
{
    m_db = new MazDB(this);
    connect(m_db, &MazDB::filenameChanged, this, &MazDBQueryEngine::sourceChanged);
}

MazDBQuery *MazDBQueryEngine::query() const
{
    return m_query;
}

QString MazDBQueryEngine::source() const
{
    return m_db->filename();
}

bool MazDBQueryEngine::queryStream(MazCallBack callback)
{
    return m_query->runQuery(m_db, callback);
}

bool MazDBQueryEngine::queryStream(QJSValue callback)
{
    if (!callback.isCallable())
        return false;

    MazCallBack func = [this, &callback](QString key, QVariant value) {
        QJSEngine *engine = qjsEngine(this);
        QJSValueList list;
        list << QJSValue(key);
        list << engine->toScriptValue<QVariant>(value);
        bool result = callback.call(list).toBool();
        return result;
    };
    return queryStream(func);
}

void MazDBQueryEngine::setSource(const QString &src)
{
    if (source() != src) {
        m_db->setFilename(src);
    }
}

void MazDBQueryEngine::setQuery(MazDBQuery *query)
{
    if (m_query == query)
        return;

    m_query = query;
    emit queryChanged(query);
}

