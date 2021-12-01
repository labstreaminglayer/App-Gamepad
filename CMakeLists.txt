cmake_minimum_required(VERSION 3.15)

project(GamepadLSL
	DESCRIPTION "Stream Gamepad (Xbox controller) analog stick positions and button events over LabStreamingLayer"
	HOMEPAGE_URL "https://github.com/labstreaminglayer/App-Gamepad/"
	LANGUAGES C CXX
	VERSION 1.15.0
	)

# also look for CMake modules in the cmake subfolder
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Find an installed liblsl in paths set by the user (LSL_INSTALL_ROOT)
# and some default paths
find_package(LSL REQUIRED
	HINTS ${LSL_INSTALL_ROOT}
	"${CMAKE_CURRENT_LIST_DIR}/../../LSL/liblsl/build/"
	"${CMAKE_CURRENT_LIST_DIR}/../../LSL/liblsl/build/install"
	"${CMAKE_CURRENT_LIST_DIR}/../../LSL/liblsl/out/build/x64-Release"
	"${CMAKE_CURRENT_LIST_DIR}/../../LSL/liblsl/out/install/x64-Release"
	PATH_SUFFIXES share/LSL)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#: ## Using Qt
#: Enable automatic compilation of .cpp->.moc, xy.ui->ui_xy.h and resource files
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Qml Quick Gamepad REQUIRED)
if(Qt${QT_VERSION_MAJOR} STREQUAL "Qt6")
	# find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Core5Compat REQUIRED)
	qt6_add_resources(qml_QRC src/qml.qrc)
elseif(Qt${QT_VERSION_MAJOR} STREQUAL "Qt5")
	qt5_add_resources(qml_QRC src/qml.qrc)
endif()

# Native `std::thread`s still require a platform thread library.
# CMake can find and link to it with the `Threads` package (link your
# executable with `Threads::Threads` afterwards).
find_package(Threads REQUIRED)

# Add executable targets, the default target has the same name as the project

add_executable(${PROJECT_NAME} MACOSX_BUNDLE WIN32
	src/main.cpp
	src/lsl_manager.hpp
	src/lsl_manager.cpp
	${qml_QRC}
)

target_link_libraries(${PROJECT_NAME}
	PRIVATE
		Qt${QT_VERSION_MAJOR}::Qml
		Qt${QT_VERSION_MAJOR}::Quick
		Qt${QT_VERSION_MAJOR}::Gamepad
		Qt${QT_VERSION_MAJOR}::Network
		Threads::Threads
		LSL::lsl
)

# Setting up deployment (let CPack generate a zip/dmg file)
set_target_properties(${PROJECT_NAME} PROPERTIES qml_directory "${CMAKE_CURRENT_LIST_DIR}/src/qml")
installLSLApp(${PROJECT_NAME})
LSLGenerateCPackConfig()  # Macro has some bugs...
set(CPACK_PACKAGE_NAME ${PROJECT_NAME})
set(CPACK_PACKAGE_VENDOR "Intheon")
