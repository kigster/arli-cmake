#=============================================================================#
# Author:    Konstantin Gredeskoul (kigster)
# Home:      https://github.com/kigster/arli
# License:   MIT
# Copyright: (C) 2017 Konstantin Gredeskoul
#=============================================================================#


#=============================================================================#
# detect_arduino_device
# [PUBLIC]
#
# detect_arduino_device()
#
# Automatically detects a USB Arduino Serial port by doing ls on /dev
# Errors if more than 1 port was found, or if none were found.
# Set environment variable BOARD_DEVICE to override auto-detection.
#=============================================================================#
FUNCTION(detect_arduino_device)
    if (DEFINED ENV{BOARD_DEVICE})
        message(STATUS "Using device from environment variable BOARD_DEVICE")
        set(BOARD_DEVICE $ENV{BOARD_DEVICE})
        set(BOARD_DEVICE PARENT_SCOPE)
    else ()
        message(STATUS "Auto-detecting board device from /dev")
        execute_process(
                COMMAND "/usr/bin/find" "-s" "/dev" "-name" "cu.*serial*"
                OUTPUT_VARIABLE BOARD_DEVICE
                ERROR_VARIABLE STDERR
                OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif ()

    STRING(REGEX REPLACE "\n" ";" BOARD_DEVICE "${BOARD_DEVICE}")

    separate_arguments(BOARD_DEVICE)

    list(LENGTH BOARD_DEVICE NUM_DEVICES)
    message(STATUS "Total of ${NUM_DEVICES} devices have been found.")

    if (${NUM_DEVICES} EQUAL 0)
        message(FATAL_ERROR "No devices have been found, aborting!")
    elseif (${NUM_DEVICES} EQUAL 1)
        message(STATUS "Auto-detected 1 device ${BOARD_DEVICE}, continuing...")
    else ()
        message(FATAL_ERROR "Too many devices have been detected! Force device by setting 'BOARD_DEVICE' variable, or unplug one or more devices!")
    endif ()

    set(ENV{BOARD_DEVICE} ${BOARD_DEVICE})
    set(BOARD_DEVICE PARENT_SCOPE)
ENDFUNCTION(detect_arduino_device)

