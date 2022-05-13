#! /bin/bash
mkdir -p /tmp/trsrc
mkdir -p /src/cross/build/$BUILD_PREFIX
cp -r /src /tmp
cd /tmp/src
HAVE_CXX=yes ./configure --disable-nls --enable-daemon --enable-utp --disable-dependency-tracking --prefix=/src/cross/build/$BUILD_PREFIX
make -j4 && make install