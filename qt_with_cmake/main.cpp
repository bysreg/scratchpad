#include "mainwindow.h"
#include "projectwindow.hpp"

#include <QApplication>
#include <qsurfaceformat.h>

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);

	QSurfaceFormat format;
	format.setSamples(16);
	format.setMajorVersion(3);
	format.setMinorVersion(3);
	format.setProfile(QSurfaceFormat::CoreProfile);

	ProjectWindow window;
	window.setFormat(format);
	window.resize(1024, 768);
	window.show();

	window.setAnimating(true);

	return app.exec();
}
