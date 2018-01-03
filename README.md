[![Build Status](https://travis-ci.org/kigster/arli-cmake.svg?branch=master)](https://travis-ci.org/kigster/arli-cmake)
[![Gitter](https://img.shields.io/gitter/room/gitterHQ/gitter.svg)](https://gitter.im/arduino-cmake-arli/)

# Arli CMake

> **NOTE:** This project is mean to be used as a template for [Arli](https://github.com/kigster/arli). While it can be used independently, we recommend you checkout [Arli](https://github.com/kigster/arli) first.

## Overview

> ### This project builds on top of the powerful Arduino build system  [arduino-cmake](https://github.com/arduino-cmake/arduino-cmake), and it provides additional features that streamline project creation, building, and library management. It's especially useful for bigger projects written in C/C++ that might rely on a large number of third-party libraries. This part is handled using [Arli](https://github.com/kigster/arli) — an Arduino Library manager, and a project generator.

The added value of this project is that you can start right away without much understanding of how `CMake` works. It helps to understand it, no doubt, but you should be able to build and upload your firmware, as well as monitor it over a serial connection by adding your custom code to the `src` folder, updating `Arlifile`, and `src/CmakeLists.txt` file.

### Additional CMake Functions

This project compliments [arduino-cmake](https://github.com/arduino-cmake/arduino-cmake) by providing additional CMake functions which offers the following features:

 * a comprehensive **third-party Arduino library installation**, download, compilation and linking into a static `.a` library.

 * **automatic serial device detection** (that should work on Mac OSX and Unix, but unfortunately not on Windows). This feature is particularly useful if only one matching device is found — then you don't need to specify it manually. Plus, if you plug in another board, `cmake` will automatically detect the new serial device (just don't forget to remove the other board, as this only works when only one device is plugged in).

 * Alternatively, you can override board name, cpu and the Serial Port (device) by using these environment variables:

    ```bash
    mkdir build; cd build
    BOARD_NAME=nano \
     BOARD_CPU=atmega328p \
     BOARD_DEVICE=/dev/tty.usbserial-DA00WXFY \
     cmake ..
    ```

* each source project relies on single file `Arlifile` (in YAML format) that **defines all library dependencies, as well as (optionally) the board name, CPU and the Arduino built-in or hardware libraries** that may be necessary.

### Example Projects

There are two separate source folders provided:
  1. The `examples` folder contains a real example with a couple of library dependencies,
  2. The `src` folder is basically a stripped down "template" project.

You may need to modify the top level `CMakeLists.txt` file to define with subdirectory is build, `src`, or `example`.

To build the `src` folder, use standard cmake build process:

```bash
git clone https://github.com/kigster/arli-cmake
cd arli-cmake
mkdir build
cd build
cmake ..
make
```

## Building and Uploading Your Sketch

### Prerequisites

 * On a Mac, you always need to run `xcode-select --install` before you can do any development. You must have `git` installed

 * Requires [CMake](https://cmake.org/download/)

 * Requires Arduino IDE or SDK installed

 * Requires ruby, 2.3 or 2.4+ installed. However, if you don't have it installed, the `bin/setup` script willg install it.

### Arlifile

Both the `src` and `example` folders contain a very special `Arlifile`.

`Arlifile` is a configuration file that can be used to setup dependencies and define the board type and CPU. Below is an example of the `Arlifile` provided with the `example` project:

```yaml
version: 1.0.0
libraries_path: "./libraries"
lock_format: cmake
device:
  board: uno
  cpu: atmega328p
  libraries:
    hardware:
      - name: Wire
      - name: EEPROM
        headers_only: true
    arduino:
      - name: SD
dependencies:
  - name: SimpleTimer
     url: https://github.com/jfturcot/SimpleTimer
  - name: "Adafruit LED Backpack Library"
  - name: "Adafruit GFX Library"
  - name: "Time"
```

In this file you can define three types of dependent libraries:

 1. Build and link with third party libraries in the `dependencies:` array
 2. Link with provided hardware libraries in the `device.libraries.hardware` array
 3. Build and link with Arduino-supplied standard libraries in the `device.libraries.arduino` array

Note that each array member is a hash, that can contain `name`, `url`, `version` or any other attributes that define the library uniquely.

> NOTE: to get the list of attributes, run `arli -A`

### Adding External Libraries

Your repo contains `Arlifile` inside the `src` folder. Please [read the documentation](https://github.com/kigster/arli#command-bundle) about the format of `Arlifile`.

Go ahead and edit that file, and under `dependencies:` you want to list all of your libraries by their exact name, and an optional version.

The best way to do that is to **first search for the library** using the `arli search terms` command. Once you find the library you want, just copy it's name as is into `Arlifile`. If it contains spaces, put quotes around it.

For example:

```bash
❯ arli search /adafruit.*bmp085/i

Arli (1.0.2), Command: search
Library Path: ~/Documents/Arduino/Libraries

Adafruit BMP085 Library                         (1.0.0)    ( 1 total versions )
Adafruit BMP085 Unified                         (1.0.0)    ( 1 total versions )
———————————————————————
  Total Versions : 2
Unique Libraries : 2
———————————————————————
```

You must grab the exact name, for example `Adafruit BMP085 Library` and add that to the `Arlifile`.

If the library is not in the official database, just add it with a name and a url. Arli will use the url field to fetch it.

To verify that your `Arlifile` can resolve all libraries, please run `arli bundle` inside the `src` folder. If Arli suceeds, you've got it right, and the `libraries` folder inside `src` should contain all referenced libraries.

### Adding Source Files

You will notice that inside `src/CMakeLists.txt` file, there is a line:

```cmake
set(PROJECT_SOURCES #{project_name}.cpp)
```

If you add any additional source files or headers, just add their names right after, separated by spaces or newlines. For example:

```cmake
set(PROJECT_SOURCES
  #{project_name}.cpp
  #{project_name}.h
  helpers/Loader.cpp
  helpers/Loader.h
  config/Configuration.h
)
```

The should be all you need to do add custom logic and to rebuild and upload the project.

### Serial Monitor

To connect to the serial monitor using the TTY utility [`screen`](https://www.gnu.org/software/screen/), and assuming your Ardunio device is currently connected, run the following command (but replace 'MyProject' with the name of your project):

```bash
cd build
cmake ..
make
make upload
make MyProject-serial
```

> NOTE: To exit out of it, typically you would press Ctrl-A, followed by Ctrl-K, and then 'y' to kill the current session.
>
> NOTE: While you have this screen connected to your serial port on your device, you will NOT be able to upload new firmware. **You must disconnect the screen before you attempt to upload a new firmware**.

or in the case of the provided example:

```
make Adafruit7SDisplay-serial
```

#### Customizing Screen

If you would prefer to have screen show some additional information, just paste the below contents to the file `~/.screenrc` in your hom folder:

```
caption always "%-Lw%{= Yb}%50>%n%f* %t%{-}%+LW%< [ Ctrl-A is the Control Character ]"
hardstatus alwayslastline "%{bw}[ %H ] %{rw} %c:%s | %d.%m.%Y %{gw} Load: %l %{BW} %w "
```

## Auto-Generating New Projects

`arli` offers a special command called `generate`, which uses **this repo** as a template for creating a brand new project in a given local directory.

Here is how you can get started with Arduino projects using this tool:

 1. Download and Install Arduino SDK or IDE
 2. Verify that you have git, gcc, CMake on your system or install them
 3. Verify that you have a recent ruby by runnin `ruby --version`. You should see a version higher than 2.0.0, but ideally 2.3+.

Then run the following commands:

```bash
$ gem install arli --no-ri --no-rdoc
$ arli generate MyProject --workspace ~/workspace
$ cd ~/workspace/MyProject
$ mkdir build
$ cd build
$ cmake ..
$ make
```

This should result in a successful build, if all dependencies are found and installed. Please create a [github issue](https://github.com/kigster/arli-cmake/issues) if you run into problems.

The Readme for [Arli](https://github.com/kigster/arli#command-generate) CLI tool provides a detailed description of the `generate` command.



## Development

Fork the repo, create a feature branch, make your changes, and submit a pull-request. It's that simple!

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/kigster/arli-cmake](https://github.com/kigster/arli-cmake).

## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Author

 * [Konstantin Gredeskoul](https://github.com/kigster/)

To reach me, please use the Gliter, or you can tweet at @kig and I will respond to you as soon as I can.
