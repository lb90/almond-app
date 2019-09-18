#!/bin/bash
set -u
set -e

COMPILER=./i386-apple-darwin15-clang
TARGET_BIN=Peanut
TARGET_BUNDLE=Peanut.xtra

FRAMEWORKS="-framework Carbon -framework CoreFoundation -framework Cocoa"
BUNDLEFLAGS="-bundle -flat_namespace -undefined suppress -exported_symbols_list XDK/Include/MACMach/xtra_exports.txt"
ADDINCLUDES="-IXDK/Include"
ADDEFINES="-DUSING_INIT_FROM_DICT"
SOURCES="xtra.mm process.m util.m"
FLAGS="-mmacos-version-min=10.6"

if [ ! -d "$TARGET_BUNDLE/Contents/MacOS/" ]; then
  mkdir -p "$TARGET_BUNDLE/Contents/MacOS/"
fi

rm -f "$TARGET_BUNDLE/Contents/PkgInfo"
echo "XtraXown" > "$TARGET_BUNDLE/Contents/PkgInfo"

$COMPILER -O2 $BUNDLEFLAGS $ADDINCLUDES $ADDEFINES $FLAGS $FRAMEWORKS $SOURCES -o "$TARGET_BUNDLE/Contents/MacOS/$TARGET_BIN"

