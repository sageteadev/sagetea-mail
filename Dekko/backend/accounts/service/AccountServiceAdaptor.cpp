/*
 * This file was generated by qdbusxml2cpp version 0.8
 * Command line was: qdbusxml2cpp /home/dan/dekko/Dekko/backend/accounts/service/dbus/account_service.xml -N -a AccountServiceAdaptor -c AccountServiceAdaptor
 *
 * qdbusxml2cpp is Copyright (C) 2016 The Qt Company Ltd.
 *
 * This is an auto-generated file.
 * Do not edit! All changes made to it will be lost.
 */

#include "AccountServiceAdaptor.h"
#include <QtCore/QMetaObject>
#include <QtCore/QByteArray>
#include <QtCore/QList>
#include <QtCore/QMap>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QVariant>

/*
 * Implementation of adaptor class AccountServiceAdaptor
 */

AccountServiceAdaptor::AccountServiceAdaptor(QObject *parent)
    : QDBusAbstractAdaptor(parent)
{
    // constructor
    setAutoRelaySignals(true);
}

AccountServiceAdaptor::~AccountServiceAdaptor()
{
    // destructor
}

QList<quint64> AccountServiceAdaptor::queryAccounts(const QByteArray &accountKey, const QByteArray &sortKey, int limit)
{
    // handle method call org.dekkoproject.AccountService.queryAccounts
    QList<quint64> accounts;
    QMetaObject::invokeMethod(parent(), "queryAccounts", Q_RETURN_ARG(QList<quint64>, accounts), Q_ARG(QByteArray, accountKey), Q_ARG(QByteArray, sortKey), Q_ARG(int, limit));
    return accounts;
}

void AccountServiceAdaptor::removeAccount(qulonglong id)
{
    // handle method call org.dekkoproject.AccountService.removeAccount
    QMetaObject::invokeMethod(parent(), "removeAccount", Q_ARG(qulonglong, id));
}
