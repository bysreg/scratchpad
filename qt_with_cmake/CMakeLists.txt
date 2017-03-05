cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project(test_qt_with_cmake)

set(CMAKE_CXX_STANDARD 11) # use c++11

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_PREFIX_PATH "C:/Qt/5.8/msvc2015_64")

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

find_package(Qt5Widgets REQUIRED)

set(PROJECT_INCLUDE_DIR "${PROJECT_SOURCE_DIR}")

######## PROJECT DEPENDENCIES #########
if(WIN32)
	set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${PROJECT_SOURCE_DIR}/windows)
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")

find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)

if(WIN32)
	macro(USE_WIN_DEBUG_LIB DEBUG_VAR)
		foreach(LIBRARY_PATH ${ARGN})
			get_filename_component(LIBRARY_NAME ${LIBRARY_PATH} NAME_WE) 
			get_filename_component(LIBRARY_DIR ${LIBRARY_PATH} DIRECTORY)
			# message("iter test library path " ${LIBRARY_PATH})
			set(${DEBUG_VAR} ${${DEBUG_VAR}} optimized ${LIBRARY_PATH} debug ${LIBRARY_DIR}/${LIBRARY_NAME}_d.lib)
		endforeach()
	endmacro()

	USE_WIN_DEBUG_LIB(GLEW_WIN_LINK_LIBRARY ${GLEW_LIBRARY})

	set(GLEW_LIBRARY ${GLEW_WIN_LINK_LIBRARY})
	
	message("GLEW_LIBRARY var is replaced with : " ${GLEW_LIBRARY})

endif()

set(PROJECT_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/src")
#=====================================

include_directories(
	${PROJECT_INCLUDE_DIR}
	${GLEW_INCLUDE_DIR}
	${Qt5Widgets_INCLUDE_DIRS}
)

qt5_wrap_ui(UI_HEADERS mainwindow.ui)

add_executable(test_qt WIN32 main.cpp mainwindow.cpp mainwindow.h openglwidget.cpp openglwidget.hpp ${UI_HEADERS})
target_link_libraries(test_qt ${OPENGL_LIBRARIES} ${GLEW_LIBRARY} Qt5::Widgets)

add_custom_command(TARGET test_qt POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${PROJECT_SOURCE_DIR}/windows/bin"
        $<TARGET_FILE_DIR:test_qt>)