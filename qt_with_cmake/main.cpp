#include "mainwindow.h"

#include <GL/glew.h>
#include <SDL.h>

#include <QApplication>

#define BABI_OGL_VERSION 330
#define BABI_OGL_MAJOR_VERSION 3
#define BABI_OGL_MINOR_VERSION 3

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();
}
