#!/usr/bin/env bash
set -e

# [variable]

# [src] libsodium
git clone -b 1.0.18 --depth 1 https://github.com/jedisct1/libsodium.git && cd libsodium

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
