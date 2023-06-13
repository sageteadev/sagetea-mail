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

    if (!this->hasAllowedScheme(requestUrl))
    {
        // check the resourceType() to not block links, not sure thats reliable, but it
        // seems navigationType() == QWebEngineUrlRequestInfo::NavigationTypeLink always...
        bool doBlock = this->remoteResourcesAreBlocked
                       && (info.resourceType() != QWebEngineUrlRequestInfo::ResourceTypeMainFrame);
        info.block(doBlock);
        emit interceptedRemoteRequest(doBlock);
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

