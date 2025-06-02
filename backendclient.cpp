// backendclient.cpp
#include "backendclient.h"
#include <QDebug>
#include <QJsonParseError>

BackendClient::BackendClient(QObject *parent)
    : QObject{parent},
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_baseUrl("http://127.0.0.1:8080/") // Вкажіть URL вашого ArnorBeaconServer
{
    // Немає необхідності підключати finished() тут для кожного маршруту,
    // оскільки ми будемо обробляти відповідь в лямбді для кожного запиту
}

void BackendClient::requestStatus()
{
    qDebug() << "Sending request to /status";
    QNetworkReply* reply = m_networkAccessManager->get(QNetworkRequest(m_baseUrl.resolved(QUrl("/status"))));
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onStatusReplyFinished(reply);
    });
}

void BackendClient::requestVersion()
{
    qDebug() << "Sending request to /version";
    QNetworkReply* reply = m_networkAccessManager->get(QNetworkRequest(m_baseUrl.resolved(QUrl("/version"))));
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onVersionReplyFinished(reply);
    });
}

void BackendClient::onStatusReplyFinished(QNetworkReply* reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray responseData = reply->readAll();
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(responseData, &error);

        if (error.error == QJsonParseError::NoError) {
            if (doc.isObject()) {
                emit statusReceived(doc.object());
                qDebug() << "Status received:" << doc.object();
            } else {
                qWarning() << "Received non-object JSON for /status:" << responseData;
                emit networkError("Invalid JSON format for /status.");
            }
        } else {
            qWarning() << "Failed to parse JSON for /status:" << error.errorString() << "Data:" << responseData;
            emit networkError("JSON parse error for /status: " + error.errorString());
        }
    } else {
        qWarning() << "Network error for /status:" << reply->errorString();
        emit networkError("Network error for /status: " + reply->errorString());
    }
    reply->deleteLater();
}

void BackendClient::onVersionReplyFinished(QNetworkReply* reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray responseData = reply->readAll();
        QJsonParseError error;
        QJsonDocument doc = QJsonDocument::fromJson(responseData, &error);

        if (error.error == QJsonParseError::NoError) {
            if (doc.isObject()) {
                emit versionReceived(doc.object());
                qDebug() << "Version received:" << doc.object();
            } else {
                qWarning() << "Received non-object JSON for /version:" << responseData;
                emit networkError("Invalid JSON format for /version.");
            }
        } else {
            qWarning() << "Failed to parse JSON for /version:" << error.errorString() << "Data:" << responseData;
            emit networkError("JSON parse error for /version: " + error.errorString());
        }
    } else {
        qWarning() << "Network error for /version:" << reply->errorString();
        emit networkError("Network error for /version: " + reply->errorString());
    }
    reply->deleteLater();
}
