# 设置输出目录的基础路径
set(OUTPUT_BASE_DIR "${PROJECT_BINARY_DIR}/bin")

# 定义不同配置的子目录
set(OUTPUT_CONFIG_DIRS
    Debug   "${OUTPUT_BASE_DIR}/debug"
    Release "${OUTPUT_BASE_DIR}/release"
    RelWithDebInfo "${OUTPUT_BASE_DIR}/relwithdebinfo"
    MinSizeRel    "${OUTPUT_BASE_DIR}/minsizerel"
)

# 设置输出目录的函数
function(set_output_directories target)
    # 为每个配置设置输出目录
    foreach(CONFIG_TYPE ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${CONFIG_TYPE} CONFIG_TYPE_UPPER)
        set_target_properties(${target} PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY_${CONFIG_TYPE_UPPER} "${OUTPUT_BASE_DIR}/${CONFIG_TYPE}"
            LIBRARY_OUTPUT_DIRECTORY_${CONFIG_TYPE_UPPER} "${OUTPUT_BASE_DIR}/${CONFIG_TYPE}"
            ARCHIVE_OUTPUT_DIRECTORY_${CONFIG_TYPE_UPPER} "${OUTPUT_BASE_DIR}/${CONFIG_TYPE}"
        )
    endforeach()

    # 设置默认输出目录（单配置生成器）
    set_target_properties(${target} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/$<CONFIG>"
        LIBRARY_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/$<CONFIG>"
        ARCHIVE_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/$<CONFIG>"
    )
endfunction()

# 设置全局输出目录
foreach(CONFIG_TYPE ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${CONFIG_TYPE} CONFIG_TYPE_UPPER)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${CONFIG_TYPE_UPPER} "${OUTPUT_BASE_DIR}/${CONFIG_TYPE}")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CONFIG_TYPE_UPPER} "${OUTPUT_BASE_DIR}/${CONFIG_TYPE}")
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${CONFIG_TYPE_UPPER} "${OUTPUT_BASE_DIR}/${CONFIG_TYPE}")
endforeach()

# 设置单配置生成器的默认输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/$<CONFIG>")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/$<CONFIG>")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${OUTPUT_BASE_DIR}/$<CONFIG>")

# 创建输出目录
function(create_output_directories)
    foreach(CONFIG_TYPE ${CMAKE_CONFIGURATION_TYPES})
        file(MAKE_DIRECTORY "${OUTPUT_BASE_DIR}/${CONFIG_TYPE}")
    endforeach()
endfunction()

# 自动创建输出目录
create_output_directories() 