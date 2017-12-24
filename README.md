[![Build Status](https://travis-ci.org/kigster/arli-cmake.svg?branch=master)](https://travis-ci.org/kigster/arli-cmake)

# Arli CMake



> ### This project builds on top of `arduino-cmake` and allows you to quickly get started with building complex C/C++ Arduino Sketches, with automatic library dependency management in any IDE, using `arli` command line tool.

### Summary

This project provides additional CMAKE helpers to build third-party libraries installed automatically using the [Arli library manager](https://github.com/kigster/arli) and a provided custom `Arlifile`. It builds atop of the powerful [arduino-cmake](https://github.com/arduino-cmake/arduino-cmake) project.

### Example / Template

The provided example in the `src` folder is a sketch that uses several Adafruit Libraries. Of course this is the part you will be changing, as well as the dependencies described in the `src/Arlifile`. Libraries are not part of this repo, and so they need to be installed using `arli bundle` command inside the `src` folder. After that, Arli-Cmake will build each library as a static .a object, and add them as dependencies to your firmware.

### Auto-Generate your Arduino Project

`arli` offers a special command called `generate`, which uses this repo as a template for creating a brand new project in a given local directory.

If you would like to use this repo as a template for your Arduino project, we highly recommend that you do this via:

```bash
$ gem install arli
$ arli generate MyProject --workspace ~/workspace
```

This operation is described on [`Arli`'s README on Github](https://github.com/kigster/arli#generate).

## Usage

### Prerequisites

On a Mac, you always need to run `xcode-select --install` before you can do any development. You must have `git` installed.

Requires ruby, 2.3 or 2.4+ installed. However, if you don't have it installed, the `bin/setup` script will prompt you to install it.

### Install

Run the following commands in your shell:

```bash
$ git clone https://github.com/kigster/arli-cmake
$ cd arli-cmake
$ bin/setup
```

This should download dependencies.

### Automated Build

The very basic build script can be used to build the project from the top level.

```bash
$ bin/build example
$ bin/build src
```

### Manual Build

Once you run the setup, manual build is:

```bash
$ gem install arli
$ cd src
$ rm -rf build && mkdir -p build && cd build
$ cmake ..
$ make
```

## CMake Setup

We build atop of arduino-cmake, which is installed by the `bin/setup` script.

There are several helpers in the `cmake/Arli.cmake` file, which reduce amount of boilerplate code one has to write to include many libraries:

 * `arli_build_arduino_library(LIB LIB_SOURCE_PATH)` function builds a static library, and deals with some of the idiosyncracies of some libraries, such as libraries with a header only, etc.

### Environment Variables

`arli-cmake` allows you to override the BOARD type and the serial device using two Environment variables:

 * `BOARD_NAME` (defaults to 'uno')
 * `DEVICE_NAME` (defaults to auto-detection first, then /dev/null)

#### Auto-Detection of the Serial Device

One of the CMake helpers provided is this one:

```cmake
# detect any serial devices under /dev
arli_detect_serial_device("/dev/null")
```

If this function finds exactly one matching device, it sets the `DEVICE_NAME`. If it finds more than one serial port, or zero, it defaults to the argument to the function.

This function removes the need to manually choose the serial port, as long as you have only one board connected. Once you have more than one, you'd need to set this ENV variable before running CMAKE.

### Dependency on `arduino-cmake`

The install script will clone `arduino-cmak` locally, and create symlinks from the cmake folder.

This is likely a temporary solution. Another option is git submodule.

## CMAKE Helpers

Please inspect the `cmake` folder to see additional helpers added on top of `arduino-cmake`.
`
## LICENSE

MIT
