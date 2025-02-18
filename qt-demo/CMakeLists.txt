set(MAIN_EXECUTABLE_NAME qt-demo)

find_package(Qt6 REQUIRED COMPONENTS 
        Core
        Gui
        Widgets
    )

# 源文件收集
file(GLOB_RECURSE HEADER_FILES CONFIGURE_DEPENDS 
    include/*.h 
    include/*.hpp
)

file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS 
    src/*.c 
    src/*.cpp 
    src/*.cc
)

# 目标创建
add_executable(${MAIN_EXECUTABLE_NAME} 
    ${HEADER_FILES}
    ${SOURCE_FILES}
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

# 依赖项链接
target_link_libraries(${MAIN_EXECUTABLE_NAME} 
    PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
)

# 包含目录设置
target_include_directories(${MAIN_EXECUTABLE_NAME} 
    PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}/include
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
get_target_property(_target_libs ${MAIN_EXECUTABLE_NAME} LINK_LIBRARIES)
if(_target_libs MATCHES "Qt[56]::")
    qt_deploy(${MAIN_EXECUTABLE_NAME})
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

