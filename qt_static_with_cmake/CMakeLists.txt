cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)

MESSAGE( STATUS "CMAKE_VERSION : " ${CMAKE_VERSION} )

project(peach)

set(CMAKE_CXX_STANDARD 17) # use c++17

## CMAKE debug help
message("CMAKE_CXX_COMPILER_ID = " ${CMAKE_CXX_COMPILER_ID})

########## PREPROCESSOR #################

## QT defines
add_definitions(-DQT_NO_KEYWORDS -DQT_NO_EXCEPTIONS)

## _HAS_RVALUE_REFERENCES and others are defined to work around qt bug where
## it won't define Q_COMPILER_RVALUE_REFS eventhough the compiler actually supports it
## when used with clang-cl on windows
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
	add_definitions(-D_HAS_CONSTEXPR -D_HAS_DECLTYPE -D_HAS_INITIALIZER_LISTS -D_HAS_NULLPTR_T
		-D_HAS_RVALUE_REFERENCES -D_HAS_SCOPED_ENUM -D_HAS_TEMPLATE_ALIAS -D_HAS_VARIADIC_TEMPLATES)
endif()

#=======================================-

########## PLATFORM CONFIGURATION #######
if(WIN32)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_CRT_SECURE_NO_DEPRECATE -DPEACH_WINDOWS -DUNICODE -D_UNICODE")
	include_directories(${PROJECT_SOURCE_DIR}/windows/include) #for boost
	link_directories(${PROJECT_SOURCE_DIR}/windows/static)
endif()

if(MSVC)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DNOMINMAX")
endif()
#========================================

########## DEBUG CONFIGURATION ########
## This will add some debugging macro if debug configuration is on
## To switch on debug configuration in linux, supply cmake with
##  -DCMAKE_BUILD_TYPE=Debug
## For Windows, change to Debug mode in Visual Studio

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DPEACH_DEBUG")

if(MSVC)
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_DEBUG")
endif()

#=====================================

######### RELEASE CONFIGURATION ######
## To switch on release configuration in linux, supply cmake with
##  -DCMAKE_BUILD_TYPE=Release
## For Windows, change to Release mode in Visual Studio

## turn on optimization flags
if(WIN32)
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /O2")
else()
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
endif()

#=====================================

######## WARNING CONFIGURATION ########
## turn on warning flags
if(WIN32)
	# for some reason, CMAKE_CXX_FLAGS can have /W3 as default
	string(REPLACE "/W3" "/W4" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /WX /w14265 /w14296 /w14311 /w14640 /w14928")

	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
		# suppress some harmless warning on clang-cl on windows
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Qunused-arguments -Wno-unknown-pragmas -Wno-macro-redefined
			-Wno-deprecated-declarations -Wno-unknown-argument -Wno-microsoft-enum-value -Wno-missing-braces
			-Wno-switch -Wno-unused-parameter")
	elseif(MSVC)
		# suppress some harmless warning on msvc on windows
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4619 /wd4505 /wd4127")
		add_definitions(-D_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING)
	endif()

else()
	# for linux/osx OS using gcc/clang
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pedantic -Wold-style-cast -Wshadow -Wnon-virtual-dtor
	 -Werror -Wno-missing-braces -Wno-switch")
endif()
#=====================================

####### GRAPHICS PLATFORM CONFIGURATION #########
set(GFX_PLATFORM "DX12")

#================================================

####### COMPILE FLAGS ################

# turn off rtti
if(WIN32)

	# for some reason, CMAKE_CXX_FLAGS can have /GR as default
	string(REPLACE "/GR" "/GR-" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /GR-")
else()
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
endif()

#=====================================

######### TARGET BINARY"S OUTPUT PATH ##########
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)
#===============================================

######### BOOST CONFIGURATION #########
add_definitions(-DBOOST_EXCEPTION_DISABLE)

#======================================

######## PROJECT DEPENDENCIES #########
if(WIN32)
	set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "C:/dev/Qt/Qt5_12_static")
	set(QtLibPng optimized "C:/dev/Qt/Qt5_12_static/lib/qtlibpng.lib" debug "C:/dev/Qt/Qt5_12_static/lib/qtlibpngd.lib")
	set(QtPcre2Lib optimized "C:/dev/Qt/Qt5_12_static/lib/qtpcre2.lib" debug "C:/dev/Qt/Qt5_12_static/lib/qtpcre2d.lib")
	set(Qt5FontDatabaseSupport optimized "C:/dev/Qt/Qt5_12_static/lib/Qt5FontDatabaseSupport.lib" debug "C:/dev/Qt/Qt5_12_static/lib/Qt5FontDatabaseSupportd.lib")
	set(Qt5EventDispatcherSupport optimized "C:/dev/Qt/Qt5_12_static/lib/Qt5EventDispatcherSupport.lib" debug "C:/dev/Qt/Qt5_12_static/lib/Qt5EventDispatcherSupportd.lib")
	set(Qt5ThemeSupport optimized "C:/dev/Qt/Qt5_12_static/lib/Qt5ThemeSupport.lib" debug "C:/dev/Qt/Qt5_12_static/lib/Qt5ThemeSupportd.lib")
	set(Qt5AccessibilitySupport optimized "C:/dev/Qt/Qt5_12_static/lib/Qt5AccessibilitySupport.lib" debug "C:/dev/Qt/Qt5_12_static/lib/Qt5AccessibilitySupportd.lib")
	set(Qt5WindowsUIAutomationSupport optimized "C:/dev/Qt/Qt5_12_static/lib/Qt5WindowsUIAutomationSupport.lib" debug "C:/dev/Qt/Qt5_12_static/lib/Qt5WindowsUIAutomationSupportd.lib")
	set(QtDeps Qt5::Widgets Qt5::Gui Qt5::QWindowsIntegrationPlugin ${Qt5ThemeSupport} ${Qt5WindowsUIAutomationSupport} ${Qt5AccessibilitySupport} ${QtPcre2Lib} ${QtLibPng} ${Qt5FontDatabaseSupport} ${Qt5EventDispatcherSupport} winmm.lib Ws2_32.lib mincore.lib dwmapi.lib Imm32.lib Wtsapi32.lib)
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")

