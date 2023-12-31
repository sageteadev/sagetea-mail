/* Copyright (C) 2016 - 2017 Dan Chapman <dpniel@ubuntu.com>

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
#ifndef MESSAGEBUILDER_H
#define MESSAGEBUILDER_H

#include <QObject>
#include <QmlObjectListModel.h>
#include <QQuickTextDocument>
#include <QTextDocument>
#include <QStringList>
#include <qmailmessage.h>
#include "Attachments.h"
#include "MailAddress.h"
#include "SenderIdentities.h"


class MessageBuilder : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject *to READ to NOTIFY modelsChanged)
    Q_PROPERTY(QObject *cc READ cc NOTIFY modelsChanged)
    Q_PROPERTY(QObject *bcc READ bcc NOTIFY modelsChanged)
    Q_PROPERTY(QObject *attachments READ attachments NOTIFY modelsChanged)
    Q_PROPERTY(QQuickTextDocument *subject READ subject WRITE setSubject NOTIFY subjectChanged)
    Q_PROPERTY(QQuickTextDocument *body READ body WRITE setBody NOTIFY bodyChanged)
    Q_PROPERTY(QObject *identities READ identities WRITE setIdentities NOTIFY identitiesChanged)
    Q_PROPERTY(bool hasDraft READ hasDraft CONSTANT)
    Q_ENUMS(RecipientModels)
public:
    explicit MessageBuilder(QObject *parent = Q_NULLPTR);

    enum RecipientModels { To, Cc, Bcc };
    enum ReplyType { Reply, ReplyAll, ReplyList };
    enum ForwardType { Inline, Attach };

    QObject *to() const { return m_to; }
    QObject *cc() const { return m_cc; }
    QObject *bcc() const {return m_bcc; }
    QObject *attachments() const { return m_attachments; }

    QQuickTextDocument *subject() const;
    QQuickTextDocument *body() const;
    QMailMessage message();

    bool hasRecipients() { return !m_to->isEmpty(); }
    bool hasIdentities() { return !m_identities->isEmpty(); }
    int selectedIdentity() { return m_identities->selectedIndex(); }
    QObject *identities() const;
    QMailMessageId lastDraftId() const {return m_lastDraftId;}
    void setLastDraftId(const QMailMessageId &id);

    bool hasDraft() { return m_lastDraftId.isValid(); }

    void buildResponse(const ReplyType &type, const QMailMessage &src);
    void buildForward(const ForwardType &type, const QMailMessage &src);
    Q_INVOKABLE void composeMailTo(const QString &mailtoUri);
    void reloadLastDraftId();

signals:
    void modelsChanged();
    void subjectChanged(QQuickTextDocument *subject);
    void bodyChanged(QQuickTextDocument *body);
    void identitiesChanged();
    void maybeStartSaveTimer();

public slots:
    void addRecipient(const RecipientModels which, const QString &emailAddress);
    void addRecipient(const RecipientModels which, const QString &name, const QString &address);
    void addRecipients(const RecipientModels which, const QMailAddressList &addresses);
    void removeRecipient(const RecipientModels which, const int &index);
    void addFileAttachment(const QString &file);
    void addFileAttachments(const QStringList &files);
    void appendTextToSubject(const QString &text);
    void appendTextToBody(const QString &text);
    // TODO: inline/attached messages and messageparts

    void removeAttachment(const int &index);
    void reset();
    void setSubject(QQuickTextDocument *subject);

    void setBody(QQuickTextDocument *body);
    void setIdentities(QObject *identities);

protected:
    void buildRecipientsLists(const ReplyType &type, const QMailMessage &src);

private slots:
    void subjectChanged(int position, int charsRemoved, int charsAdded);
    void bodyChanged(int position, int charsRemoved, int charsAdded);

private:
    enum Mode { New, Rply, Fwd };
    QQmlObjectListModel<MailAddress> *m_to;
    QQmlObjectListModel<MailAddress> *m_cc;
    QQmlObjectListModel<MailAddress> *m_bcc;
    QQmlObjectListModel<Attachment> *m_attachments;
    QQuickTextDocument *m_subject;
    QTextDocument *m_internalSubject;
    QQuickTextDocument *m_body;
    QTextDocument *m_internalBody;
    SenderIdentities *m_identities;
    quint64 m_sourceStatus;
    QMailMessageId m_lastDraftId;
    QMailMessageId m_srcMessageId;
    Mode m_mode;
    ReplyType m_replyType;

    QByteArray getListPostAddress(const QMailMessage &src);
    void setSubjectText(const QString &text);
    void setBodyText(const QString &body);

};



#endif // MESSAGEBUILDER_H
