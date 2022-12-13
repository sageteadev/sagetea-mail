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
#ifndef MAZDBSETTINGS_H
#define MAZDBSETTINGS_H

#include <QObject>
#include <QMetaObject>
#include <QMetaProperty>
#include <QHash>
#include <QQmlParserStatus>

class MazDB;

typedef QList<QMetaObject::Connection> ConnectionList;

class MazDBSettings : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    // Emulates the category property from qt.labs.Settings but internally
    // it creates a new leveldb for the given category.
    Q_PROPERTY(QString category MEMBER m_category)
public:
    explicit MazDBSettings(QObject *parent = 0);

    QStringList allKeys();
    bool contains(const QString &key);
    Q_INVOKABLE QString fileName() const;
    void remove(const QString &key);
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant());
    Q_INVOKABLE void close();

protected:
    virtual void classBegin() override;
    virtual void componentComplete() override;

private slots:
    void handlePropertyChanged();
    void handleKeyValueChanged(const QString &key, const QVariant &value);
    void init();
private:
    Q_DISABLE_COPY(MazDBSettings)

    MazDB *m_db;
    ConnectionList m_connections;
    QHash<int, QMetaProperty> m_propertyHash;
    QString m_category;
};

#endif // MAZDBSETTINGS_H
