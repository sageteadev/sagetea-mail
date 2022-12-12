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
#ifndef MAZDBQUERYENGINE_H
#define MAZDBQUERYENGINE_H

#include <QObject>
#include <QQmlEngine>
#include <QJSEngine>
#include <QStringList>
#include <QQmlParserStatus>
#include <QJSValue>
#include "MazDBQuery.h"

class MazDBQueryEngine : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(MazDBQuery* query READ query WRITE setQuery NOTIFY queryChanged)
public:
    explicit MazDBQueryEngine(QObject *parent = 0);

    MazDBQuery* query() const;
    QString source() const;

    bool queryStream(MazCallBack callback);
    Q_INVOKABLE bool queryStream(QJSValue callback);

signals:
    void queryChanged(MazDBQuery* query);
    void sourceChanged();

public slots:
    void setSource(const QString &src);
    void setQuery(MazDBQuery* query);
    void close() { m_db->close(); }

protected:
    virtual void classBegin() override {}
    virtual void componentComplete() override { }

private:
    Q_DISABLE_COPY(MazDBQueryEngine)

    MazDB *m_db;
    MazDBQuery* m_query;
};

#endif // MAZDBQUERYENGINE_H
