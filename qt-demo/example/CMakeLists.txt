# for each "example/x.cpp", generate target "x"
file(GLOB_RECURSE all_examples *.cpp)
foreach(v ${all_examples})
    string(REGEX MATCH "example/.*" relative_path ${v})
    # message(${relative_path})
    string(REGEX REPLACE "example/" "" target_name ${relative_path})
    string(REGEX REPLACE ".cpp" "" target_name ${target_name})

    add_executable(${target_name} ${v})
    
    # 链接到qt-demo_lib静态库
    target_link_libraries(${target_name}
        PRIVATE
        qt-demo_lib
        Qt6::Core
        Qt6::Gui
        Qt6::Widgets
    )

    # 设置目标属性
    set_target_properties(${target_name}
        PROPERTIES
        VS_DEBUGGER_WORKING_DIRECTORY "${OUTPUT_BASE_DIR}/$<CONFIG>"
    )

    # 部署Qt依赖
    if(WIN32)
        qt_deploy(${target_name})
    endif()
endforeach()
