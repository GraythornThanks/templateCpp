set(MAIN_EXECUTABLE_NAME qt-demo)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Gui Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Gui Widgets)

file(GLOB_RECURSE HEADER_FILES CONFIGURE_DEPENDS 
    include/*.h 
    include/*.hpp
)

file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS 
    src/*.c 
    src/*.cpp 
    src/*.cc
)


if(${QT_VERSION_MAJOR} GREATER 6)
    qt_add_executable(${MAIN_EXECUTABLE_NAME}
        MANUAL_FINALIZATION
        PRIVATE
        src/main.cpp
    )
else()
    if(ANDROID)
        add_library(${MAIN_EXECUTABLE_NAME}
            SHARED
            ${HEADER_FILES}
            ${SOURCE_FILES}
        )
    else()
        add_executable(${MAIN_EXECUTABLE_NAME}
            ${HEADER_FILES}
            ${SOURCE_FILES}
        )
    endif()
endif()

target_include_directories(${MAIN_EXECUTABLE_NAME}
    PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(${MAIN_EXECUTABLE_NAME} 
    PUBLIC
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Widgets
)

# ios bundle id
if(${QT_VERSION} VERSION_LESS 6.1.0)
  set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER com.example.what_is_for_dinner_tonight)
endif()
set_target_properties(${MAIN_EXECUTABLE_NAME} PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
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

if(WIN32)
    get_target_property(_target_libs ${MAIN_EXECUTABLE_NAME} LINK_LIBRARIES)
    if(_target_libs MATCHES "Qt6::")
        qt_deploy(${MAIN_EXECUTABLE_NAME})
    endif()
endif()


include(GNUInstallDirs)
if(NOT WIN32)
    install(TARGETS ${MAIN_EXECUTABLE_NAME}
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endif()



add_subdirectory(example)
add_subdirectory(test)

