#=============================================================================#
# Author:    Konstantin Gredeskoul (kigster)
# Home:      https://github.com/kigster/arli-cmake
# License:   MIT
# Copyright: (C) 2017 Konstantin Gredeskoul
#=============================================================================#



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
function(prepend var prefix)
    SET(listVar "")
    FOREACH (f ${ARGN})
        LIST(APPEND listVar "${prefix}/${f}")
    ENDFOREACH (f)
    SET(${var} "${listVar}" PARENT_SCOPE)
endfunction(prepend)

#=============================================================================#
# arli_build_arduino_library
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

FUNCTION(arli_build_arduino_library LIB LIB_SOURCE_PATH)
    if (NOT DEFINED LIB_SOURCE_PATH)
      set(LIB_SOURCE_PATH ${ARDUINO_SDK_PATH}/libraries)
    endif ()

    set(${LIB}_RECURSE true)

    include_directories(${LIB_SOURCE_PATH} ${LIB_SOURCE_PATH}/utility)
    link_directories(${LIB_SOURCE_PATH})

    set(LIB_SOURCES $ENV{${LIB}_SOURCES})
    set(LIB_HEADERS $ENV{${LIB}_HEADERS})

    separate_arguments(LIB_SOURCES)
    separate_arguments(LIB_HEADERS)

    prepend(LIB_SOURCES ${LIB_SOURCE_PATH} ${LIB_SOURCES})
    prepend(LIB_HEADERS ${LIB_SOURCE_PATH} ${LIB_HEADERS})

    if (NOT DEFINED ${LIB}_ONLY_HEADER)
        list(APPEND LIB_SOURCES ${LIB_SOURCE_PATH}/${LIB}.cpp)
    else()
        list(APPEND LIB_SOURCES ${LIB_SOURCE_PATH}/${LIB}.h)
    endif()

    if (NOT LIB_SOURCES)
        set(LIB_SOURCES ${LIB_HEADERS})
    endif ()

    generate_arduino_library(${LIB}
            SRCS ${LIB_SOURCES}
            HDRS ${LIB_HEADERS}
            BOARD_CPU ${BOARD_CPU}
            BOARD $ENV{BOARD_NAME})

ENDFUNCTION(arli_build_arduino_library)

#=============================================================================#
# arli_detect_serial_device
# [PUBLIC]
#
# arli_detect_serial_device()
#
# Automatically detects a USB Arduino Serial port by doing ls on /dev
# Errors if more than 1 port was found, or if none were found.
# Set environment variable BOARD_DEVICE to override auto-detection.
#=============================================================================#
function(arli_detect_serial_device DEFAULT_DEVICE)
    if (DEFINED ENV{BOARD_DEVICE})
        message(STATUS "Using device from environment variable BOARD_DEVICE")
        set(BOARD_DEVICE $ENV{BOARD_DEVICE} PARENT_SCOPE)
    else ()
        message(STATUS "Auto-detecting board device from /dev")
        execute_process(
                COMMAND "/usr/bin/find" "-s" "/dev" "-name" "cu.*serial*"
                OUTPUT_VARIABLE BOARD_DEVICE
                ERROR_VARIABLE STDERR
                OUTPUT_STRIP_TRAILING_WHITESPACE)

        string(REGEX REPLACE "\n" ";" BOARD_DEVICE "${BOARD_DEVICE}")
        separate_arguments(BOARD_DEVICE)
        list(LENGTH BOARD_DEVICE NUM_DEVICES)
        message(STATUS "Total of ${NUM_DEVICES} devices have been found.")

        if (${NUM_DEVICES} EQUAL 0)
            set(BOARD_DEVICE ${DEFAULT_DEVICE} PARENT_SCOPE)
        elseif (${NUM_DEVICES} EQUAL 1)
            message(STATUS "Auto-detected 1 device ${BOARD_DEVICE}, continuing...")
            set(BOARD_DEVICE ${BOARD_DEVICE}} PARENT_SCOPE)
        else ()
            message(FATAL_ERROR "Too many devices have been detected!
                                 Force device by setting 'BOARD_DEVICE' variable,
                                 or unplug one or more devices!")
        endif ()
    endif ()
endfunction(arli_detect_serial_device)

#=============================================================================#
# arli_detect_board_and_cpu
# [PUBLIC]
#
# arli_detect_board DEFAULT_BOARD_NAME DEFAULT_BOARD_CPU
#
# Checks if $ENV{BOARD_NAME} or $ENV{BOARD_CPU} are set in the ENV and if
# so use the environment values; otherwise use the defaults.
#
#=============================================================================#
function(arli_detect_board DEFAULT_BOARD_NAME DEFAULT_BOARD_CPU)
    arli_set_env_or_default(BOARD_NAME ${DEFAULT_BOARD_NAME})
    arli_set_env_or_default(BOARD_CPU ${DEFAULT_BOARD_CPU})

    set(BOARD_NAME ${BOARD_NAME} PARENT_SCOPE)
    set(BOARD_CPU ${BOARD_CPU} PARENT_SCOPE)
endfunction(arli_detect_board)


#=============================================================================#
# arli_set_env_or_default
# [PUBLIC]
#
# arli_detect_board DEFAULT_BOARD_NAME DEFAULT_BOARD_CPU
#
# Checks if $ENV{BOARD_NAME} or $ENV{BOARD_CPU} are set in the ENV and if
# so use the environment values; otherwise use the defaults.
#
#=============================================================================#
function(arli_set_env_or_default OUTPUT_VAR DEFAULT)
  if (DEFINED ENV{${OUTPUT_VAR}})
      message(STATUS "Setting ${OUTPUT_VAR} from Environment to $ENV{${OUTPUT_VAR}}")
      set(${OUTPUT_VAR} $ENV{${OUTPUT_VAR}} PARENT_SCOPE)
  else ()
      set(${OUTPUT_VAR} ${DEFAULT} PARENT_SCOPE)
      message(STATUS "Setting ${OUTPUT_VAR} to the default ${DEFAULT}")
  endif()
endfunction(arli_set_env_or_default)


function(arli_build_all_libraries)

  set(ARDUINO_SDK_HARDWARE_LIBRARY_PATH "${ARDUINO_SDK_PATH}/hardware/arduino/avr/libraries")
  set(ARDUINO_SDK_LIBRARY_PATH "${ARDUINO_SDK_PATH}/libraries")
  set(ARDUINO_CUSTOM_LIBRARY_PATH "${ARLI_CUSTOM_LIBS_PATH}")
  #
  # set(ENV{Wire_HEADERS} utility/twi.h)
  # set(ENV{Wire_SOURCES} utility/twi.c)

  FOREACH(LIB ${ARLI_CUSTOM_LIBS})
      arli_build_arduino_library(${LIB} "${ARDUINO_CUSTOM_LIBRARY_PATH}/${LIB}")
  ENDFOREACH(LIB)

  FOREACH(LIB ${ARLI_ARDUINO_HARDWARE_LIBS})
      arli_build_arduino_library(${LIB} "${ARDUINO_SDK_HARDWARE_LIBRARY_PATH}/${LIB}/src")
  ENDFOREACH(LIB)

  FOREACH(LIB ${ARLI_ARDUINO_LIBS})
      arli_build_arduino_library(${LIB} "${ARDUINO_SDK_LIBRARY_PATH}/${LIB}/src")
  ENDFOREACH(LIB)
endfunction(arli_build_all_libraries)
