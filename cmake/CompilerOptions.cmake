# 设置基础编译选项
function(set_base_compile_options)
    set(COMMON_COMPILE_OPTIONS
        $<$<CXX_COMPILER_ID:MSVC>:/utf-8$<SEMICOLON>/DNOMINMAX$<SEMICOLON>/D_USE_MATH_DEFINES>
        $<$<AND:$<CXX_COMPILER_ID:GNU>,$<CONFIG:Debug>>:-Wall$<SEMICOLON>-Wextra$<SEMICOLON>-ftrapv$<SEMICOLON>-fbounds-check$<SEMICOLON>-fsanitize-trap>
        $<$<CXX_COMPILER_ID:MSVC>:/W4>  
        $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wpedantic>
    )
    add_compile_options(${COMMON_COMPILE_OPTIONS})
    
    # 设置调试信息
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g" PARENT_SCOPE)
    
    # 设置位置无关代码
    set(CMAKE_POSITION_INDEPENDENT_CODE ON PARENT_SCOPE)
endfunction()

# 设置警告级别
function(set_warning_level target)
    if(MSVC)
        target_compile_options(${target} PRIVATE /W4)
    else()
        target_compile_options(${target} PRIVATE -Wall -Wextra -Wpedantic)
    endif()
endfunction()

# 启用优化
function(enable_optimizations target)
    if(MSVC)
        target_compile_options(${target} PRIVATE $<$<CONFIG:Release>:/O2>)
    else()
        target_compile_options(${target} PRIVATE $<$<CONFIG:Release>:-O3>)
    endif()
endfunction()

# 自动设置基础编译选项
set_base_compile_options()