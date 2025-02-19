cmake_minimum_required(VERSION 3.27)

# vcpkg工具链设置
if (DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    message(STATUS "VCPKG_ROOT: $ENV{VCPKG_ROOT}")
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
endif()

# Qt6查找配置
if(DEFINED ENV{Qt6_ROOT} AND NOT DEFINED CMAKE_PREFIX_PATH)
    message(STATUS "Qt6_ROOT: $ENV{Qt6_ROOT}")
    set(CMAKE_PREFIX_PATH "$ENV{Qt6_ROOT}")
endif()


set(CMAKE_CXX_STANDARD 23)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# CMake模块
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake;${CMAKE_MODULE_PATH}")
include(QtDeploy)
include(CompilerOptions)

# 构建类型设置
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
    message("Setting default build type to Release")
endif()

# 项目定义
project(project_name VERSION 0.0.1 LANGUAGES C CXX)

# 编译缓存设置
if (NOT MSVC)
    find_program(CCACHE_PROGRAM ccache)
    if (CCACHE_PROGRAM)
        message(STATUS "Found CCache: ${CCACHE_PROGRAM}")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_PROGRAM})
        set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ${CCACHE_PROGRAM})
    endif()
endif()

set(DEBUG_OUTPUT_DIR ${PROJECT_BINARY_DIR}/debug)
set(RELEASE_OUTPUT_DIR ${PROJECT_BINARY_DIR}/release)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${DEBUG_OUTPUT_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${DEBUG_OUTPUT_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${DEBUG_OUTPUT_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${RELEASE_OUTPUT_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${RELEASE_OUTPUT_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${RELEASE_OUTPUT_DIR})

find_package(OpenGL REQUIRED)

# IDE设置
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# 子目录添加
if (WIN32 AND NOT MSVC)
    add_subdirectory(libs)
elseif()
    find_package(glad)
    find_package(glfw3)
    find_package(glm)
endif()

# add_subdirectory(gl-demo)
# add_subdirectory(qt-demo)
add_custom_target(configure COMMAND ${CMAKE_EDIT_COMMAND} -B ${CMAKE_BINARY_DIR})
