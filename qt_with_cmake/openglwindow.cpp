#include "openglwindow.hpp"

#include <qopenglpaintdevice.h>
#include <qpainter.h>

#include <iostream>

OpenGLWindow::OpenGLWindow(QWindow *parent)
	: QWindow(parent)
	, m_context(0)
	, m_device(0)
{
	setSurfaceType(QWindow::OpenGLSurface);
}

void OpenGLWindow::render(QPainter *painter)
{
	Q_UNUSED(painter);
}

void OpenGLWindow::initialize()
{
	glewExperimental = GL_TRUE; // this is needed for glGenVertexArrays and other functions to exist
	GLenum glewErr = glewInit();
	if (glewErr != GLEW_OK)
	{
		std::cerr << "glewInit failed : " << glewGetErrorString(glewErr) << std::endl;
		return;
	}

	initializeOpenGLFunctions();
}

void OpenGLWindow::render()
{
	if (!m_device)
		m_device = new QOpenGLPaintDevice;

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

	m_device->setSize(size());

	QPainter painter(m_device);
	render(&painter);
}

void OpenGLWindow::renderLater()
{
	requestUpdate();
}

bool OpenGLWindow::event(QEvent *event)
{
	switch (event->type()) {
	case QEvent::UpdateRequest:
		renderNow();
		return true;
	default:
		return QWindow::event(event);
	}
}

void OpenGLWindow::exposeEvent(QExposeEvent *event)
{
	Q_UNUSED(event);

	if (isExposed())
		renderNow();
}

void OpenGLWindow::renderNow()
{
	if (!isExposed())
		return;

	bool needsInitialize = false;

	if (!m_context) {
		m_context = new QOpenGLContext(this);
		m_context->setFormat(requestedFormat());
		m_context->create();

		needsInitialize = true;
	}

	m_context->makeCurrent(this);

	if (needsInitialize) {
		initialize();
	}

	render();

	m_context->swapBuffers(this);

	if (m_animating)
		renderLater();
}

void OpenGLWindow::setAnimating(bool animating)
{
	m_animating = animating;

	if (animating)
		renderLater();
}