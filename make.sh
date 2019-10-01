#!/bin/bash
set -u
set -e

COMPILER=./i386-apple-darwin15-clang++
TARGET=Peanut
TARGET_UPCASE=PEANUT

FRAMEWORKS="-framework Carbon -framework Foundation"
BUNDLEFLAGS="-bundle -exported_symbols_list XDK/Include/MACMach/xtra_exports.txt"
ADDINCLUDES="-IXDK/Include"
ADDEFINES="-DUSING_INIT_FROM_DICT"
SOURCES="xtra.mm peanut.mm util.mm macutil.mm log.mm"
FLAGS="-mmacos-version-min=10.6"

echo "Make Xtra" #rosso scuro e grassetto

if [ ! -d "${TARGET}.xtra/Contents/MacOS/" ]; then
  mkdir -p "${TARGET}.xtra/Contents/MacOS/"
fi
rm -f "${TARGET}.xtra/Contents/PkgInfo"
echo "XtraXown" > "${TARGET}.xtra/Contents/PkgInfo"

if [ ! -d "${TARGET}_log.xtra/Contents/MacOS/" ]; then
  mkdir -p "${TARGET}_log.xtra/Contents/MacOS/"
fi
rm -f "${TARGET}_log.xtra/Contents/PkgInfo"
echo "XtraXown" > "${TARGET}_log.xtra/Contents/PkgInfo"

if [ ! -d "${TARGET}_dbg.xtra/Contents/MacOS/" ]; then
  mkdir -p "${TARGET}_dbg.xtra/Contents/MacOS/"
fi
rm -f "${TARGET}_dbg.xtra/Contents/PkgInfo"
echo "XtraXown" > "${TARGET}_dbg.xtra/Contents/PkgInfo"

echo "Rel" #verde e grassetto
$COMPILER -O2 $BUNDLEFLAGS $ADDINCLUDES $ADDEFINES $FLAGS $FRAMEWORKS $SOURCES -o "${TARGET}.xtra/Contents/MacOS/${TARGET}"
echo "Log" #verde e grassetto
$COMPILER -O2 $BUNDLEFLAGS $ADDINCLUDES $ADDEFINES -D${TARGET_UPCASE}_LOG $FLAGS $FRAMEWORKS $SOURCES -o "${TARGET}_log.xtra/Contents/MacOS/${TARGET}_log"
echo "Dbg" #verde e grassetto
$COMPILER -g $BUNDLEFLAGS $ADDINCLUDES $ADDEFINES -D${TARGET_UPCASE}_DEBUG $FLAGS $FRAMEWORKS $SOURCES -o "${TARGET}_dbg.xtra/Contents/MacOS/${TARGET}_dbg"

echo "Deploy Xtra..." #rosso scuro e grassetto
DEPLOY_DIR=$(date +%d%b%Y)
mkdir -p "build/$DEPLOY_DIR"

cp -p -r "${TARGET}.xtra" "build/$DEPLOY_DIR"
cp -p -r "${TARGET}_log.xtra" "build/$DEPLOY_DIR"

echo "done."

