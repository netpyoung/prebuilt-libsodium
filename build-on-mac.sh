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
git clone --branch 1.0.20-RELEASE --depth 1 https://github.com/jedisct1/libsodium.git $DIR_LIBSODIUM && cd $DIR_LIBSODIUM

# replace macos.sh with modified_macos.sh
cp $ROOT/modified_macos.sh $DIR_LIBSODIUM/dist-build/macos.sh
./autogen.sh
./dist-build/macos.sh
mkdir -p $DIR_DEST/Plugins/x64

PATH_LIBSODIUM=`realpath $DIR_LIBSODIUM/libsodium-osx/lib/libsodium.dylib`
otool -L $PATH_LIBSODIUM
install_name_tool -id @loader_path/sodium.bundle $PATH_LIBSODIUM

cp $PATH_LIBSODIUM $DIR_DEST/Plugins/x64/sodium.bundle

echo "lipo -info $PATH_LIBSODIUM"
lipo -info $PATH_LIBSODIUM

echo "otool -L $PATH_LIBSODIUM"
otool -L $PATH_LIBSODIUM
