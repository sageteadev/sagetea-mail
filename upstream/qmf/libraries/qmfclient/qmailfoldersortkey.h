/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Messaging Framework.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QMAILFOLDERSORTKEY_H
#define QMAILFOLDERSORTKEY_H

#include "qmailglobal.h"
#include "qmailipc.h"
#include "qmailsortkeyargument.h"
#include <QSharedData>
#include <QtGlobal>

class QMailFolderSortKeyPrivate;

class QMF_EXPORT QMailFolderSortKey
{
public:
    enum Property
    {
        Id,
        Path,
        ParentFolderId,
        ParentAccountId,
        DisplayName,
        Status,
        ServerCount,
        ServerUnreadCount,
        ServerUndiscoveredCount,
    };

    typedef QMailSortKeyArgument<Property> ArgumentType;

public:
    QMailFolderSortKey();
    QMailFolderSortKey(const QMailFolderSortKey& other);
    virtual ~QMailFolderSortKey();

    QMailFolderSortKey operator&(const QMailFolderSortKey& other) const;
    QMailFolderSortKey& operator&=(const QMailFolderSortKey& other);

    bool operator==(const QMailFolderSortKey& other) const;
    bool operator!=(const QMailFolderSortKey& other) const;

    QMailFolderSortKey& operator=(const QMailFolderSortKey& other);

    bool isEmpty() const;

    const QList<ArgumentType> &arguments() const;

    template <typename Stream> void serialize(Stream &stream) const;
    template <typename Stream> void deserialize(Stream &stream);

    void serialize(QDataStream &stream) const;
    void deserialize(QDataStream &stream);

    static QMailFolderSortKey id(Qt::SortOrder order = Qt::AscendingOrder);
    static QMailFolderSortKey path(Qt::SortOrder order = Qt::AscendingOrder);
    static QMailFolderSortKey parentFolderId(Qt::SortOrder order = Qt::AscendingOrder);
    static QMailFolderSortKey parentAccountId(Qt::SortOrder order = Qt::AscendingOrder);
    static QMailFolderSortKey displayName(Qt::SortOrder order = Qt::AscendingOrder);
    static QMailFolderSortKey serverCount(Qt::SortOrder order = Qt::AscendingOrder);
    static QMailFolderSortKey serverUnreadCount(Qt::SortOrder order = Qt::AscendingOrder);
    static QMailFolderSortKey serverUndiscoveredCount(Qt::SortOrder order = Qt::AscendingOrder);

    static QMailFolderSortKey status(quint64 mask, Qt::SortOrder order = Qt::DescendingOrder);

private:
    QMailFolderSortKey(Property p, Qt::SortOrder order, quint64 mask = 0);
    QMailFolderSortKey(const QList<ArgumentType> &args);

    friend class QMailStore;
    friend class QMailStorePrivate;

    QSharedDataPointer<QMailFolderSortKeyPrivate> d;
};

Q_DECLARE_USER_METATYPE(QMailFolderSortKey)

#endif