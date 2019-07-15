COMPILER_CROSS=apple-darwin15-clang
COMPILER_NATIVE=clang

FLAGS_CROSS="-mmacos-version-min=10.6 -Wall"
FLAGS_NATIVE="-Wall"

rm -rf cross/
mkdir cross/

rm -rf native/
mkdir native/

../x86_64-$COMPILER_CROSS $FLAGS_CROSS test_load_xtra.m -o cross/test_load_xtra
../x86_64-$COMPILER_CROSS test_clipboard.m -o cross/test_clipboard
$COMPILER_NATIVE test_mangler.m -o native/test_mangler

