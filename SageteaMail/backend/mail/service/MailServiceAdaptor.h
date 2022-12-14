/*
 * This file was generated by qdbusxml2cpp version 0.8
 * Command line was: qdbusxml2cpp /home/dan/dekko/Dekko/backend/mail/service/dbus/service_worker.xml -N -a MailServiceAdaptor -c MailServiceAdaptor
 *
 * qdbusxml2cpp is Copyright (C) 2016 The Qt Company Ltd.
 *
 * This is an auto-generated file.
 * This file may have been hand-edited. Look for HAND-EDIT comments
 * before re-generating it.
 */

#ifndef MAILSERVICEADAPTOR_H
#define MAILSERVICEADAPTOR_H

#include <QtCore/QObject>
#include <QtDBus/QtDBus>
QT_BEGIN_NAMESPACE
class QByteArray;
template<class T> class QList;
template<class Key, class Value> class QMap;
class QString;
class QStringList;
class QVariant;
QT_END_NAMESPACE

/*
 * Adaptor class for interface org.dekkoproject.MailService
 */
class MailServiceAdaptor: public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.sagetea.MailService")
    Q_CLASSINFO("D-Bus Introspection", ""
"  <interface name=\"org.sagetea.MailService\">\n"
"    <property access=\"read\" type=\"b\" name=\"hasUndoableAction\"/>\n"
"    <property access=\"read\" type=\"s\" name=\"undoDescription\"/>\n"
"    <signal name=\"undoCountChanged\"/>\n"
"    <signal name=\"updatesRolledBack\"/>\n"
"    <signal name=\"queueChanged\"/>\n"
"    <signal name=\"messageRestored\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"msgId\"/>\n"
"    </signal>\n"
"    <signal name=\"messagePartNowAvailable\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"msgId\"/>\n"
"      <arg direction=\"out\" type=\"s\" name=\"partLocation\"/>\n"
"    </signal>\n"
"    <signal name=\"messagePartFetchFailed\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"msgId\"/>\n"
"      <arg direction=\"out\" type=\"s\" name=\"partLocation\"/>\n"
"    </signal>\n"
"    <signal name=\"messagesNowAvailable\">\n"
"      <arg direction=\"out\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </signal>\n"
"    <signal name=\"messageFetchFailed\">\n"
"      <arg direction=\"out\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </signal>\n"
"    <signal name=\"messagesSent\">\n"
"      <arg direction=\"out\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </signal>\n"
"    <signal name=\"messageSendingFailed\">\n"
"      <arg direction=\"out\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <arg direction=\"out\" type=\"i\" name=\"error\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </signal>\n"
"    <signal name=\"accountSynced\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"id\"/>\n"
"    </signal>\n"
"    <signal name=\"foldersSynced\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"accountId\"/>\n"
"      <arg direction=\"out\" type=\"(iiii)\" name=\"folderIds\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In1\"/>\n"
"    </signal>\n"
"    <signal name=\"foldersSyncFailed\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"accountId\"/>\n"
"      <arg direction=\"out\" type=\"(iiii)\" name=\"folderIds\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In1\"/>\n"
"    </signal>\n"
"    <signal name=\"syncAccountFailed\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"id\"/>\n"
"    </signal>\n"
"    <signal name=\"clientError\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"accountId\"/>\n"
"      <arg direction=\"out\" type=\"i\" name=\"error\"/>\n"
"      <arg direction=\"out\" type=\"s\" name=\"errorString\"/>\n"
"    </signal>\n"
"    <signal name=\"standardFoldersCreated\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"accountId\"/>\n"
"      <arg direction=\"out\" type=\"b\" name=\"created\"/>\n"
"    </signal>\n"
"    <signal name=\"actionFailed\">\n"
"      <arg direction=\"out\" type=\"t\" name=\"id\"/>\n"
"      <arg direction=\"out\" type=\"i\" name=\"statusCode\"/>\n"
"      <arg direction=\"out\" type=\"s\" name=\"statusText\"/>\n"
"    </signal>\n"
"    <method name=\"restoreMessage\">\n"
"      <arg direction=\"in\" type=\"t\" name=\"id\"/>\n"
"    </method>\n"
"    <method name=\"deleteMessages\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"ids\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"markMessagesImportant\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <arg direction=\"in\" type=\"b\" name=\"important\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"markMessagesRead\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <arg direction=\"in\" type=\"b\" name=\"read\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"markMessagesTodo\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <arg direction=\"in\" type=\"b\" name=\"read\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"markMessagesDone\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <arg direction=\"in\" type=\"b\" name=\"done\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"markMessagesReplied\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <arg direction=\"in\" type=\"b\" name=\"all\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"markMessageForwarded\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"syncFolders\">\n"
"      <arg direction=\"in\" type=\"t\" name=\"accountId\"/>\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"folders\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In1\"/>\n"
"    </method>\n"
"    <method name=\"createStandardFolders\">\n"
"      <arg direction=\"in\" type=\"t\" name=\"accountId\"/>\n"
"    </method>\n"
"    <method name=\"moveToFolder\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <arg direction=\"in\" type=\"t\" name=\"folderId\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"moveToStandardFolder\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <arg direction=\"in\" type=\"i\" name=\"folderType\"/>\n"
"      <arg direction=\"in\" type=\"b\" name=\"userTriggered\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"markFolderRead\">\n"
"      <arg direction=\"in\" type=\"t\" name=\"folderId\"/>\n"
"    </method>\n"
"    <method name=\"downloadMessagePart\">\n"
"      <arg direction=\"in\" type=\"t\" name=\"msgId\"/>\n"
"      <arg direction=\"in\" type=\"s\" name=\"partLocation\"/>\n"
"    </method>\n"
"    <method name=\"downloadMessages\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"sendMessage\">\n"
"      <arg direction=\"in\" type=\"t\" name=\"msgId\"/>\n"
"    </method>\n"
"    <method name=\"sendPendingMessages\"/>\n"
"    <method name=\"synchronizeAccount\">\n"
"      <arg direction=\"in\" type=\"t\" name=\"accountId\"/>\n"
"    </method>\n"
"    <method name=\"undoActions\"/>\n"
"    <method name=\"sendAnyQueuedMail\"/>\n"
"    <method name=\"emptyTrash\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"accountIds\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"    <method name=\"removeMessage\">\n"
"      <arg direction=\"in\" type=\"t\" name=\"msgId\"/>\n"
"      <arg direction=\"in\" type=\"i\" name=\"option\"/>\n"
"    </method>\n"
"    <method name=\"queryMessages\">\n"
"      <arg direction=\"in\" type=\"ay\" name=\"msgKey\"/>\n"
"      <arg direction=\"in\" type=\"ay\" name=\"sortKey\"/>\n"
"      <arg direction=\"in\" type=\"i\" name=\"limit\"/>\n"
"      <arg direction=\"out\" type=\"(iiii)\" name=\"messages\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.Out0\"/>\n"
"    </method>\n"
"    <method name=\"queryFolders\">\n"
"      <arg direction=\"in\" type=\"ay\" name=\"folderKey\"/>\n"
"      <arg direction=\"in\" type=\"ay\" name=\"sortKey\"/>\n"
"      <arg direction=\"in\" type=\"i\" name=\"limit\"/>\n"
"      <arg direction=\"out\" type=\"(iiii)\" name=\"folders\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.Out0\"/>\n"
"    </method>\n"
"    <method name=\"totalCount\">\n"
"      <arg direction=\"in\" type=\"ay\" name=\"msgKey\"/>\n"
"      <arg direction=\"out\" type=\"i\" name=\"count\"/>\n"
"    </method>\n"
"    <method name=\"pruneCache\">\n"
"      <arg direction=\"in\" type=\"(iiii)\" name=\"msgIds\"/>\n"
"      <annotation value=\"QList&lt;quint64&gt;\" name=\"org.qtproject.QtDBus.QtTypeName.In0\"/>\n"
"    </method>\n"
"  </interface>\n"
        "")
