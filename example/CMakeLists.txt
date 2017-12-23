# This configuration file outlines some of the ways Arduino CMake
# can be used. For a detailed explenation of all the options please
# reade README.rst.

set(PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_TOOLCHAIN_FILE ${PROJECT_DIR}/../cmake/ArduinoToolchain.cmake) # Arduino Toolchain

cmake_minimum_required(VERSION 2.8)

#====================================================================#
#  Setup Project                                                     #
#====================================================================#
project(Adafruit7SDisplay C CXX ASM)

set(ARDUINO_DEFAULT_BOARD uno) # Default Board ID, when not specified
set(ARDUINO_DEFAULT_PORT /dev/null) # Default Port, when not specified

cmake_minimum_required(VERSION 3.2.2)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR}/../cmake)

set(ARDUINO_SDK_LIBRARY_PATH "${ARDUINO_SDK_PATH}/libraries")
set(ARDUINO_SDK_HARDWARE_LIBRARY_PATH "${ARDUINO_SDK_PATH}/hardware/arduino/avr/libraries")
set(ARDUINO_CUSTOM_LIBRARY_PATH "${CMAKE_CURRENT_SOURCE_DIR}/libraries")

# Import Arduino Toolchain
set(CMAKE_TOOLCHAIN_FILE ${PROJECT_DIR}/cmake/ArduinoToolchain.cmake)

if (NOT DEFINED ENV{BOARD_NAME})
    set(ENV{BOARD_NAME} "uno")
endif ()

message(STATUS "Board: $ENV{BOARD_NAME}")
message(STATUS " NOTE: to override set env variable BOARD_NAME")

# Include Custom Functions
include(Arli)
include(DetectSerialUnixDevice)

# Special flags for some particular boards
set(nano.build.mcu atmega328p)
set(nano.upload.speed 57600)

# Auto-detect from /dev
detect_arduino_device()

set(BOARD_DEVICE $ENV{BOARD_DEVICE})
message(STATUS "Device [${BOARD_DEVICE}] have been selected.")

# These are Arduino provided libs we depend on
set(ARDUINO_LIBRARIES Wire)

include(Arlifile.cmake)

# Define various special flags on some libs
set(ENV{Wire_HEADERS} utility/twi.h)
set(ENV{Wire_SOURCES} utility/twi.c)
set(ENV{Adafruit_Sensor_ONLY_HEADER} 1)

project(ArliExample C CXX)

message(STATUS "Libraries: ${ARLI_LIBRARIES}")

FOREACH(LIB ${ARLI_LIBRARIES})
    build_library(${LIB} "${ARDUINO_CUSTOM_LIBRARY_PATH}/${LIB}")
ENDFOREACH(LIB)

FOREACH(LIB ${ARDUINO_LIBRARIES})
    build_library(${LIB} "${ARDUINO_SDK_HARDWARE_LIBRARY_PATH}/${LIB}/src")
ENDFOREACH(LIB)

generate_arduino_firmware(blink
        SRCS Adafruit7SDisplay.cpp
        LIBS ${ARLI_LIBRARIES} ${ARDUINO_LIBRARIES}
        BOARD nano
        BOARD_CPU atmega328
        PORT com4
        )


