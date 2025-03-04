set(MAIN_EXECUTABLE_NAME gl-demo)
set(LIB_NAME ${MAIN_EXECUTABLE_NAME}-lib)

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

list(FILTER SOURCE_FILES EXCLUDE REGEX ".*main\.cpp$")

# 创建静态库
add_library(${LIB_NAME} STATIC
    ${HEADER_FILES}
    ${SOURCE_FILES}
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

# 静态库依赖项链接
target_link_libraries(${LIB_NAME}
    PRIVATE
    OpenGL::GL
    glad
    glfw
    glm
)

# 可执行文件依赖项链接
target_link_libraries(${MAIN_EXECUTABLE_NAME} 
    PRIVATE
    ${LIB_NAME}
)

# 包含目录设置
target_include_directories(${LIB_NAME}
    PUBLIC
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