#!/bin/bash

set -uexo pipefail

source "$CIRCLE_WORKING_DIRECTORY/.circleci/util.sh"

if [ "$(os)" = "darwin" ]; then
  export MACOSX_DEPLOYMENT_TARGET=10.9
fi

version="$(llvm_version)"
install_path="$CIRCLE_WORKING_DIRECTORY/llvm-$version"

function build {
  mkdir build
  pushd build

  cmake ../llvm \
    -DLLVM_ENABLE_PROJECTS=clang \
    -DLIBCLANG_BUILD_STATIC=On \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$install_path"

  make -j2
  popd
}

function install {
  pushd build
  cmake --build . --target install
  cp lib/libclang.a "$install_path"/lib
  popd
}

function archive {
  tar --verbose -J -c -f "$CIRCLE_WORKING_DIRECTORY/$(archive_name)" "$install_path"
}

build
install
archive
