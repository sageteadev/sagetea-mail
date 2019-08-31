#include "DekkoWebEngineUrlSchemeHandler.h"
#include <QDebug>
#include <QNetworkRequest>

DekkoWebEngineUrlSchemeHandler::DekkoWebEngineUrlSchemeHandler(QWebEngineUrlSchemeHandler *parent) : QWebEngineUrlSchemeHandler(parent),
    cid(""), pendingRequest(nullptr), customNetworkAccessManager(nullptr)
{
}

void DekkoWebEngineUrlSchemeHandler::requestStarted(QWebEngineUrlRequestJob *request)
{
    auto requestUrl = request->requestUrl();
    qDebug() << "Scheme handler called for " << requestUrl.toString();
    if (this->testScheme("cid", requestUrl) && !requestUrl.toString().contains(this->cid))
    {
        auto path = requestUrl.path();
        path += this->cid;
        requestUrl.setPath(path);
        //request->redirect(requestUrl);
        //qDebug() << "Scheme handler: Request redirected to url " << requestUrl.toString();
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

void DekkoWebEngineUrlSchemeHandler::setCid(QString cid)
{
    this->cid = cid;
}

QString DekkoWebEngineUrlSchemeHandler::getCid() const
{
    return this->cid;
}

void DekkoWebEngineUrlSchemeHandler::setNetworkAccessManager(QNetworkAccessManager * qnam)
{
    this->customNetworkAccessManager = qnam;

    connect(this->customNetworkAccessManager, &QNetworkAccessManager::finished,
            this, &DekkoWebEngineUrlSchemeHandler::onReply);
}

