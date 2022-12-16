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
git clone -b 1.0.18 --depth 1 https://github.com/jedisct1/libsodium.git $DIR_LIBSODIUM && cd $DIR_LIBSODIUM

# configure
./autogen.sh

# [generate]
git clean -Xdf
./autogen.sh
./dist-build/ios.sh
mkdir -p $DIR_DEST/Plugins/iOS
cp $DIR_LIBSODIUM/libsodium-ios/lib/libsodium.a $DIR_DEST/Plugins/iOS/libsodium.a


git clean -Xdf

# replace osx.sh with modified_osx.sh
cp $ROOT/modified_osx.sh $DIR_LIBSODIUM/dist-build/osx.sh

./autogen.sh
./dist-build/osx.sh
mkdir -p $DIR_DEST/Plugins/x64
cp $DIR_LIBSODIUM/libsodium-osx/lib/libsodium.*.dylib $DIR_DEST/Plugins/x64/sodium.bundle

echo "lipo -info $DIR_LIBSODIUM/libsodium-osx/lib/libsodium.*.dylib"
lipo -info $DIR_LIBSODIUM/libsodium-osx/lib/libsodium.*.dylib