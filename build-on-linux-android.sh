#!/usr/bin/env bash
set -e

# [variable]
export LIBSODIUM_FULL_BUILD=true
readonly VERSION="1.0.20-RELEASE"
readonly ROOT=$(pwd)
readonly DIR_DEST=${ROOT}/output
readonly DIR_LIBSODIUM=${ROOT}/libsodium

# export NDK_PLATFORM="android-19" # FOR PREVENT: 16 is less than minimum platform for arm (19)
export NDK_PLATFORM="android-21" # after upgrade ndk version, not found: armv7a-linux-androideabi19-clang

# [src] libsodium
git clone --branch ${VERSION} --depth 1 https://github.com/jedisct1/libsodium.git $DIR_LIBSODIUM
cd $DIR_LIBSODIUM

# ===========================
# Android
# ===========================
# [environment]
# export ANDROID_NDK_HOME=${ROOT}/android-ndk
# DIR_TEMP=${ROOT}/temp_dir
# 
# 
# # [sdk] Android NDK
# mkdir $DIR_TEMP && cd $DIR_TEMP
# wget -q https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip
# unzip -o -q android-ndk-r13b-linux-x86_64.zip
# mv $DIR_TEMP/android-ndk-r13b ${ANDROID_NDK_HOME}


# [generate]
echo "================================== armv7-a"
git clean -Xdf
./autogen.sh
./dist-build/android-armv7-a.sh || (cat config.log && exit 1)
mkdir -p $DIR_DEST/Plugins/Android/libs/armeabi-v7a
ls -al $DIR_LIBSODIUM/libsodium-android-armv7-a/lib
mv $DIR_LIBSODIUM/libsodium-android-armv7-a/lib/libsodium.a $DIR_LIBSODIUM/libsodium-android-armv7-a/lib/libsodium.so $DIR_DEST/Plugins/Android/libs/armeabi-v7a


echo "================================== armv8-a"
git clean -Xdf
export LDFLAGS="-Wl,-z,max-page-size=16384" # for 16kb support

./autogen.sh
./dist-build/android-armv8-a.sh || (cat config.log && exit 1)
mkdir -p $DIR_DEST/Plugins/Android/libs/armeabi-v8a
ls -al $DIR_LIBSODIUM/libsodium-android-armv8-a+crypto/lib
mv $DIR_LIBSODIUM/libsodium-android-armv8-a+crypto/lib/libsodium.a $DIR_LIBSODIUM/libsodium-android-armv8-a+crypto/lib/libsodium.so $DIR_DEST/Plugins/Android/libs/armeabi-v8a

unset LDFLAGS

echo "================================== x86"
git clean -Xdf
./autogen.sh
./dist-build/android-x86.sh || (cat config.log && exit 1)
mkdir -p $DIR_DEST/Plugins/Android/libs/x86
ls -al $DIR_LIBSODIUM/libsodium-android-i686/lib
mv $DIR_LIBSODIUM/libsodium-android-i686/lib/libsodium.a $DIR_LIBSODIUM/libsodium-android-i686/lib/libsodium.so $DIR_DEST/Plugins/Android/libs/x86


echo "================================== x86_64"
git clean -Xdf
./autogen.sh
./dist-build/android-x86_64.sh || (cat config.log && exit 1)
mkdir -p $DIR_DEST/Plugins/Android/libs/x86_64
ls -al $DIR_LIBSODIUM/libsodium-android-westmere/lib
mv $DIR_LIBSODIUM/libsodium-android-westmere/lib/libsodium.a $DIR_LIBSODIUM/libsodium-android-westmere/lib/libsodium.so $DIR_DEST/Plugins/Android/libs/x86_64

# Output : $DIR_DEST
