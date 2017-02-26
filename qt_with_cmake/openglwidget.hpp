#pragma once

#include <qopenglwidget.h>
#include <qopenglfunctions.h>

class OpenGLWidget : public QOpenGLWidget, protected QOpenGLFunctions
{
public:
	OpenGLWidget(QWidget* parent) : QOpenGLWidget(parent) { }

protected:
	void initializeGL() override;
	void resizeGL(int w, int h) override;
	void paintGL() override;

};