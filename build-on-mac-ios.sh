#!/usr/bin/env bash
set -e
export LIBSODIUM_FULL_BUILD=true

readonly IOS_MIN_VERSION=6.0

# ===========================
# macOs, iOs
# ===========================
# [brew] install dependencies
# packages='libtool autoconf automake'
# brew update
# for pkg in ${packages}; do
#     if brew list -1 | grep -q "^${pkg}\$"; then
#         echo "Package '$pkg' is installed"
#         #brew upgrade $pkg
#     else
#         echo "Package '$pkg' is not installed"
#         brew install $pkg
#     fi
# done
# brew upgrade ${packages} || true


# [variable]
ROOT=$(pwd)
DIR_DEST=${ROOT}/output
DIR_LIBSODIUM=${ROOT}/libsodium


# [src] libsodium
git clone -b 1.0.19 --depth 1 https://github.com/jedisct1/libsodium.git $DIR_LIBSODIUM && cd $DIR_LIBSODIUM

# [generate]
## generate for ios
./autogen.sh -s
./dist-build/apple-xcframework.sh
mkdir -p $DIR_DEST/Plugins/iOS
cp -r $DIR_LIBSODIUM/libsodium-apple/Clibsodium.xcframework $DIR_DEST/Plugins/iOS/Clibsodium.xcframework

