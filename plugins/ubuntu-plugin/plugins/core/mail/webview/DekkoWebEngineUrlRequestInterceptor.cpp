#include "DekkoWebEngineUrlRequestInterceptor.h"
#include <QWebEngineUrlRequestInfo>
#include <QDebug>

DekkoWebEngineUrlRequestInterceptor::DekkoWebEngineUrlRequestInterceptor(QWebEngineUrlRequestInterceptor *parent) : QWebEngineUrlRequestInterceptor(parent),
    remoteResourcesAreBlocked(true)
{
}

void DekkoWebEngineUrlRequestInterceptor::interceptRequest(QWebEngineUrlRequestInfo &info)
{
    auto requestUrl = info.requestUrl();

    qDebug() << "Request interceptor: Request intercepted for URL " << requestUrl.toString();
    if (!this->hasAllowedScheme(requestUrl))
    {
        qDebug() << "Request blocked for URL " << requestUrl.toString();
        info.block(this->remoteResourcesAreBlocked);
        emit interceptedRemoteRequest(this->remoteResourcesAreBlocked);
    }
}

bool DekkoWebEngineUrlRequestInterceptor::hasAllowedScheme(const QUrl &url)
{
    return this->testScheme("cid", url) || this->testScheme("dekko-part", url) || this->testScheme("dekko-msg", url) || this->testScheme("blob", url);
}

bool DekkoWebEngineUrlRequestInterceptor::testScheme(const QString &scheme, const QUrl &url)
{
    return url.scheme() == scheme;
}

void DekkoWebEngineUrlRequestInterceptor::setBlockRemoteResources(bool doBlock)
{
    this->remoteResourcesAreBlocked = doBlock;
}

bool DekkoWebEngineUrlRequestInterceptor::areRemoteResourcesBlocked() const
{
    return this->remoteResourcesAreBlocked;
}

