#!/bin/bash
set -u
set -e

COMPILER=./i386-apple-darwin15-clang++
ALMOND_BIN=Almond
ALMOND_BUNDLE=Almond.xtra

FRAMEWORKS="-framework Carbon -framework CoreFoundation -framework DiskArbitration -framework IOKit -framework Cocoa"
BUNDLEFLAGS="-bundle -exported_symbols_list XDK/Include/MACMach/xtra_exports.txt"
ADDINCLUDES="-IXDK/Include"
ADDEFINES="-DUSING_INIT_FROM_DICT"
SOURCES="xtra.mm process.m diskserial.m platformserial.m mangler.m clipboard.m util.m"
FLAGS="-mmacos-version-min=10.6"

if [ ! -d "$ALMOND_BUNDLE/Contents/MacOS/" ]; then
  mkdir -p "$ALMOND_BUNDLE/Contents/MacOS/"
fi

rm -f "$ALMOND_BUNDLE/Contents/PkgInfo"
echo "XtraXown" > "$ALMOND_BUNDLE/Contents/PkgInfo"

$COMPILER -O2 $BUNDLEFLAGS $ADDINCLUDES $ADDEFINES $FLAGS $FRAMEWORKS $SOURCES -o "$ALMOND_BUNDLE/Contents/MacOS/$ALMOND_BIN"

