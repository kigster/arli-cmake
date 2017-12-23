cmake_minimum_required(VERSION 3.2.2)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR}/cmake)

set(ARDUINO_SDK_LIBRARY_PATH "${ARDUINO_SDK_PATH}/libraries")
set(ARDUINO_SDK_HARDWARE_LIBRARY_PATH "${ARDUINO_SDK_PATH}/hardware/arduino/avr/libraries")
set(ARDUINO_CUSTOM_LIBRARY_PATH "${CMAKE_CURRENT_SOURCE_DIR}/src/libraries")

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

project(WallClock3 C CXX)

if ($ENV{DEBUG})
    print_board_list()
    print_programmer_list()
endif ()

add_subdirectory(src)   #add the example directory into build
