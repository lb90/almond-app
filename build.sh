#!/bin/bash
set -u
set -e

COMPILER=apple-darwin15-clang
ALMOND_BIN=almond.app
ALMOND_DEBUG_BIN=almond-debug.app

FRAMEWORKS="-framework CoreFoundation -framework DiskArbitration -framework IOKit -framework Cocoa"
SOURCES="main.m process.m diskserial.m platformserial.m clipboard.m mangler.m util.m"

FLAGS="-mmacos-version-min=10.6 -Wall"

rm -rf i386/
mkdir i386/

rm -rf x86_64/
mkdir x86_64/

./i386-$COMPILER -O2 $FLAGS $FRAMEWORKS $SOURCES -o "i386/$ALMOND_BIN"
./i386-$COMPILER -g $FLAGS $FRAMEWORKS $SOURCES -o "i386/$ALMOND_DEBUG_BIN" -DALMOND_DEBUG
./x86_64-$COMPILER -O2 $FLAGS $FRAMEWORKS $SOURCES -o "x86_64/$ALMOND_BIN"
./x86_64-$COMPILER -g $FLAGS $FRAMEWORKS $SOURCES -o "x86_64/$ALMOND_DEBUG_BIN" -DALMOND_DEBUG

