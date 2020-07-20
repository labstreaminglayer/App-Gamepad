#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>

#include "lsl_manager.hpp"


int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    app.setOrganizationName("LSL Developers");
    app.setApplicationName("Gamepad LSL");
    QSettings settings;
    settings.setDefaultFormat(QSettings::Format::IniFormat);  // Does this persist to QML?
	QQmlApplicationEngine engine;
    LSLManager lsl_manager;
    engine.rootContext()->setContextProperty("lsl_manager", &lsl_manager);
	engine.load(QUrl(QStringLiteral("qrc:///qml/main.qml")));
    return app.exec();
}
