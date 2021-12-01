#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "lsl_manager.hpp"


int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    app.setOrganizationName("LSL Developers");
    app.setApplicationName("Gamepad LSL");
    QQmlApplicationEngine engine;
    LSLManager lsl_manager;
    engine.rootContext()->setContextProperty("lsl_manager", &lsl_manager);
	engine.load(QUrl(QStringLiteral("qrc:///qml/main.qml")));
    QObject::connect(&engine, &QQmlApplicationEngine::quit, &QGuiApplication::quit);
    return app.exec();
}
