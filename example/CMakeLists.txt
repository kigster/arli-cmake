# This configuration file outlines some of the ways Arduino CMake
# can be used. For a detailed explenation of all the options please
# reade README.rst.

set(CMAKE_TOOLCHAIN_FILE ../cmake/ArduinoToolchain.cmake) # Arduino Toolchain


cmake_minimum_required(VERSION 2.8)
#====================================================================#
#  Setup Project                                                     #
#====================================================================#
project(Adafruit7SDisplay C CXX ASM)

set(ARDUINO_DEFAULT_BOARD uno) # Default Board ID, when not specified
set(ARDUINO_DEFAULT_PORT /dev/null) # Default Port, when not specified

generate_arduino_library(blink_lib
        SRCS blink_lib.cpp
        HDRS blink_lib.h
        BOARD uno)

generate_arduino_firmware(blink
        SRCS Adafruit7SDisplay.cpp
        LIBS Ada
        BOARD nano
        BOARD_CPU atmega328
        PORT com4
        )

generate_arduino_firmware(serial_lib
        SRCS serial.cpp
        ARDLIBS SoftwareSerial
        BOARD uno)

