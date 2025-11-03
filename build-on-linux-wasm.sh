#!/usr/bin/env bash
set -e

# [variable]
export LIBSODIUM_FULL_BUILD=true
readonly VERSION="1.0.20-RELEASE"
readonly ROOT=$(pwd)
readonly DIR_DEST=${ROOT}/output
readonly DIR_LIBSODIUM=${ROOT}/libsodium

# [variable]

# [src] libsodium
git clone --branch ${VERSION} --depth 1 https://github.com/jedisct1/libsodium.git
cd libsodium


# compile
./dist-build/emscripten.sh --standard

mkdir -p $DIR_DEST/Plugins/WebGL
cp -r libsodium-js/lib/libsodium.a $DIR_DEST/Plugins/WebGL/

