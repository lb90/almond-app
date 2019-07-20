COMPILER_CROSS=../x86_64-apple-darwin15-clang
COMPILER_NATIVE=clang

FLAGS_COMMON="-I../"
FLAGS_CROSS="-mmacos-version-min=10.6 -Wall"
FLAGS_NATIVE="-Wall"

rm -rf cross/
mkdir cross/

rm -rf native/
mkdir native/

$COMPILER_CROSS  $FLAGS_COMMON $FLAGS_CROSS  test_load_xtra.m -o cross/test_load_xtra
$COMPILER_NATIVE $FLAGS_COMMON $FLAGS_NATIVE test_mangler.m   -o native/test_mangler

