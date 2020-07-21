cmake_minimum_required(VERSION 3.15)

project(GamepadLSL
	LANGUAGES CXX
	VERSION 1.14.0
	)

# also look for CMake modules in the cmake subfolder
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Find an installed liblsl in paths set by the user (LSL_INSTALL_ROOT)
# and some default paths
find_package(LSL REQUIRED
	HINTS ${LSL_INSTALL_ROOT}
	"${CMAKE_CURRENT_LIST_DIR}/../../LSL/liblsl/build/install"
	"${CMAKE_CURRENT_LIST_DIR}/../../LSL/liblsl/out/install/x64-Release"
	PATH_SUFFIXES share/LSL)
get_filename_component(LSL_PATH ${LSL_CONFIG} DIRECTORY)
message(STATUS "Found LSL lib in ${LSL_PATH}")
LSLAPP_Setup_Boilerplate()

#: ## Using Qt
#: Enable automatic compilation of .cpp->.moc, xy.ui->ui_xy.h and resource files
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 REQUIRED COMPONENTS Qml Quick Gamepad)
qt5_add_resources(qml_QRC src/qml.qrc)

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
	Qt5::Qml
	Qt5::Quick
	Qt5::Gamepad
	Qt5::Network
	Threads::Threads
	LSL::lsl
)

foreach(_lib ${THIRD_PARTY_DLLS})
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different  
            $<TARGET_FILE:${_lib}>
            $<TARGET_FILE_DIR:${PROJECT_NAME}>)
endforeach()

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_14)

# Setting up deployment (let CPack generate a zip/dmg file)
set_target_properties(${PROJECT_NAME} PROPERTIES qml_directory "${CMAKE_CURRENT_LIST_DIR}/src/qml")
installLSLApp(${PROJECT_NAME})
LSLGenerateCPackConfig()
