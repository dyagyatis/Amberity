#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "backend/VmManager.hpp"
#include "core/InputMapper.hpp"

int main(int argc, char *argv[]) {
    // Включение оптимизаций для Wayland и мониторов высокой герцовки
    qputenv("QT_QPA_PLATFORM", "wayland;xcb");
    qputenv("QSG_RENDER_LOOP", "basic");

    QGuiApplication app(argc, argv);
    app.setOrganizationName("Amberity");
    app.setApplicationName("Amberity Player");
    app.setApplicationVersion("0.1.0");

    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;

    auto vmManager = new VmManager(&app);
    auto inputMapper = new InputMapper(&app);

    engine.rootContext()->setContextProperty("vmManager", vmManager);
    engine.rootContext()->setContextProperty("inputMapper", inputMapper);

    const QUrl url(QStringLiteral("qrc:/src/gui/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
