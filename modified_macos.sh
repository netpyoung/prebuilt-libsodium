#! /bin/sh

# modified macos.sh for support both arm64 and x86_64
export ARCHFLAGS="-arch x86_64 -arch arm64"

export PREFIX="$(pwd)/libsodium-osx"
export MACOS_VERSION_MIN=${MACOS_VERSION_MIN-"10.10"}

if [ -z "$LIBSODIUM_FULL_BUILD" ]; then
  export LIBSODIUM_ENABLE_MINIMAL_FLAG="--enable-minimal"
else
  export LIBSODIUM_ENABLE_MINIMAL_FLAG=""
fi

NPROCESSORS=$(getconf NPROCESSORS_ONLN 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null)
PROCESSORS=${NPROCESSORS:-3}

mkdir -p $PREFIX || exit 1

export CFLAGS="${ARCHFLAGS} -mmacosx-version-min=${MACOS_VERSION_MIN} -Ofast"
export LDFLAGS="${ARCHFLAGS} -mmacosx-version-min=${MACOS_VERSION_MIN}"

make distclean >/dev/null
./configure ${LIBSODIUM_ENABLE_MINIMAL_FLAG} \
  --prefix="$PREFIX" || exit 1
make -j${PROCESSORS} check && make -j${PROCESSORS} install || exit 1

# Cleanup
make distclean >/dev/null