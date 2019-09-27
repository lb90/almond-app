#!/bin/bash
set -u
set -e

COMPILER=./i386-apple-darwin15-clang
TARGET_BIN=Peanut
TARGET_BUNDLE=Peanut.xtra

FRAMEWORKS="-framework Carbon"
BUNDLEFLAGS="-bundle -exported_symbols_list XDK/Include/MACMach/xtra_exports.txt"
ADDINCLUDES="-IXDK/Include"
ADDEFINES="-DUSING_INIT_FROM_DICT"
SOURCES="xtra.mm peanut.m util.m log.m"
FLAGS="-x c++ -arch i386 -mmacos-version-min=10.6"

if [ ! -d "$TARGET_BUNDLE/Contents/MacOS/" ]; then
  mkdir -p "$TARGET_BUNDLE/Contents/MacOS/"
fi

rm -f "$TARGET_BUNDLE/Contents/PkgInfo"
echo "XtraXown" > "$TARGET_BUNDLE/Contents/PkgInfo"

$COMPILER -O2 $BUNDLEFLAGS $ADDINCLUDES $ADDEFINES $FLAGS $FRAMEWORKS $SOURCES -o "$TARGET_BUNDLE/Contents/MacOS/$TARGET_BIN"

