#if defined(PEACH_WINDOWS) && defined(PEACH_DEBUG)
#	define _CRTDBG_MAP_ALLOC
#	include <crtdbg.h>
#	include <stdlib.h>
#	undef realloc
#endif

#include "mainwindow.h"

#include <QApplication>
#include <qsurfaceformat.h>

#if defined(PEACH_WINDOWS) && defined(PEACH_DEBUG)
struct CrtMemoryAllocDebugBreak
{
	CrtMemoryAllocDebugBreak()
	{
		// _crtBreakAlloc = 286; // change this number to break on the c runtime memory allocation with that ID
	}
};
CrtMemoryAllocDebugBreak test;
#endif

#ifdef QT_STATIC
#	include <QtCore/QtPlugin>
Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin)
#endif

void* operator new(std::size_t n)
{
	return malloc(n);
}
void operator delete(void* p)
{
	free(p);
}

void* operator new[](std::size_t s)
{
	return malloc(s);
}
void operator delete[](void* p)
{
	free(p);
}

int main(int argc, char* argv[])
{
#if defined(PEACH_WINDOWS) && defined(PEACH_DEBUG)
	// memory leaks detection
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
	_CrtSetReportMode(_CRT_ERROR, _CRTDBG_MODE_DEBUG);
#endif

	QApplication app(argc, argv);

	QSurfaceFormat format;
	format.setSamples(16);

	format.setMajorVersion(3);
	format.setMinorVersion(3);
	format.setProfile(QSurfaceFormat::CoreProfile);

	MainWindow main_window;
	main_window.show();

	return app.exec();
}
