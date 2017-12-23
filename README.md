[![Build Status](https://travis-ci.org/kigster/arli-cmake.svg?branch=master)](https://travis-ci.org/kigster/arli-cmake)

# Arli CMake

This project provides additional CMAKE helpers to build third-party libraries installed automatically using the [Arli library manager](https://github.com/kigster/arli) and a supplied `Arlifile`. It builds atop of the powerful [arduino-cmake](https://github.com/arduino-cmake/arduino-cmake) project, but helps with larger projects with many external library dependencies.

## Usage

### Prerequisites 

Requires ruby, 2.3 or 2.4+ installed.

### Install

Run the following commands in your shell:

```bash
$ gem install arli
$ git clone https://github.com/kigster/arli-cmake
$ cd arli-cmake
./install.sh
```
This should download dependencies and build the project in `example/build` folder.

### Dependency on arduino-cmake

The install script will clone arduino-cmake locally, and create symlinks from the cmake folder.

This is likely a temporary solution. Another option is git submodule.

## CMAKE Helpers

Please inspect the `cmake` folder to see additional helpers added on top of arduino-cmake.

## LICENSE

MIT

