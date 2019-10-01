COMPILER_CROSS=../i386-apple-darwin15-clang++
COMPILER_NATIVE=clang++

FRAMEWORKS="-framework Carbon -framework Foundation"
FLAGS_COMMON="-I../"
FLAGS_CROSS="-mmacos-version-min=10.6 -Wall"
FLAGS_NATIVE="-Wall"

echo "Make Tests"

rm -rf cross/
mkdir cross/

rm -rf native/
mkdir native/

$COMPILER_CROSS  $FLAGS_COMMON $FLAGS_CROSS  test_load_xtra.mm -o cross/test_load_xtra
$COMPILER_CROSS  $FLAGS_COMMON $FLAGS_CROSS $FRAMEWORKS test_application.mm ../peanut.mm ../log.mm ../util.mm ../macutil.mm -o cross/test_application

