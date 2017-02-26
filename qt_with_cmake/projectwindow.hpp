#pragma once

#include "openglwindow.hpp"

class ProjectWindow : public OpenGLWindow
{
public:
	ProjectWindow() {}

    void initialize() override;
    void render() override;
};