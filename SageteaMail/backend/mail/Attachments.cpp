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
#include "Attachments.h"
#include <QDebug>
#include <QtQml>
#include <QFile>
#include <QFileInfo>
#include <QQmlEngine>
#include <QUrlQuery>
#include <QNetworkRequest>
#include <QMimeDatabase>
#include <qmailaccount.h>
#include <qmailnamespace.h>
#include <MailServiceClient.h>
#include <Paths.h>

Attachments::Attachments(QObject *parent) : QObject(parent),
    m_model(0)
{
    m_model = new QQmlObjectListModel<Attachment>(this);
    emit modelChanged();
}

void Attachments::setMessageId(const QMailMessageId &id)
{
    m_id = id;
    QMailMessage msg(m_id);

    Q_FOREACH(auto pLocation, msg.findAttachmentLocations()) {
        Attachment *a = new Attachment(0);
        a->init(m_id, pLocation);
        qDebug() << "Attachment name: " << a->displayName();
        qDebug() << "Attachment size: " << a->size();
        m_model->append(a);
    }
}

Attachment::Attachment(QObject *parent) : QObject(parent),
    m_type(Text), m_fetching(false), m_qnam(0), m_reply(0), m_hasRefs(false)
{
}

Attachment::Attachment(QObject *parent, const QString &attachment, const Attachment::PartType &partType, const Attachment::Disposition &disposition):
    QObject(parent), m_fetching(false), m_partType(partType), m_disposition(disposition), m_hasRefs(false)
{
    switch(partType) {
    case Message:
    {
        const QMailMessageId mid(attachment.toULongLong());
        const QMailMessage msg(mid);
        QMailAccount srcAccount(msg.parentAccountId());
        bool viaReference((srcAccount.status() & QMailAccount::CanReferenceExternalData) &&
                                  (srcAccount.status() & QMailAccount::CanTransmitViaReference));
//        QMailMessageContentType cType;
//        if (msg.multipartType() == QMailMessage::MultipartNone) {
//            cType = msg.contentType();
//        } else {
//            // wrap the message in a rfc822
//            cType =
//        }
        QMailMessageContentType cType(QByteArrayLiteral("message/rfc822"));
        QMailMessageContentDisposition d(QMailMessageContentDisposition::Attachment);
        d.setFilename(msg.subject().simplified().toUtf8() + QByteArrayLiteral(".eml"));
        d.setSize(msg.size());
        if (viaReference) {
            m_part = QMailMessagePart::fromMessageReference(msg.id(), d, cType, msg.transferEncoding());
            m_hasRefs = true;
        } else {
            m_part = QMailMessagePart::fromData(msg.toRfc2822(), d, cType, msg.transferEncoding());
        }
        break;
    }
    case MessagePart:
    {
        QMailMessagePart::Location location(attachment);
        const QMailMessage msg(location.containingMessageId());
        const QMailMessagePart &existingPart(msg.partAt(location));
        QMailMessageContentDisposition existingDisposition(existingPart.contentDisposition());

        QMailMessageContentDisposition d(disposition == Inline ? QMailMessageContentDisposition::Inline : QMailMessageContentDisposition::Attachment);
        d.setFilename(existingDisposition.filename());
        d.setSize(existingDisposition.size());
        m_part = QMailMessagePart::fromPartReference(existingPart.location(), d, existingPart.contentType(), existingPart.transferEncoding());
        break;
    }
    case File:
        QFileInfo fi(attachment);
        QString partName(fi.fileName());
        QString filePath(fi.absoluteFilePath());

        QString mimeType(QMail::mimeTypeFromFileName(attachment));
        QMailMessageContentType type(mimeType.toLatin1());
        type.setName(partName.toLatin1());

        QMailMessageContentDisposition d(disposition == Inline ? QMailMessageContentDisposition::Inline : QMailMessageContentDisposition::Attachment);
        d.setFilename(partName.toLatin1());
        d.setSize(fi.size());

        QMailMessageBodyFwd::TransferEncoding encoding(QMailMessageBody::Base64);
        QMailMessageBodyFwd::EncodingStatus encodingStatus(QMailMessageBody::RequiresEncoding);
        if (mimeType == "message/rfc822") {
            encoding = QMailMessageBody::NoEncoding;
            encodingStatus = QMailMessageBody::AlreadyEncoded;
        }
        m_part = QMailMessagePart::fromFile(filePath, d, type, encoding, encodingStatus);
        m_filePath = filePath;
        m_url = m_filePath;
        break;
    }
    emit attachmentChanged();
}

QString Attachment::displayName()
{
//    // if this is an rfc822 message attachment then
//    // the displayname is either empty or just not useable.
//    // Fall back to the subject of the attached message
//    if (isRfc822()) {
//        QMailMessage msgPart = QMailMessage::fromRfc2822(m_part.body().data(QMailMessageBody::Decoded));
//        qDebug() <<
//        if (!msgPart.subject().isEmpty()) {
//            return msgPart.subject();
//        }
////        const bool nameIsEmpty = m_part.contentDisposition().parameter(QByteArrayLiteral("name")).isEmpty();
////        const bool fnameIsEmpty = m_part.contentDisposition().parameter(QByteArrayLiteral("filename")).isEmpty();
////        const bool ctypeNameIsEmpty = m_part.contentType().name().isEmpty();
////        if (nameIsEmpty && fnameIsEmpty && ctypeNameIsEmpty) {

////        }
//    }
    return m_part.displayName();
}

QString Attachment::mimeType() const
{
    return QString::fromLatin1(m_part.contentType().content());
}

QString Attachment::size()
{
    return sizeToReadableString(m_part.contentDisposition().size());
}

