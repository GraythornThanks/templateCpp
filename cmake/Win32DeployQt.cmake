# Win32DeployQt.cmake
# 此模块提供了在Windows平台下部署Qt应用程序所需依赖文件的功能

# 查找Qt部署工具
macro(find_qt_deploy_tool QT_DIR)
    find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${QT_DIR}/bin" "${QT_DIR}")
    if(NOT WINDEPLOYQT_EXECUTABLE)
        message(WARNING "未找到windeployqt工具，Qt部署功能将不可用")
    else()
        message(STATUS "找到Qt部署工具: ${WINDEPLOYQT_EXECUTABLE}")
    endif()
endmacro()

# 如果Qt6_DIR已定义，查找部署工具
if(WIN32 AND Qt6_DIR AND NOT WINDEPLOYQT_EXECUTABLE)
    find_qt_deploy_tool(${Qt6_DIR})
endif()

# 封装Qt部署功能
function(win32_deploy_qt TARGET_NAME QT_DIR)
    if(NOT WIN32)
        return()
    endif()
    
    # 确保部署工具存在
    if(NOT WINDEPLOYQT_EXECUTABLE)
        find_qt_deploy_tool(${QT_DIR})
        if(NOT WINDEPLOYQT_EXECUTABLE)
            return()
        endif()
    endif()
    
    # 获取目标可执行文件的位置
    get_target_property(_target_location ${TARGET_NAME} RUNTIME_OUTPUT_DIRECTORY)
    if(NOT _target_location)
        set(_target_location $<TARGET_FILE_DIR:${TARGET_NAME}>)
    endif()
    
    # 设置部署命令的选项
    set(_deploy_args "--no-compiler-runtime" "--no-translations")
    
    # 添加部署命令
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E echo "正在部署Qt依赖文件..."
        COMMAND ${WINDEPLOYQT_EXECUTABLE} ${_deploy_args} $<TARGET_FILE:${TARGET_NAME}>
        COMMENT "为 ${TARGET_NAME} 部署Qt依赖"
        WORKING_DIRECTORY ${_target_location}
    )
    
    message(STATUS "已为目标 ${TARGET_NAME} 配置Qt部署")
endfunction()