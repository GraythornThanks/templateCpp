# for each "test/x.cpp", generate target "x"
file(GLOB_RECURSE all_tests *.cpp)
foreach(v ${all_tests})
    string(REGEX MATCH "test/.*" relative_path ${v})
    # message(${relative_path})
    string(REGEX REPLACE "test/" "" target_name ${relative_path})
    string(REGEX REPLACE ".cpp" "" target_name ${target_name})

    add_executable(${target_name} ${v})
    
    # 链接静态库
    target_link_libraries(${target_name}
        PRIVATE
        ${LIB_NAME}
    )

    # 设置包含目录
    target_include_directories(${target_name}
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/../include
    )
endforeach()