public:
    MailServiceAdaptor(QObject *parent);
    virtual ~MailServiceAdaptor();

public: // PROPERTIES
    Q_PROPERTY(bool hasUndoableAction READ hasUndoableAction)
    bool hasUndoableAction() const;

    Q_PROPERTY(QString undoDescription READ undoDescription)
    QString undoDescription() const;

public Q_SLOTS: // METHODS
    void createStandardFolders(qulonglong accountId);
    void deleteMessages(const QList<quint64> &ids);
    void downloadMessagePart(qulonglong msgId, const QString &partLocation);
    void downloadMessages(const QList<quint64> &msgIds);
    void emptyTrash(const QList<quint64> &accountIds);
    void markFolderRead(qulonglong folderId);
    void markMessageForwarded(const QList<quint64> &msgIds);
    void markMessagesDone(const QList<quint64> &msgIds, bool done);
    void markMessagesImportant(const QList<quint64> &msgIds, bool important);
    void markMessagesRead(const QList<quint64> &msgIds, bool read);
    void markMessagesReplied(const QList<quint64> &msgIds, bool all);
    void markMessagesTodo(const QList<quint64> &msgIds, bool read);
    void moveToFolder(const QList<quint64> &msgIds, qulonglong folderId);
    void moveToStandardFolder(const QList<quint64> &msgIds, int folderType, bool userTriggered);
    void pruneCache(const QList<quint64> &msgIds);
    QList<quint64> queryFolders(const QByteArray &folderKey, const QByteArray &sortKey, int limit);
    QList<quint64> queryMessages(const QByteArray &msgKey, const QByteArray &sortKey, int limit);
    void removeMessage(qulonglong msgId, int option);
    void restoreMessage(qulonglong id);
    void sendAnyQueuedMail();
    void sendMessage(qulonglong msgId);
    void sendPendingMessages();
    void syncFolders(qulonglong accountId, const QList<quint64> &folders);
    void synchronizeAccount(qulonglong accountId);
    int totalCount(const QByteArray &msgKey);
    void undoActions();
Q_SIGNALS: // SIGNALS
    void accountSynced(qulonglong id);
    void actionFailed(qulonglong id, int statusCode, const QString &statusText);
    void clientError(qulonglong accountId, int error, const QString &errorString);
    void messageFetchFailed(const QList<quint64> &msgIds);
    void messagePartFetchFailed(qulonglong msgId, const QString &partLocation);
    void messagePartNowAvailable(qulonglong msgId, const QString &partLocation);
    void messageRestored(qulonglong msgId);
    void messageSendingFailed(const QList<quint64> &msgIds, int error);
    void messagesNowAvailable(const QList<quint64> &msgIds);
    void messagesSent(const QList<quint64> &msgIds);
    void queueChanged();
    void standardFoldersCreated(qulonglong accountId, bool created);
    void syncAccountFailed(qulonglong id);
    void undoCountChanged();
    void updatesRolledBack();
    void foldersSynced(const qulonglong accountId, const QList<quint64> &folderIds);
    void foldersSyncFailed(const qulonglong accountId, const QList<quint64> &folderIds);
};

#endif
