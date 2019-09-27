COMPILER_CROSS=../i386-apple-darwin15-clang++
COMPILER_NATIVE=clang++

FRAMEWORKS="-framework Carbon"
FLAGS_COMMON="-I../"
FLAGS_CROSS="-mmacos-version-min=10.6 -Wall"
FLAGS_NATIVE="-Wall"

rm -rf cross/
mkdir cross/

rm -rf native/
mkdir native/

$COMPILER_CROSS  $FLAGS_COMMON $FLAGS_CROSS  test_load_xtra.m -o cross/test_load_xtra
$COMPILER_CROSS  $FLAGS_COMMON $FLAGS_CROSS $FRAMEWORKS test_application.m ../peanut.m ../log.m ../util.m -o cross/test_application

