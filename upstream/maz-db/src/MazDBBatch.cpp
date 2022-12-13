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
#include "MazDBBatch.h"
#include <leveldb/db.h>
#include <leveldb/write_batch.h>
#include <leveldb/options.h>

MazDBBatch::MazDBBatch(QWeakPointer<leveldb::DB> db, QObject *parent) : QObject(parent),
    m_leveldb(db), m_batch(new leveldb::WriteBatch())
{

}

MazDBBatch::~MazDBBatch()
{
    if (m_batch) {
        delete m_batch;
        m_batch = Q_NULLPTR;
    }
}

MazDBBatch *MazDBBatch::del(const QString &key)
{
    m_keys.insert(key);
    QMutexLocker l(&m_mutex);
    m_batch->Delete(leveldb::Slice(key.toStdString()));
    return this;
}

MazDBBatch *MazDBBatch::put(const QString &key, const QVariant &value)
{
    QString json = MazUtils::variantToJson(value);
    m_keys.insert(key);
    QMutexLocker l(&m_mutex);
    m_batch->Put(leveldb::Slice(key.toStdString()),
                 leveldb::Slice(json.toStdString()));
    return this;
}

MazDBBatch *MazDBBatch::clear()
{
    m_keys.clear();
    QMutexLocker l(&m_mutex);
    m_batch->Clear();
    return this;
}

bool MazDBBatch::write()
{
    leveldb::WriteOptions options;
    options.sync = true;
    if(m_leveldb.isNull())
        return static_cast<int>(MazDB::Status::NotFound);
    leveldb::Status status = m_leveldb.data()->Write(options, m_batch);
    if(status.ok()){
        emit batchWritten(m_keys);
    }
    return status.ok();
}

