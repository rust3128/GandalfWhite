// backendclient.h
#ifndef BACKENDCLIENT_H
#define BACKENDCLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>

class BackendClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString clientVersionString READ clientVersionString CONSTANT)
    Q_PROPERTY(QString clientBuildDate READ clientBuildDate CONSTANT)
    Q_PROPERTY(QString clientBuildTime READ clientBuildTime CONSTANT)

public:
    explicit BackendClient(QObject *parent = nullptr);

    // Метод, який QML буде викликати для запиту статусу
    Q_INVOKABLE void requestStatus();
    // Метод, який QML буде викликати для запиту версії
    Q_INVOKABLE void requestVersion();
    // Методи READ для Q_PROPERTY
    QString clientVersionString() const;
    QString clientBuildDate() const;
    QString clientBuildTime() const;

signals:
    // Сигнал, який буде випромінюватися при отриманні відповіді від /status
    void statusReceived(const QJsonObject& data);
    // Сигнал, який буде випромінюватися при отриманні відповіді від /version
    void versionReceived(const QJsonObject& data);
    // Сигнал для сповіщення про помилки мережі
    void networkError(const QString& errorMessage);

private slots:
    void onStatusReplyFinished(QNetworkReply* reply);
    void onVersionReplyFinished(QNetworkReply* reply);

private:
    QNetworkAccessManager *m_networkAccessManager;
    const QUrl m_baseUrl; // Базова URL вашого бекенду
    // Приватні змінні для зберігання версії клієнта (будуть ініціалізовані у .cpp)
    QString m_clientVersionString;
    QString m_clientBuildDate;
    QString m_clientBuildTime;
};

#endif // BACKENDCLIENT_H
