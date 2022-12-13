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
#include "MazDBSettings.h"
#include <SnapStandardPaths.h>
#include <QCoreApplication>
#include "MazDB.h"

MazDBSettings::MazDBSettings(QObject *parent) : QObject(parent),
    m_db(Q_NULLPTR)
{
    m_db = new MazDB(this);
    connect(m_db, &MazDB::keyValueChanged, this, &MazDBSettings::handleKeyValueChanged);
    connect(m_db, &MazDB::filenameChanged, this, &MazDBSettings::init);
    //    connect(m_db, &MazDB::keyValueRemoved, this, &MazDBSettings::handleKeyValueRemoved);
}

QStringList MazDBSettings::allKeys()
{
    QStringList keys;
    m_db->readStream([&keys](QString key, QVariant value) {
        Q_UNUSED(value);
        keys << key;
        return true;
    });
    return keys;
}

bool MazDBSettings::contains(const QString &key)
{
    return allKeys().contains(key);
}

QString MazDBSettings::fileName() const
{
    return m_db->filename();
}

void MazDBSettings::remove(const QString &key)
{
    m_db->del(key);
}

void MazDBSettings::setValue(const QString &key, const QVariant &value)
{
    if (key.isEmpty()) {
        return;
    }
    m_db->put(key, value);
}

QVariant MazDBSettings::value(const QString &key, const QVariant &defaultValue)
{
    return m_db->get(key, defaultValue);
}

void MazDBSettings::close()
{
    m_db->close();
}


void MazDBSettings::classBegin()
{

}

void MazDBSettings::componentComplete()
{
    QString path;
    if (m_category.isEmpty()) {
        path = SnapStandardPaths::writableLocation(SnapStandardPaths::AppConfigLocation) + QStringLiteral("/mazdb/settings.db");
    } else {
        path = SnapStandardPaths::writableLocation(SnapStandardPaths::AppConfigLocation) + QStringLiteral("/mazdb/categories/%1.db").arg(m_category);
    }
    m_db->setFilename(path);
    init();
}

void MazDBSettings::handlePropertyChanged()
{
    if (!m_db->opened())
        return;
    QMetaProperty property = m_propertyHash[senderSignalIndex()];
    QString propertyName = QString::fromLocal8Bit(property.name());
    QVariant value = property.read(this);
    m_db->put(propertyName, value);
}

void MazDBSettings::handleKeyValueChanged(const QString &key, const QVariant &value)
{
    const QMetaObject *ob = metaObject();
    int i = ob->indexOfProperty(key.toLocal8Bit().constData());
    QMetaProperty prop = ob->property(i);
    prop.write(this, value);
}

void MazDBSettings::init()
{
    if (!m_connections.isEmpty()) {
        for(auto c : m_connections) {
            QObject::disconnect(c);
        }
        m_connections.clear();
        m_propertyHash.clear();
    }
    const QMetaObject *m = metaObject();
    for (int i = m->propertyOffset(); i < m->propertyCount(); ++i) {
        auto metaProp = m->property(i);
        if (!metaProp.isWritable()) {
            continue;
        }
        const QVariant storedValue = m_db->get(QString::fromLocal8Bit(metaProp.name()));
        const QVariant oldPropValue = metaProp.read(this);
        if (storedValue.isValid() && storedValue != oldPropValue) {
            metaProp.write(this, storedValue);
        } else if (oldPropValue.isValid()) {
            m_db->put(QString::fromLocal8Bit(metaProp.name()), oldPropValue);
        }
        if (metaProp.hasNotifySignal()) {
            m_propertyHash.insert(metaProp.notifySignalIndex(), metaProp);
            m_connections.append(QMetaObject::connect(this, metaProp.notifySignalIndex(), this, m->indexOfSlot("handlePropertyChanged()")));
        }
    }
}