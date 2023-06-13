#include "DekkoWebEngineUrlSchemeHandler.h"
#include <QDebug>
#include <QNetworkRequest>

DekkoWebEngineUrlSchemeHandler::DekkoWebEngineUrlSchemeHandler(QWebEngineUrlSchemeHandler *parent) : QWebEngineUrlSchemeHandler(parent),
    messageUid(""), pendingRequest(nullptr), customNetworkAccessManager(nullptr)
{
}

void DekkoWebEngineUrlSchemeHandler::requestStarted(QWebEngineUrlRequestJob *request)
{
    auto requestUrl = request->requestUrl();
    qDebug() << "Scheme handler called for " << requestUrl.toString();
    if (this->testScheme("cid", requestUrl) && !requestUrl.toString().contains(this->messageUid))
    {
        requestUrl.setQuery("messageId=" + this->messageUid);
    }

    pendingRequest = request;

    QNetworkRequest networkRequest;
    networkRequest.setUrl(requestUrl);

    if (!this->customNetworkAccessManager)
    {
        qDebug() << "I can get no network access manager...";
    }
    else
    {
        this->customNetworkAccessManager->get(networkRequest);
    }
}

void DekkoWebEngineUrlSchemeHandler::onReply(QNetworkReply *reply)
{
    if (!pendingRequest)
    {
        return;
    }
    connect(this->pendingRequest, &QObject::destroyed, reply, &QObject::deleteLater);
    this->pendingRequest->reply(QByteArrayLiteral("text/html"), reply);
    this->pendingRequest = nullptr;
}

bool DekkoWebEngineUrlSchemeHandler::testScheme(const QString &scheme, const QUrl &url)
{
    return url.scheme() == scheme;
}

void DekkoWebEngineUrlSchemeHandler::setMessageUid(QString messageUid)
{
    this->messageUid = messageUid;
}

QString DekkoWebEngineUrlSchemeHandler::getMessageUid() const
{
    return this->messageUid;
}

void DekkoWebEngineUrlSchemeHandler::setNetworkAccessManager(QNetworkAccessManager * qnam)
{
    this->customNetworkAccessManager = qnam;

    connect(this->customNetworkAccessManager, &QNetworkAccessManager::finished,
            this, &DekkoWebEngineUrlSchemeHandler::onReply);
}

