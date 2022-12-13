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
#ifndef MAZDBBATCH_H
#define MAZDBBATCH_H

#include <QObject>
#include <QMutex>
#include <QSet>
#include <QScopedPointer>
#include "MazDB.h"
#include "MazUtils.h"

namespace leveldb {
class DB;
class WriteBatch;
}

class MazDBBatch : public QObject
{
    Q_OBJECT
public:
    explicit MazDBBatch(QWeakPointer<leveldb::DB> db, QObject *parent = 0);
    ~MazDBBatch();

    Q_INVOKABLE MazDBBatch *del(const QString &key);
    Q_INVOKABLE MazDBBatch *put(const QString &key, const QVariant &value);
    Q_INVOKABLE MazDBBatch *clear();
    Q_INVOKABLE bool write();

signals:
    void batchWritten(QSet<QString> keys);

private:
    Q_DISABLE_COPY(MazDBBatch)
    QSharedPointer<leveldb::DB> m_leveldb;
    leveldb::WriteBatch *m_batch;
    QSet<QString> m_keys;
    QMutex m_mutex;
};

#endif // MAZDBBATCH_H
