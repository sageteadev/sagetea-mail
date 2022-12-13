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
#ifndef MAZDBSORTPROXY_H
#define MAZDBSORTPROXY_H

#include <QObject>
#include <QAbstractItemModel>
#include <QSortFilterProxyModel>
#include <QJSValue>

class MazDBListModel;
class MazDBSortProxy : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel* model READ sourceModel WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(QString sortBy READ sortBy WRITE setSortBy NOTIFY sortByChanged)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder NOTIFY sortOrderChanged)
    Q_PROPERTY(QJSValue sortCallBack READ sortCallBack WRITE setSortCallBack NOTIFY sortCallBackChanged)

public:
    explicit MazDBSortProxy(QObject *parent = 0);
    virtual QHash<int, QByteArray> roleNames() const override;

    QString sortBy() const;

    QJSValue sortCallBack() const;

signals:
    void modelChanged();
    void sortByChanged(QString sortBy);
    void sortOrderChanged();

    void sortCallBackChanged(QJSValue sortCallBack);

public slots:
    void setModel(QAbstractItemModel* model);
    void setSortBy(QString sortBy);
    void setSortOrder(Qt::SortOrder order);
    void setSortCallBack(QJSValue sortCallBack);

protected:
    virtual bool lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const override;

private:
    void reload();
    int roleFromName(const QString &role) const;
    QString m_sortBy;
    Qt::SortOrder m_sortOrder;
    QJSValue m_sortCallBack;
};

#endif // MAZDBSORTPROXY_H
