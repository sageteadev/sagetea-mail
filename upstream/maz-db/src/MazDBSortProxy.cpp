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
#include "MazDBSortProxy.h"
#include <QDebug>
#include "MazDBListModel.h"
#include "QJsEngineShim.h"

MazDBSortProxy::MazDBSortProxy(QObject *parent) : QSortFilterProxyModel(parent),
    m_sortOrder(Qt::AscendingOrder)
{
    setDynamicSortFilter(true);
    sort(0, m_sortOrder);
}

QHash<int, QByteArray> MazDBSortProxy::roleNames() const
{
    return sourceModel() ? sourceModel()->roleNames() : QHash<int, QByteArray>();
}

QString MazDBSortProxy::sortBy() const
{
    return m_sortBy;
}

QJSValue MazDBSortProxy::sortCallBack() const
{
    return m_sortCallBack;
}

void MazDBSortProxy::setModel(QAbstractItemModel *model)
{
    if (sourceModel() == model)
        return;

    setSourceModel(model);
    reload();
    emit modelChanged();
}

void MazDBSortProxy::setSortBy(QString sortBy)
{
    if (m_sortBy == sortBy)
        return;

    m_sortBy = sortBy;
    setSortRole(roleFromName(m_sortBy));
    emit sortByChanged(sortBy);
    reload();
}

void MazDBSortProxy::setSortOrder(Qt::SortOrder order)
{
    if (m_sortOrder != order) {
        m_sortOrder = order;
        sort(0, m_sortOrder);
        emit sortOrderChanged();
    }
    reload();
}

void MazDBSortProxy::setSortCallBack(QJSValue sortCallBack)
{
    m_sortCallBack = sortCallBack;
    reload();
    emit sortCallBackChanged(sortCallBack);
}

bool MazDBSortProxy::lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const
{
    if (m_sortCallBack.isCallable()) {
        QVariant leftData = sourceModel()->data(source_left, roleFromName(m_sortBy));
        QVariant rightData = sourceModel()->data(source_right, roleFromName(m_sortBy));
        QJSEngine *engine = qjsEngine(this);

        return const_cast<QJSValue *>(&m_sortCallBack)->call(
                    QJSValueList()
                    << engine->toScriptValue<QVariant>(leftData)
                    << engine->toScriptValue<QVariant>(rightData)
                    ).toBool();
    } else {
        return QSortFilterProxyModel::lessThan(source_left, source_right);
    }
}

void MazDBSortProxy::reload()
{
    invalidate();
    setSortRole(roleFromName(m_sortBy));
    sort(0, m_sortOrder);
}

int MazDBSortProxy::roleFromName(const QString &role) const
{
    if (!sourceModel()) {
        return 0;
    }
    const QByteArray roleName = role.toUtf8();
    const QHash<int, QByteArray> roles = sourceModel()->roleNames();
    QHashIterator<int, QByteArray> i(roles);
    while (i.hasNext()) {
        i.next();
        if (i.value() == roleName)
            return i.key();
    }
    return 0;
}