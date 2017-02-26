#pragma once

#include "openglwindow.hpp"

class SdlWindow : public OpenGLWindow
{
public:
	SdlWindow() {}

    void initialize() override;
    void render() override;
};