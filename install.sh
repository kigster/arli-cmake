#!/usr/bin/env bash

set -e

dep_dir="deps/arduino-cmake/cmake"
mkdir -p deps
git clone git@github.com:arduino-cmake/arduino-cmake deps/arduino-cmake
for file in $(ls -1 ${dep_dir}); do
  cd cmake
  echo linking ${file}...
  ln -nfs ../${dep_dir}/$file
  cd - > /dev/null
done

set +e
