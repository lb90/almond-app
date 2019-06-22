#!/bin/bash
set -u
set -e

COMPILER=apple-darwin15-clang
ALMOND_XTRA=Almond
ALMOND_BUNDLE=Almond.xtra

FRAMEWORKS="-framework Carbon -framework CoreServices -framework CoreFoundation -framework DiskArbitration -framework IOKit -framework Cocoa"
BUNDLEFLAGS="-bundle -flat_namespace -undefined suppress -exported_symbols_list XDK/Include/MACMach/xtra_exports.txt"
ADDINCLUDES="-IXDK/Include"
SOURCES="xtra.mm ../process.m ../diskserial.m ../platformserial.m ../clipboard.m ../mangler.m ../util.m"

FLAGS="-mmacos-version-min=10.6"

../i386-$COMPILER -O2 $BUNDLEFLAGS $ADDINCLUDES $FLAGS $FRAMEWORKS $SOURCES -o "$ALMOND_BUNDLE/Contents/MacOS/$ALMOND_XTRA"

