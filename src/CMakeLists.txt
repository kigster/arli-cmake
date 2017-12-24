cmake_minimum_required(VERSION 2.8)

set(CMAKE_TOOLCHAIN_FILE ../cmake/ArduinoToolchain.cmake) # Arduino Toolchain

project(Adafruit7SDisplay C CXX ASM)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR}/../cmake)


set(ARDUINO_SDK_HARDWARE_LIBRARY_PATH "${ARDUINO_SDK_PATH}/hardware/arduino/avr/libraries")
set(ARDUINO_SDK_LIBRARY_PATH "${ARDUINO_SDK_PATH}/libraries")

if (NOT DEFINED ENV{BOARD_NAME})
    set(ENV{BOARD_NAME} "uno")
endif ()

message(STATUS "Board: $ENV{BOARD_NAME}")
message(STATUS " NOTE: to override set env variable BOARD_NAME")

include(Arli)

# Special flags for some particular boards
set(nano.build.mcu atmega328p)
set(nano.upload.speed 57600)

# Auto-detect from /dev
arli_detect_serial_device("/dev/null")

set(BOARD_DEVICE $ENV{BOARD_DEVICE})
message(STATUS "Device [${BOARD_DEVICE}] have been selected.")

# These are Arduino-provided libs we depend on
set(ARDUINO_LIBRARIES Wire)
set(ARDUINO_DEFAULT_BOARD uno) # Default Board ID, when not specified
set(ARDUINO_DEFAULT_PORT /dev/null) # Default Port, when not specified

# Define various special flags on some libs
set(ENV{Wire_HEADERS} utility/twi.h)
set(ENV{Wire_SOURCES} utility/twi.c)

# Now this imports all of the libraries defined in Arlifile
include(Arlifile.cmake)

FOREACH(LIB ${ARLI_LIBRARIES})
    arli_build_arduino_library(${LIB} "${ARLI_LIBRARIES_PATH}/${LIB}")
ENDFOREACH(LIB)

FOREACH(LIB ${ARDUINO_LIBRARIES})
    arli_build_arduino_library(${LIB} "${ARDUINO_SDK_HARDWARE_LIBRARY_PATH}/${LIB}/src")
ENDFOREACH(LIB)

generate_arduino_firmware(
        Adafruit7SDDisplayTest
        SRCS Adafruit7SDisplay.cpp
        LIBS ${ARLI_LIBRARIES} ${ARDUINO_LIBRARIES}
        BOARD nano
        BOARD_CPU atmega328
        PORT com4
        )


