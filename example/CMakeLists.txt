cmake_minimum_required(VERSION 2.8)

set(CMAKE_TOOLCHAIN_FILE ../cmake/ArduinoToolchain.cmake) # Arduino Toolchain
project(Adafruit7SDisplay C CXX ASM)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/../cmake)
set(CMAKE_LOCAL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

include(Arli)
arli_ensure_arlifile_cmake( ${CMAKE_CURRENT_SOURCE_DIR})
include(Arlifile.cmake)

set(PROJECT_SOURCES Adafruit7SDisplay.cpp)

generate_arduino_firmware(
        Adafruit7SDDisplayTest
        SRCS ${PROJECT_SOURCES}
        LIBS ${ARLI_CUSTOM_LIBS} ${ARLI_ARDUINO_HARDWARE_LIBS} ${ARLI_ARDUINO_LIBS}
        BOARD ${BOARD_NAME}
        BOARD_CPU ${BOARD_CPU}
      )
