#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext> // Для доступу до кореневого контексту QML
#include <QQuickStyle> // <--- Додайте цей імпорт
#include "backendclient.h" // Включаємо новий клас

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // !!! ВАЖЛИВО: Встановіть стиль для QML Controls !!!
    QQuickStyle::setStyle("Material"); // <--- Додайте цей рядок

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // Створюємо екземпляр BackendClient та реєструємо його в QML контексті
    BackendClient backendClient;
    engine.rootContext()->setContextProperty("backendClient", &backendClient);

    engine.loadFromModule("GandalfWhite", "Main");

    return app.exec();
}
