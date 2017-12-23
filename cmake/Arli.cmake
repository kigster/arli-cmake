#=============================================================================#
# Author:    Konstantin Gredeskoul (kigster)
# Home:      https://github.com/kigster/arli
# License:   MIT
# Copyright: (C) 2017 Konstantin Gredeskoul
#=============================================================================#


#=============================================================================#
# arli_libraries
# [PUBLIC]
#
# arli_libraries(SOURCE_DIR)
#
#      SOURCE_DIR   - where to look for arli.json
#
# Processes arli.json file in the main source folder to build a list of
# dependent libraries. Exports an environment variable ARLI_LIBRARIES as a
# semi-colon separated list of library names.
#=============================================================================#
#FUNCTION(arli_libraries SOURCE_DIR)
#    execute_process(
#      COMMAND "/usr/bin/ruby" "-e" "require \"yaml\"; YAML.load(File.read(\"Arlifile\"))[\"dependencies\"].map{ |k| k[\"name\"]}.each {|l| printf l.gsub(/ /, '_') + \";\"}"
#            OUTPUT_VARIABLE ARLI_LIBRARIES_STDOUT
#            ERROR_VARIABLE ARLI_LIBRARIES_STDERR
#            OUTPUT_STRIP_TRAILING_WHITESPACE
#            WORKING_DIRECTORY ${SOURCE_DIR}
#    )
#
#    message(STATUS ${ARLI_LIBRARIES_STDERR})
#    #STRING(REGEX REPLACE "\n" ";" ARLI_LIBRARIES ${ARLI_LIBRARIES_STDOUT})
#    set(ARLI_LIBRARIES "${ARLI_LIBRARIES_STDOUT}" PARENT_SCOPE)
#    message(STATUS "Auto-loaded ARLI Libraries: ${ARLI_LIBRARIES}")
#ENDFUNCTION(arli_libraries)

#=============================================================================#
# build_library
# [PUBLIC]
#
# build_library(LIB LIB_SOURCE_PATH)
#
#      LIB               - name of the library to build
#      LIB_SOURCE_PATH   - path to the top-level 'libraries' folder.
#
# Builds a library as a static .a library that can be linked by the main
# target.
#=============================================================================#
FUNCTION(build_library LIB LIB_SOURCE_PATH)
    set(${LIB}_RECURSE true)

    include_directories(${LIB_SOURCE_PATH} ${LIB_SOURCE_PATH}/utility)
    link_directories(${LIB_SOURCE_PATH})

    set(LIB_SOURCES $ENV{${LIB}_SOURCES})
    set(LIB_HEADERS $ENV{${LIB}_HEADERS})

    separate_arguments(LIB_SOURCES)
    separate_arguments(LIB_HEADERS)

    prepend(LIB_SOURCES ${LIB_SOURCE_PATH} ${LIB_SOURCES})
    prepend(LIB_HEADERS ${LIB_SOURCE_PATH} ${LIB_HEADERS})

    if (NOT DEFINED ENV{${LIB}_ONLY_HEADER})
        list(APPEND LIB_SOURCES ${LIB_SOURCE_PATH}/${LIB}.cpp)
    endif ()

    if (NOT LIB_SOURCES)
        set(LIB_SOURCES ${LIB_HEADERS})
    endif()

    GENERATE_ARDUINO_LIBRARY(${LIB}
            SRCS ${LIB_SOURCES}
            HDRS ${LIB_HEADERS}
            BOARD $ENV{BOARD_NAME})
ENDFUNCTION(build_library)

#=============================================================================#
# prepend
# [PUBLIC]
#
# prepend(var prefix)
#
#      var      - variable containing a list
#      prefix   - string to prepend to each list item
#
#=============================================================================#
FUNCTION(prepend var prefix)
    SET(listVar "")
    FOREACH (f ${ARGN})
        LIST(APPEND listVar "${prefix}/${f}")
    ENDFOREACH (f)
    SET(${var} "${listVar}" PARENT_SCOPE)
ENDFUNCTION(prepend)
