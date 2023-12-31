/*
 * This file was generated by qdbusxml2cpp version 0.8
 * Command line was: qdbusxml2cpp /home/dan/dekko/Dekko/backend/accounts/service/dbus/account_service.xml -N -p AccountServiceInterface -c AccountServiceInterface
 *
 * qdbusxml2cpp is Copyright (C) 2016 The Qt Company Ltd.
 *
 * This is an auto-generated file.
 * Do not edit! All changes made to it will be lost.
 */

#ifndef ACCOUNTSERVICEINTERFACE_H
#define ACCOUNTSERVICEINTERFACE_H

#include <QtCore/QObject>
#include <QtCore/QByteArray>
#include <QtCore/QList>
#include <QtCore/QMap>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QVariant>
#include <QtDBus/QtDBus>

/*
 * Proxy class for interface org.dekkoproject.AccountService
 */
class AccountServiceInterface: public QDBusAbstractInterface
{
    Q_OBJECT
public:
    static inline const char *staticInterfaceName()
    { return "org.sagetea.AccountService"; }

public:
    AccountServiceInterface(const QString &service, const QString &path, const QDBusConnection &connection, QObject *parent = 0);

    ~AccountServiceInterface();

public Q_SLOTS: // METHODS
    inline QDBusPendingReply<QList<quint64> > queryAccounts(const QByteArray &accountKey, const QByteArray &sortKey, int limit)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(accountKey) << QVariant::fromValue(sortKey) << QVariant::fromValue(limit);
        return asyncCallWithArgumentList(QStringLiteral("queryAccounts"), argumentList);
    }

    inline QDBusPendingReply<> removeAccount(qulonglong id)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(id);
        return asyncCallWithArgumentList(QStringLiteral("removeAccount"), argumentList);
    }

Q_SIGNALS: // SIGNALS
    void accountRemoved(qulonglong id);
};

#endif
