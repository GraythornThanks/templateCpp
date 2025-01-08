# Qt部署工具查找
find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${CMAKE_PREFIX_PATH}")
find_program(MACDEPLOYQT_EXECUTABLE macdeployqt HINTS "${CMAKE_PREFIX_PATH}")

# 定义Windows下的Qt部署函数
function(windows_qt_deploy target)
    if(WIN32 AND WINDEPLOYQT_EXECUTABLE)
        # Debug和Release分别部署
        add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E echo "Running windeployqt for ${target}..."
            COMMAND ${WINDEPLOYQT_EXECUTABLE}
                --verbose 1
                --no-compiler-runtime
                --no-translations
                --no-system-d3d-compiler
                --no-opengl-sw
                $<$<CONFIG:Debug>:--debug>
                $<$<CONFIG:Release>:--release>
                # 与主CMakeLists.txt一致的输出路径
                --dir "$<IF:$<CONFIG:Debug>,${DEBUG_OUTPUT_DIR},${RELEASE_OUTPUT_DIR}>"
                $<TARGET_FILE:${target}>
            COMMENT "Deploying Qt dependencies for ${target}"
        )
    endif()
endfunction()

# 定义macOS下的Qt部署函数
function(macos_qt_deploy target)
    if(APPLE AND MACDEPLOYQT_EXECUTABLE)
        add_custom_command(TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E echo "Running macdeployqt for ${target}..."
            COMMAND ${MACDEPLOYQT_EXECUTABLE}
                # 与主CMakeLists.txt一致的输出路径
                "$<IF:$<CONFIG:Debug>,${DEBUG_OUTPUT_DIR},${RELEASE_OUTPUT_DIR}>/$<TARGET_FILE_NAME:${target}>.app"
                -verbose=1
                -always-overwrite
            COMMENT "Deploying Qt dependencies for ${target}"
        )
    endif()
endfunction()

# 统一的Qt部署函数
function(qt_deploy target)
    if(WIN32)
        windows_qt_deploy(${target})
    elseif(APPLE)
        macos_qt_deploy(${target})
    endif()
endfunction() 