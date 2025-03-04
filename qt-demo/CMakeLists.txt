set(MAIN_EXECUTABLE_NAME qt-demo)

find_package(Qt6 REQUIRED COMPONENTS 
        Core
        Gui
        Widgets
    )

file(GLOB_RECURSE HEADER_FILES CONFIGURE_DEPENDS 
    include/*.h 
    include/*.hpp
)

file(GLOB_RECURSE SOURCE_FILES_TEMP CONFIGURE_DEPENDS 
    src/*.c 
    src/*.cpp 
    src/*.cc
)

list(FILTER SOURCE_FILES_TEMP EXCLUDE REGEX ".*main\\.cpp$")
set(SOURCE_FILES ${SOURCE_FILES_TEMP})

# 创建静态库
set(LIB_NAME ${MAIN_EXECUTABLE_NAME}_lib)
add_library(${LIB_NAME} STATIC
    ${HEADER_FILES}
    ${SOURCE_FILES}
)

# 设置库的包含目录
target_include_directories(${LIB_NAME} 
    PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# 为库添加Qt依赖
target_link_libraries(${LIB_NAME} 
    PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
)

# 目标创建
add_executable(${MAIN_EXECUTABLE_NAME} 
    src/main.cpp
)

# IDE文件组织
source_group(
    TREE ${CMAKE_CURRENT_SOURCE_DIR}
    PREFIX "Header Files"
    FILES ${HEADER_FILES}
)

source_group(
    TREE ${CMAKE_CURRENT_SOURCE_DIR}
    PREFIX "Source Files"
    FILES ${SOURCE_FILES}
)

# 依赖项链接 - 链接到静态库
target_link_libraries(${MAIN_EXECUTABLE_NAME} 
    PRIVATE
    ${LIB_NAME}
)

# 目标属性设置
set_target_properties(${MAIN_EXECUTABLE_NAME} 
    PROPERTIES
    VS_DEBUGGER_WORKING_DIRECTORY "${OUTPUT_BASE_DIR}/$<CONFIG>"
)

add_custom_target(run-${MAIN_EXECUTABLE_NAME}
    COMMAND $<TARGET_FILE:${MAIN_EXECUTABLE_NAME}>
    DEPENDS ${MAIN_EXECUTABLE_NAME}
    COMMENT "Running ${MAIN_EXECUTABLE_NAME}..."
    WORKING_DIRECTORY $<TARGET_FILE_DIR:${MAIN_EXECUTABLE_NAME}>
)

# 检查目标是否链接了Qt库
if(WIN32)
    get_target_property(_target_libs ${MAIN_EXECUTABLE_NAME} LINK_LIBRARIES)
    if(_target_libs MATCHES "Qt6::")
        qt_deploy(${MAIN_EXECUTABLE_NAME})
    endif()
endif()

# 编译定义设置
target_compile_definitions(${MAIN_EXECUTABLE_NAME} 
    PRIVATE
    $<$<CXX_COMPILER_ID:GNU>:COMPILER="gcc">
    $<$<CXX_COMPILER_ID:NVIDIA>:COMPILER="nvcc">
    $<$<CXX_COMPILER_ID:Clang>:COMPILER="clang">
    $<$<CXX_COMPILER_ID:MSVC>:COMPILER="msvc">
)

# 子模块添加
add_subdirectory(./example)
add_subdirectory(./test)

