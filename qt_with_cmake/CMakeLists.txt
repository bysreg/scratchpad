cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project(test_qt_with_cmake)

set(CMAKE_CXX_STANDARD 11) # use c++11

## CMAKE debug help
message("CMAKE_CXX_COMPILER_ID = " ${CMAKE_CXX_COMPILER_ID})

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_PREFIX_PATH "C:/Qt/5.8/msvc2015_64")

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)

# Find the QtWidgets library
find_package(Qt5Widgets)

# Tell CMake to create the helloworld executable
add_executable(test_qt WIN32 main.cpp mainwindow.cpp mainwindow.h)
target_link_libraries(test_qt Qt5::Widgets)

add_custom_command(TARGET test_qt POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${PROJECT_SOURCE_DIR}/windows/bin"
        $<TARGET_FILE_DIR:test_qt>)