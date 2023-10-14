#!/usr/bin/env bash
set -e
export LIBSODIUM_FULL_BUILD=true

# [variable]
ROOT=$(pwd)
DIR_DEST=${ROOT}/output
DIR_LIBSODIUM=${ROOT}/libsodium

# [for Docker environment]
# RUN apt-get update && \
#     apt-get -y install \
#     git \
#     curl \
#     wget \
#     python \
#     build-essential \
#     autotools-dev \
#     autoconf \
#     automake \
#     autogen \
#     gettext-base \
#     gettext \
#     binutils \
#     libtool \
#     unzip && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# [variable]

# [src] libsodium
git clone -b 1.0.19 --depth 1 https://github.com/jedisct1/libsodium.git && cd libsodium

# configure
libtoolize --force
aclocal
# autoheader
autoconf
automake --force-missing --add-missing
chmod +x ./configure

# compile
mkdir .libs/
./configure --prefix=`pwd`/.libs/ && make && make install

mkdir -p $DIR_DEST/Plugins/linux
cp -r .libs/lib/* $DIR_DEST/Plugins/linux/
