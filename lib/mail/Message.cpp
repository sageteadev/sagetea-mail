#include "Message.h"
#include <qmailfolder.h>
#include <qmailmessagekey.h>
#include <qmailstore.h>

MinimalMessage::MinimalMessage(QObject *parent) : QObject(parent),
    m_from(0), m_checked(Qt::Unchecked)
{
}

MailAddress* MinimalMessage::from() const
{
    return m_from;
}

QString MinimalMessage::subject() const
{
    return QMailMessage(m_id).subject();
}

QString MinimalMessage::preview() const
{
    return QMailMessageMetaData(m_id).preview().simplified();
}

bool MinimalMessage::hasAttachments() const
{
    return (QMailMessageMetaData(m_id).status() & QMailMessageMetaData::HasAttachments);
}

bool MinimalMessage::isRead() const
{
    return (QMailMessageMetaData(m_id).status() & QMailMessageMetaData::Read);
}

bool MinimalMessage::isFlagged() const
{
    return (QMailMessageMetaData(m_id).status() & QMailMessageMetaData::Important);
}

bool MinimalMessage::isTodo() const
{
    return (QMailMessageMetaData(m_id).status() & QMailMessageMetaData::Todo);
}

bool MinimalMessage::canBeRestored() const
{
    return QMailMessage(m_id).restoreFolderId().isValid();
}

bool MinimalMessage::isDone() const
{
    QString done = QMailMessage(m_id).customField("task-done");
    if (done.isEmpty()) {
        return false;
    }
    return done.toInt() != 0;
}

QString MinimalMessage::previousFolderName() const
{
    return QMailFolder(QMailMessage(m_id).restoreFolderId()).displayName();
}

QDateTime MinimalMessage::date() const
{
    return QMailMessageMetaData(m_id).date().toLocalTime();
}

QString MinimalMessage::prettyDate()
{
    QDateTime timestamp = date();
    if (!timestamp.isValid())
        return QString();

    if (timestamp.date() == QDate::currentDate())
        return timestamp.toString(tr("hh:mm"));

    int beforeDays = timestamp.date().daysTo(QDate::currentDate());
    if (beforeDays <= 7) {
        return timestamp.toString(tr("ddd hh:mm"));
    } else {
        return timestamp.toString(tr("dd MMM"));
    }
}

Qt::CheckState MinimalMessage::checked() const
{
    return m_checked;
}

/** @short returns a messagekey suitable for showing a filtered list of messages from this sender */
QVariant MinimalMessage::senderMsgKey() const
{
    QMailMessageKey excludeKey = QMailMessageKey::status((QMailMessage::Removed | QMailMessage::Trash), QMailDataComparator::Excludes);
    return QMailMessageKey::sender(m_from->address(), QMailDataComparator::Includes) & excludeKey;
}

void MinimalMessage::setMessageId(const quint64 &id)
{
    setMessageId(QMailMessageId(id));
}

void MinimalMessage::setMessageId(const QMailMessageId &id)
{
    m_id = id;
    if (!m_id.isValid()) {
        return;
    }
    QMailMessage msg(m_id);
//    qDebug() << "MSG ID: " << messageId();
    m_from = new MailAddress(this);
    m_from->setAddress(msg.from());

    emit minMessageChanged();
}

void MinimalMessage::setChecked(const Qt::CheckState &checked)
{
    if (checked == m_checked) {
        return;
    }
    m_checked = checked;
    emit checkedChanged();
}

void MinimalMessage::setIsTodo(const bool todo)
{
    QMailMessageMetaData mmd(m_id);
    mmd.setStatus(QMailMessageMetaData::Todo, todo);
    QMailStore::instance()->updateMessage(&mmd);
    emit minMessageChanged();
}


Message::Message(QObject *parent) : MinimalMessage(parent),
    m_to(0), m_cc(0), m_bcc(0), m_preferPlainText(false)
{
    connect(this, &Message::minMessageChanged, this, &Message::initMessage);
}

QUrl Message::body() const
{
    return m_body;
}

QUrl Message::findInterestingBodyPart(const QMailMessageId &id, const bool preferPlainText)
{
    if (!id.isValid()) {
        return QUrl();
    }
    QMailMessage msg(id);
    bool isPlainText = false;
    QString msgIdString = QString::number(id.toULongLong());
    QString location;
    QUrl url;

    qDebug() << __func__ << "Part count: " << msg.partCount();
    if (msg.multipartType() == QMailMessage::MultipartNone) {
        qDebug() << __func__ << "MultipartNone";
        isPlainText = (msg.body().contentType().content() == QByteArrayLiteral("text/plain"));
        url.setScheme(QStringLiteral("dekko-msg"));
    } else {
        qDebug() << msg.body().data();
        QMailMessagePart *part = 0;
        if (!preferPlainText && msg.hasHtmlBody()) {
            QMailMessagePartContainer *html = msg.findHtmlContainer();
            if (html) {
                qDebug() << __func__ << "Html container found";
                part = static_cast<QMailMessagePart *>(html);
            }
        }
        if (!part || preferPlainText) {
            QMailMessagePartContainer *ptext = msg.findPlainTextContainer();
            if (ptext) {
                qDebug() << __func__ << "Plain text part found";
                part = static_cast<QMailMessagePart *>(ptext);
                isPlainText = true;
            }
        }
        if (!part) {
            qDebug() << __func__ << "Unable to find a displayable message part :-/";
            return QUrl();
        }
        location = part->location().toString(true);
        url.setScheme(QStringLiteral("dekko-part"));
    }
    url.setHost(QStringLiteral("msg"));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("messageId"), msgIdString);
    if (isPlainText) {
        query.addQueryItem(QStringLiteral("requestFormatting"), QStringLiteral("true"));
    }
    if (!location.isEmpty()) {
        query.addQueryItem(QStringLiteral("location"), location);
    }
    url.setQuery(query);
    qDebug() << url;
    return url;
}

bool Message::preferPlainText() const
{
    return m_preferPlainText;
}

void Message::setPreferPlainText(const bool preferPlainText)
{
    if (m_preferPlainText == preferPlainText)
        return;

    m_preferPlainText = preferPlainText;
    emit plainTextChanged();
}

void Message::initMessage()
{
    QUrl url = Message::findInterestingBodyPart(m_id, m_preferPlainText);
    if (url.isValid()) {
        qDebug() << "Url is valid: " << url;
        m_body = url;
        emit bodyChanged();
    }
}
