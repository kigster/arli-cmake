[![Build Status](https://travis-ci.org/kigster/arli-cmake.svg?branch=master)](https://travis-ci.org/kigster/arli-cmake)
[![Gitter](https://img.shields.io/gitter/room/gitterHQ/gitter.svg)](https://gitter.im/arduino-cmake-arli/)

# Arli CMake

## Introduction

> ### This project builds on top of the powerful Arduino build system  [arduino-cmake](https://github.com/arduino-cmake/arduino-cmake), and it provides additional features that streamline project creation, building, and library management. It's especially useful for bigger projects written in C/C++ that might rely on a large number of third-party libraries. This part is handled using [Arli](https://github.com/kigster/arli) — an Arduino Library manager, and a project generator.

### Overview

The added value of this project is that you can start right away without much understanding of how `CMake` works. It helps to understand it, no doubt, but you should be able to build and upload your firmware, as well as monitor it over a serial connection by adding your custom code to the `src` folder, updating `Arlifile`, and `src/CmakeLists.txt` file.

### Added Features as compared to `arduino-cmake`

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

* there are two separate example projects are provided:
  * The `examples` folder contains a real example with a couple of library dependencies,
  * The `src` folder is basically a stripped down "template" project. It's also used as a template when you use Arli to generate a new project like so:

    ```bash
    $ arli generate ProjectName --workspace ~/code
    $ cd ~/code/ProjectName
    $ bin/build
    ```

    The `src` folder will be your starting point in your new project, and `arli` will rename all the files for you to match your new project name.

* There is a convenient shell script `bin/build` that passes it's arguments to `make`. One exception is `clean` which removes the build folder.

    ```bash
     # usage: bin/build [ clean | upload | other make flags ]
     $ bin/build
    ````

   As part of the build process, CMake will run `arli bundle` inside your src folder, which generates a CMake include file `Arlifile.cmake`. This file builds all of the external libraries listed as dependencies in `Arlifile`.

### Arlifile

Here is an example of the `Arlifile` provided with the example project:

```YAML
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

As you can see, you can define three types of dependent libraries:

 1. Build and link with third party libraries in the `dependencies:` array
 2. Link with provided hardware libraries in the `device.libraries.hardware` array
 3. Build and link with Arduino-supplied standard libraries in the `device.libraries.arduino` array

Note that each array member is a hash, that can contain `name`, `url`, `version` or any other attributes that define the library uniquely.

> NOTE: to get the list of attributes, run `arli -A`

### Auto-Generate your next Arduino Project or Import Existing

`arli` offers a special command called `generate`, which uses **this repo** as a template for creating a brand new project in a given local directory.

Here is how you can get started with Arduino projects using this tool:

 1. Download and Install Arduino SDK or IDE
 2. Verify that you have git, gcc, CMake on your system or install them
 3. Verify that you have a recent ruby by runnin `ruby --version`. You should see a version higher than 2.0.0, but ideally 2.3+.

Then,

```bash
$ gem install arli --no-ri --no-rdoc
$ arli generate MyProject --workspace ~/workspace
$ cd ~/workspace/MyProject
$ bin/build
```

This should result in a successful build, if all dependencies are found and installed. Please create a [github issue](https://github.com/kigster/arli-cmake/issues) if you run into problems.

The Readme for [Arli](https://github.com/kigster/arli#command-generate) CLI tool provides a detailed description of the `generate` command.


### Prerequisites

 * On a Mac, you always need to run `xcode-select --install` before you can do any development. You must have `git` installed

 * Requires [CMake](https://cmake.org/download/)

 * Requires Arduino IDE or SDK installed

 * Requires ruby, 2.3 or 2.4+ installed. However, if you don't have it installed, the `bin/setup` script will prompt you to install it.

### Install

The project comes with a BASH helper `bin/build` which can be used to setup all of the dependencies of the project, and then build it.

If you run it without any arguments, it will do both — the setup and the build. You can pass `setup` argument to just do the setup.

```bash
$ git clone https://github.com/kigster/arli-cmake
$ cd arli-cmake
$ bin/build setup
```

This should verify and download all dependencies. After that, you should be able to run the builds.

### Scripted Build

A very basic supplied build script can be used to build the project from the top level, and is provided as a helper to those that are lazy (like me).

```bash
$ bin/build
```

The script accepts a few arguments, so run

```bash
$ bin/build -h
```

to get the available options.

### Manual Builds

Instead of using `bin/build` we can also build manually, which gives us more flexibility. For example, this is how we can start a serial monitor.

Once you run the setup, manual build is:

```bash
$ gem install arli
$ rm -rf build && mkdir -p build && cd build
$ cmake ..
$ make
```

### Serial Monitor

To connect to the serial monitor using the TTY utility [`screen`](https://www.gnu.org/software/screen/), and assuming your Ardunio device is currently connected, run the following command (but replace 'MyProject' with the name of your project):

```bash
make MyProject-serial
```

> NOTE: To exit out of it, typically you would press Ctrl-A, followed by Ctrl-K, and then 'y' to kill the current session.
>
> NOTE: While you have this screen connected to your serial port on your device, you will NOT be able to upload new firmware. **You must disconnect the screen before you attempt to upload a new firmware**.

or in the case of the provided example:

```
make Adafruit7SDisplay-serial
```


> ### Customizing Screen
>
> If you would prefer to have screen show some additional information, just paste the below contents to the file `~/.screenrc` in your hom folder:
>
> ```
> caption always "%-Lw%{= Yb}%50>%n%f* %t%{-}%+LW%< [ Ctrl-A is the Control Character ]"
> hardstatus alwayslastline "%{bw}[ %H ] %{rw} %c:%s | %d.%m.%Y %{gw} Load: %l %{BW} %w "
> ```


## Development

Fork the repo, create a feature branch, make your changes, and submit a pull-request. It's that simple!

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/kigster/arli-cmake](https://github.com/kigster/arli-cmake).

## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Author

 * [Konstantin Gredeskoul](https://github.com/kigster/)

To reach me, please use the Gliter, or you can tweet at @kig and I will respond to you as soon as I can.
