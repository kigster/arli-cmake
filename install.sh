#!/usr/bin/env bash

set -e

dep_dir="deps/arduino-cmake"
dep_url="https://github.com/arduino-cmake/arduino-cmake" 

[[ -d ${dep_dir} ]] && rm -rf ${dep_dir}
mkdir -p deps
git clone ${dep_url} ${dep_dir}
for file in $(ls -1 ${dep_dir}/cmake); do
  cd cmake
  echo linking ${file}...
  ln -nfs ../${dep_dir}/cmake/$file
  cd - > /dev/null
done

cd example
arli bundle
rm -rf build
mkdir -p build
cd build
cmake ..
make

set +e