find_package(OpenGL REQUIRED)
find_package(Qt5 COMPONENTS Core Widgets Gui REQUIRED)

set(Boost_USE_DEBUG_LIBS TRUE)
set(Boost_DEBUG TRUE)

set(PROJECT_INCLUDE_DIR "${PROJECT_SOURCE_DIR}")
#=====================================

####### ADD VISUAL STUDIO DEBUG VISUALIZATION ########
file(GLOB NAT_FILE vs_debug/peach.natvis vs_debug/qt5.natvis)
#=====================================

####### ADD PROJECT'S INCLUDE DIR ####

include_directories(
	${PROJECT_INCLUDE_DIR}
	${Qt5Widgets_INCLUDE_DIRS}
	${PROJECT_SOURCE_DIR}/third_party/ig-memtrace/runtime
)
#=====================================

######### COPY DLL STEP FOR WINDOWS  ################

# this step will only copy the dll to the binary folder if the corresponding .lib file is changed (as the executable only directly )

if(WIN32)

	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Debug")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Release")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Release")

	# parameter is list of binary files, consider making destination to be parameter of the function
	# instead of assuming the binary files are always copied to binary debug and release folder
	function(COPY_BIN_FILES)
		foreach(FILE_ITER ${ARGN})
			get_filename_component(BIN_DIR ${FILE_ITER} DIRECTORY)

			get_filename_component(BIN_FILE ${FILE_ITER} NAME)

			get_filename_component(TARGET ${FILE_ITER} NAME_WE)

			# for debug & release
			# see https://cmake.org/cmake/help/v3.2/manual/cmake.1.html#command-line-tool-mode
			add_custom_command(
			    OUTPUT ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG}/${BIN_FILE} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE}/${BIN_FILE}
			    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${BIN_DIR}/${BIN_FILE} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG}
			    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${BIN_DIR}/${BIN_FILE} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE}
			    DEPENDS ${BIN_DIR}/${BIN_FILE}
			    VERBATIM)

			# This target will be run if there's change in the bin file
			add_custom_target(
			  ${TARGET}bingen ALL
			  DEPENDS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG}/${BIN_FILE} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE}/${BIN_FILE}
			)

		endforeach()
	endfunction()

endif()

#=======================================

######## CREATE EACH TARGET ##########

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
qt5_wrap_ui(UI_HEADERS mainwindow.ui)

# add target for each examples in shader_examples folder
add_executable(test_qt main.cpp edge.cpp edge.h graphwidget.cpp graphwidget.h node.cpp node.h ${UI_HEADERS})
set_target_properties(test_qt PROPERTIES COMPILE_FLAGS "${PROGRAM_COMPILE_FLAGS} " LINK_FLAGS "${EDITOR_OBJECTS_LINKER_FLAGS}")
target_link_libraries(test_qt ${QtDeps})


#======================================