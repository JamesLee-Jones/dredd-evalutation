set -e
set -u
set -x

pushd "$DREDD_EVAL/third_party"

if [ ! -d "dawn" ]; then
  git clone https://dawn.googlesource.com/dawn  dawn
fi

cwd=$(pwd)

mkdir -p "$cwd/wgsl-tests"
find "$cwd/dawn/test/tint" -type f -name "*.wgsl" -exec cp {} "$cwd/wgsl-tests/" \;
rm -rf "$cwd"/wgsl-tests/*.expected.wgsl

mkdir -p "$cwd/spirv-tests/assembly"
mkdir -p "$cwd/spirv-tests/binary"
find "$cwd/dawn/test/tint" -type f -name "*.spvasm" -exec cp {} "$cwd/spirv-tests/assembly/" \;
rm -rf "$cwd"/spirv-tests/assembly/*.*.spvasm

for assembly_file in "$cwd"/spirv-tests/assembly/*; do
  spirv-as -o "$cwd/spirv-tests/binary/$(basename "${assembly_file%.*}.spv")" "$assembly_file"
done

rm -rf "$cwd/dawn$"

popd
