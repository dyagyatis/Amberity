cmake_minimum_required(VERSION 3.20)
project(Amberity VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Qml)

set(SOURCES
    src/main.cpp
    src/backend/VmManager.hpp
    src/backend/VmManager.cpp
    src/core/InputMapper.hpp
    src/core/InputMapper.cpp
    resources.qrc
)

add_executable(amberity ${SOURCES})

target_link_libraries(amberity PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
)

target_include_directories(amberity PRIVATE
    src/
    src/backend/
    src/core/
)

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(amberity PRIVATE -O3 -Wall -Wextra)
endif()
