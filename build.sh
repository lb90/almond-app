#!/bin/bash
set -u
set -e

COMPILER=build/i386-apple-darwin15-clang
ALMOND_BIN=Almond
ALMOND_BUNDLE=Almond.xtra

FRAMEWORKS="-framework Carbon -framework CoreFoundation -framework DiskArbitration -framework IOKit -framework Cocoa"
BUNDLEFLAGS="-bundle -flat_namespace -undefined suppress -exported_symbols_list XDK/Include/MACMach/xtra_exports.txt"
ADDINCLUDES="-IXDK/Include"
SOURCES="xtra.mm process.m diskserial.m platformserial.m mangler.m util.m"
FLAGS="-mmacos-version-min=10.6"

$COMPILER -O2 $BUNDLEFLAGS $ADDINCLUDES $FLAGS $FRAMEWORKS $SOURCES -o "build/$ALMOND_BUNDLE/Contents/MacOS/$ALMOND_BIN"

