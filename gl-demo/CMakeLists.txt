get_filename_component(MAIN_EXECUTABLE_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

find_package(OpenGL REQUIRED)
find_package(glfw3 REQUIRED)
find_package(glad REQUIRED)
find_package(glm REQUIRED)

file(GLOB_RECURSE HEADER_FILES CONFIGURE_DEPENDS 
    include/*.h 
    include/*.hpp
)

file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS 
    src/*.c 
    src/*.cpp 
    src/*.cc
)


add_executable(${MAIN_EXECUTABLE_NAME} 
    ${HEADER_FILES}
    ${SOURCE_FILES}
)

target_link_libraries(
    ${MAIN_EXECUTABLE_NAME}
    PRIVATE
    OpenGL::GL
    glad
    glfw
    glm
)

target_include_directories(${MAIN_EXECUTABLE_NAME}
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

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

target_compile_definitions(${MAIN_EXECUTABLE_NAME} 
    PRIVATE
    $<$<CXX_COMPILER_ID:GNU>:COMPILER="gcc">
    $<$<CXX_COMPILER_ID:NVIDIA>:COMPILER="nvcc">
    $<$<CXX_COMPILER_ID:Clang>:COMPILER="clang">
    $<$<CXX_COMPILER_ID:MSVC>:COMPILER="msvc">
)

