#include <GL/glew.h>

#include "openglwidget.hpp"

#include <array>
#include <iostream>

namespace
{
	// rendering related vars
	GLuint vertices_id = 0;
	GLuint indices_id = 0;

	struct Vec3f
	{
		float x;
		float y;
		float z;
	};

	struct Vertex
	{
		Vec3f pos;
		Vec3f color; // no alpha
	};

	// define the vertex of the triangle
	std::array<Vertex, 4> vertices = {
		Vertex{ { -0.5f, 0, 0 },{ 1, 0, 0 } },
		Vertex{ { 0.5f, 0, 0 },{ 0, 1, 0 } },
		Vertex{ { 0,  0.5f, 0 },{ 0, 0, 1 } },
		Vertex{ { 0, -0.5f, 0 },{ 1, 1, 1 } }
	};

	// define the indices of the triangle
	std::array<GLuint, 6> indices = { 0, 1, 2, 0, 1, 3 };
}

void OpenGLWidget::initializeGL()
{
	glewExperimental = GL_TRUE; // this is needed for glGenVertexArrays and other functions to exist
	GLenum glewErr = glewInit();
	if (glewErr != GLEW_OK)
	{
		std::cerr << "glewInit failed : " << glewGetErrorString(glewErr) << std::endl;
		return;
	}

	initializeOpenGLFunctions();

	// this is needed since OpenGL 3.2+ Core profile
	GLuint vertex_array_id;
	glGenVertexArrays(1, &vertex_array_id);
	glBindVertexArray(vertex_array_id);

	// set clear color to red (because the default color of vertex is black)
	glClearColor(1.0f, 0.0f, 0.0f, 0.0f);

	glGenBuffers(1, &vertices_id);
	glBindBuffer(GL_ARRAY_BUFFER, vertices_id);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices[0]) * vertices.size(), &vertices[0], GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);

	glGenBuffers(1, &indices_id);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indices_id);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices[0]) * indices.size(), &indices[0], GL_STATIC_DRAW);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

void OpenGLWidget::resizeGL(int w, int h)
{}

void OpenGLWidget::paintGL()
{
	const qreal retinaScale = devicePixelRatio();
	glViewport(0, 0, width() * retinaScale, height() * retinaScale);

	glClear(GL_COLOR_BUFFER_BIT);

	glBindBuffer(GL_ARRAY_BUFFER, vertices_id);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indices_id);

	// no shader set up, but apparently we can use attribute 0
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE,
		sizeof(Vertex), // stride
		reinterpret_cast<void*>(offsetof(Vertex, pos)) // offset
	);

	glDrawElements(GL_TRIANGLES, indices.size(), GL_UNSIGNED_INT, 0);

	glDisableVertexAttribArray(0);
}