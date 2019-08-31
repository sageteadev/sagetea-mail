#ifndef DEKKOWEBENGINEURLREQUESTINTERCEPTOR_H
#define DEKKOWEBENGINEURLREQUESTINTERCEPTOR_H

#include <QString>
#include <QUrl>
#include <QWebEngineUrlRequestInterceptor>

class DekkoWebEngineUrlRequestInterceptor : public QWebEngineUrlRequestInterceptor
{

    Q_OBJECT
public:
    void interceptRequest(QWebEngineUrlRequestInfo &info);
    explicit DekkoWebEngineUrlRequestInterceptor(QWebEngineUrlRequestInterceptor *parent = Q_NULLPTR);
    ~DekkoWebEngineUrlRequestInterceptor() {
    }

//    void setCid(QString cid);
    void setBlockRemoteResources(bool doBlock);
//    QString getCid() const;
    bool areRemoteResourcesBlocked() const;

signals:
    void interceptedRemoteRequest(bool wasBlocked);

private:
    bool testScheme(const QString &scheme, const QUrl &url);
    bool hasAllowedScheme(const QUrl &url);
    bool remoteResourcesAreBlocked;
//    QString cid;
};

#endif
