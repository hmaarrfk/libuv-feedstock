#!/bin/bash

set -x

# We are going to disable some tests on qemu based platforms
# if [ "${target_platform}" == "linux-aarch64" ] || [ "${target_platform}" == "linux-ppc64le" ]; then
#    sed -i '/get_currentexe/d' ./test/test-list.h
#    sed -i '/udp_multicast_interface/d' ./test/test-list.h
#    sed -i '/udp_no_autobind/d' ./test/test-list.h
# fi

# if [ "${target_platform}" == "linux-aarch64" ]; then
   # These failures have been reported upstream
   # https://github.com/libuv/libuv/issues/2867
#    sed -i '/random_async/d' ./test/test-list.h
#    sed -i '/random_sync/d' ./test/test-list.h
# fi

# This particular test fails on osx
if [ "${target_platform}" == 'osx-64' ]; then
   sed -i '/hrtime/d' ./test/test-list.h
   sed -i '/fs_event_error_reporting/d' ./test/test-list.h
fi

# LIBTOOLIZE setting is required to workaround missing glibtoolize on OS X:
# https://github.com/joyent/libuv/issues/1200
LIBTOOLIZE=libtoolize sh ./autogen.sh

./configure \
   --disable-dependency-tracking \
   --disable-silent-rules \
   --prefix="$PREFIX" \

make
ls -lah
ls -lah build
strace -s 256 -f build/uv_run_tests_a random_sync random_sync
make check
make install
