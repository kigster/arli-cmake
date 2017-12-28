[![Build Status](https://travis-ci.org/kigster/arli-cmake.svg?branch=master)](https://travis-ci.org/kigster/arli-cmake)
[![Gitter](https://img.shields.io/gitter/room/gitterHQ/gitter.svg)](https://gitter.im/arduino-cmake-arli/)

# Arli CMake

> ### This project builds on top of `arduino-cmake` and allows you to quickly get started with building complex C/C++ Arduino Sketches, with automatic library dependency management in any IDE, using `arli` command line tool.

### Summary

This project provides additional CMAKE helpers to build third-party libraries installed automatically using the [Arli library manager](https://github.com/kigster/arli) and a provided custom `Arlifile`. It builds atop of the powerful [arduino-cmake](https://github.com/arduino-cmake/arduino-cmake) project.

The added value is that you can start right away without much understanding of how CMake works. It helps, no doubt, but you should be able to build and upload your firmware, as well as monitor it over a serial connection, with little to no changes.

### Added Features as Compared to Arduino-CMake
 
This project compliments [arduino-cmake](https://github.com/arduino-cmake/arduino-cmake) by providing additional CMake functions which offers the following features:

 * a comprehensive **third-party Arduino library installation**, download, compilation and linking into a static `.a.` library.

 * **automatic serial device detection** (that should work on Mac OSX and Unix, but unfortunately not on Windows). This feature is particularly useful if only one matching device is found — then you don't need to specify it manually. Plus, if you plug in another board, `cmake` will automatically detect the new serial device (just don't forget to remove the other board, as this only works when only one device is plugged in).

 * Alternatively, you can override board name, cpu and the Serial Port (device) by using these environment variables: 

    ```bash
    cd src/build
    BOARD_NAME=nano \
     BOARD_CPU=atmega328p \
     BOARD_DEVICE=/dev/tty.usbserial-DA00WXFY \
     cmake ..
    ```

* each source project relies on single file `Arlifile` (in YAML format) that **defines external library dependencies, as well as the board name, CPU and the hardware libraries** that may be necesary.
 
* there are two separate example projects are provided: 
  * The `examples` folder contains a real example with a couple of library dependencies,
  * Tne `src` folder is basically a strippped down "template" project. It's also used as a template when you use Arli to generate a new project like so: 

       
        $ arli generate ProjectName -w ~/workspace
       

       the `src` folder will be your starting point in your new project, and `arli` will rename all the files for you to match your new project name.

* There is a convenient shell script `bin/build` that expects a top-level folder as an argument, for example: 

  ```bash
       # usage: bin/build [ source folder ] 
       $ bin/build example
  ````

   As part of the build process, CMake will run `arli bundle` inside your src folder, which genrates a CMake includue file `Arlifile.cmake`. This file contains all of the code necessary to build all of the external libraries listed as dependencies in the `Arlifile`.

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
$ bin/setup
$ bin/build src
```

This should result in a successful build, if all dependenies are found and installed. Please create a [github issue](https://github.com/kigster/arli-cmake/issues) if you run into problems.

The Readme for [Arli](https://github.com/kigster/arli#command-generate) CLI tool provides a detailed description of the `generate` command.


### Prerequisites

 * On a Mac, you always need to run `xcode-select --install` before you can do any development. You must have `git` installed;

 * Requires [CMake](https://cmake.org/download/);

 * Requires Arduino IDE or SDK installed;

 * Requires ruby, 2.3 or 2.4+ installed. However, if you don't have it installed, the `bin/setup` script will prompt you to install it.

### Install

Run the following commands in your shell:

```bash
$ git clone https://github.com/kigster/arli-cmake
$ cd arli-cmake
$ bin/setup
```

This should verify and download all dependencies. After that, you should be able to run the builds.

### Scripted Builds

A very basic supplied build script can be used to build the project from the top level, and is provided as a helper to those that are lazy (like me).

```bash
$ bin/build example
$ bin/build src
```

### Manual Builds

Instead of using `bin/build` we can also build manually, which gives us more flexibility. For example, this is how we can start a serial monitor.

Once you run the setup, manual build is:

```bash
$ gem install arli
$ cd src
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
