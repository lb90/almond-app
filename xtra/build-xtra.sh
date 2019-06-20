#!/bin/bash
set -u
set -e

COMPILER=apple-darwin15-clang
ALMOND_XTRA=almond.xtra

FRAMEWORKS="-framework Carbon -framework CoreServices -framework CoreFoundation -framework DiskArbitration -framework IOKit -framework Cocoa"
BUNDLEFLAGS="-bundle -flat_namespace -undefined suppress -exported_symbols_list XDK11/Include/MACMach/xtra_exports.txt"
ADDINCLUDES="-IXDK11/Include"
SOURCES="xtra.mm ../process.m ../diskserial.m ../platformserial.m ../clipboard.m ../mangler.m ../util.m"

FLAGS="-mmacos-version-min=10.6 -Wall -ObjC++"

rm -rf i386/
mkdir i386/

rm -rf x86_64/
mkdir x86_64/

../i386-$COMPILER -O2 $BUNDLEFLAGS $ADDINCLUDES $FLAGS $FRAMEWORKS $SOURCES -o "i386/$ALMOND_XTRA"
../x86_64-$COMPILER -O2 $BUNDLEFLAGS $ADDINCLUDES $FLAGS $FRAMEWORKS $SOURCES -o "x86_64/$ALMOND_XTRA"

