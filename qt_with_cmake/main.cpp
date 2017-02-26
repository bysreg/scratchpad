#include "mainwindow.h"
#include "projectwindow.hpp"
#include "openglwidget.hpp"

#include <QApplication>
#include <qsurfaceformat.h>

int main(int argc, char *argv[])
{
	QApplication app(argc, argv);

	QSurfaceFormat format;
	format.setSamples(16);
	format.setMajorVersion(3);
	format.setMinorVersion(3);
	format.setProfile(QSurfaceFormat::CoreProfile);

	//ProjectWindow window;
	//window.setFormat(format);
	//window.resize(1024, 768);
	//window.show();
	//window.setAnimating(true);

	MainWindow main_window;
	main_window.show();

	//OpenGLWidget glwidget(nullptr);
	//glwidget.setFormat(format);
	//glwidget.resize(1024, 768);
	//glwidget.show();

	return app.exec();
}
