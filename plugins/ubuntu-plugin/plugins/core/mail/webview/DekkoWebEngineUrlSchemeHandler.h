#ifndef DEKKOURLINTERCEPTOR_H
#define DEKKOURLINTERCEPTOR_H

#include <QString>
#include <QUrl>
#include <QWebEngineUrlSchemeHandler>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QWebEngineUrlRequestJob>

class DekkoWebEngineUrlSchemeHandler : public QWebEngineUrlSchemeHandler
{
    Q_OBJECT

public:
    void requestStarted(QWebEngineUrlRequestJob *request);
    explicit DekkoWebEngineUrlSchemeHandler(QWebEngineUrlSchemeHandler *parent = Q_NULLPTR);
    ~DekkoWebEngineUrlSchemeHandler() {
    }

    void setMessageUid(QString messageUid);
    QString getMessageUid() const;
    void setNetworkAccessManager(QNetworkAccessManager * qnam);
    
public slots:
    void onReply(QNetworkReply *reply);

private:
    bool testScheme(const QString &scheme, const QUrl &url);
    QString messageUid;
    QWebEngineUrlRequestJob * pendingRequest;
    QNetworkAccessManager * customNetworkAccessManager;
};

#endif