int Attachment::sizeInBytes() const
{
    return m_part.contentDisposition().size();
}

Attachment::Type Attachment::type() const
{
    return m_type;
}

bool Attachment::contentAvailable() const
{
    return m_part.contentAvailable();
}

QString Attachment::location() const
{
    return m_part.location().toString(true);
}

QString Attachment::url() const
{
    return m_url;
}

bool Attachment::fetchInProgress() const
{
    return m_fetching;
}

QString Attachment::mimeTypeIcon() const
{
    return QStringLiteral("%1-symbolic").arg(QMimeDatabase().mimeTypeForName(mimeType()).genericIconName());
}

typedef QMap<QString, Attachment::Type> CTypes;
static CTypes types()
{
    CTypes t;
    t["image"] = Attachment::Type::Image;
    t["audio"] = Attachment::Type::Media;
    t["video"] = Attachment::Type::Media;
    t["text"] = Attachment::Type::Text;
    t["multipart"] = Attachment::Type::Multipart;
    return t;
}

void Attachment::init(const QMailMessageId &id, const QMailMessagePartContainer::Location &location)
{
    static const CTypes typeMap(types());
    m_location = location;
    m_id = id;
    m_part = QMailMessage(m_id).partAt(m_location);

    QString type = m_part.contentType().type().toLower();
    CTypes::const_iterator it = typeMap.find(type);
    if (it != typeMap.end()) {
        m_type = it.value();
    } else {
        m_type = Type::Other;
    }
    emit attachmentChanged();
}

void Attachment::addToMessage(QMailMessage &msg)
{
    switch(m_partType) {
    case Message:
    case MessagePart:
    {
        msg.appendPart(m_part);
        if (m_hasRefs) {
            msg.setStatus(QMailMessage::HasReferences, true);
            msg.setStatus(QMailMessage::HasUnresolvedReferences, true);
        }
        break;
    }
    case File:
        msg.appendPart(m_part);
        // Store the location of this file for future reference
        const QMailMessagePart &mailPart(msg.partAt(msg.partCount() - 1));
        QString name("qmf-file-location-" + mailPart.location().toString(false));
        msg.setCustomField(name, m_filePath);
        break;
    }
}

void Attachment::open(QObject *qmlObject)
{
    if (m_partType == File) {
        qDebug() << "Fixme: opening attachments of part type File not yet implemented";
        return;
    }

    m_fetching = true;
    m_url = QString();
    emit progressChanged();

    if (!contentAvailable()) {
        QQmlEngine *engine = qmlEngine(qmlObject);
        Q_ASSERT(engine);
        m_qnam = engine->networkAccessManagerFactory()->create(this);
        fetch();
    } else {
        handlePartFetched();
    }
}

void Attachment::fetch()
{
    if (!m_qnam) {
        // TODO emit some error
        m_fetching = false;
        emit progressChanged();
        return;
    }
    if (m_reply) {
        disconnect(m_reply, 0, this, 0);
        delete m_reply;
        m_reply = 0;
    }
    m_reply = m_qnam->get(QNetworkRequest(partFetchUrl()));
    connect(m_reply, SIGNAL(finished()), this, SLOT(handlePartFetched()));
}

void Attachment::handlePartFetched()
{
    m_part = QMailMessage(m_id).partAt(m_location);
    if (contentAvailable()) {
        QString filepath = writePartToFile();
        if (!filepath.isEmpty()) {
            if (!filepath.startsWith(QStringLiteral("file://"))) {
                filepath.prepend(QStringLiteral("file://"));
            }
            m_url = filepath;
            emit urlChanged();
            emit readyToOpen(m_url);
        }
    } else {
        qDebug() << "[Attachments::handlePartFetched] content still not available";
    }
    m_fetching = false;
    emit progressChanged();
}

QString Attachment::writePartToFile()
{
    QMailMessage msg(m_id);
    QMailAccountId accountId = msg.parentAccountId();
    QString attachmentPath = Paths::cacheLocationForFile(
                QStringLiteral("attachments/%1/%2").arg(
                    QString::number(accountId.toULongLong()), m_location.toString(true)));
    QString attachmentFile = attachmentPath + "/" + displayName();
    QFile file(attachmentFile);
    QString path;
    if (!file.exists()) {
        // refresh the part
        m_part = QMailMessage(m_id).partAt(m_location);
        if (m_part.hasBody()) {
            path = m_part.writeBodyTo(attachmentPath);
        } else {
            return QString();
        }
    } else {
        path = attachmentFile;
    }
    qDebug() << "AttachmentPath" << path;
    return QFileInfo(path).absoluteFilePath();
}

QUrl Attachment::partFetchUrl()
{
    QUrl url;
    url.setScheme(QStringLiteral("dekko-part"));
    url.setHost(QStringLiteral("msg"));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("messageId"), QString::number(m_id.toULongLong()));
    query.addQueryItem(QStringLiteral("location"), m_location.toString(true));
    url.setQuery(query);
    return url;
}

QString Attachment::sizeToReadableString(const int &size)
{
    if(size < 1024)
        return QObject::tr("%n byte(s)", "", size);
    else if(size < (1024 * 1024))
        return QObject::tr("%1 KB").arg(((float)size)/1024.0, 0, 'f', 1);
    else if(size < (1024 * 1024 * 1024))
        return QObject::tr("%1 MB").arg(((float)size)/(1024.0 * 1024.0), 0, 'f', 1);
    else
        return QObject::tr("%1 GB").arg(((float)size)/(1024.0 * 1024.0 * 1024.0), 0, 'f', 1);
}

bool Attachment::isRfc822()
{
    return (m_part.contentType().type().toLower() == "message") &&
            (m_part.contentType().subType().toLower() == "rfc822");
}
