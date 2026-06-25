declare -gA _system_libs=(
  [brotli]=brotli
  [dav1d]=dav1d
  [flac]=flac
  [fontconfig]=fontconfig
  [freetype]=freetype2
  [harfbuzz]=harfbuzz
  [libdrm]=libdrm
  [libjpeg]=libjpeg-turbo
  [libwebp]=libwebp
  [libxml]=libxml2
  [libxslt]=libxslt
  [openh264]=openh264
  [opus]=opus
  [zlib]=minizip
  [zstd]=zstd
)
echo ${_system_libs[@]}
# fontconfig brotli libjpeg-turbo openh264 dav1d flac libdrm libxml2 zstd libwebp minizip opus libxslt harfbuzz freetype2

_unwanted_bundled_libs=(
  $(printf "%s\n" ${!_system_libs[@]} | sed 's/^libjpeg$/&_turbo/')
)
echo ${_unwanted_bundled_libs[@]}
# fontconfig brotli libjpeg_turbo openh264 dav1d flac libdrm libxml zstd libwebp zlib opus libxslt harfbuzz freetype

depends+=(${_system_libs[@]})

sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' tools/generate_shim_headers/generate_shim_headers.py

sed -i -e 's/\<xmlMalloc\>/malloc/' -e 's/\<xmlFree\>/free/' -e '1i #include <cstdlib>' \
    third_party/blink/renderer/core/xml/*.cc \
    third_party/blink/renderer/core/xml/parser/xml_document_parser.cc \
    third_party/libxml/chromium/*.cc

# Link to system tools required by the build
mkdir -pv third_party/node/linux/node-linux-x64/bin \
          third_party/jdk/current/bin

ln -sv /usr/bin/node third_party/node/linux/node-linux-x64/bin/
ln -sv /opt/jdk/bin/java third_party/jdk/current/bin/

# rustc needs profiler
mkdir -pv third_party/rust-toolchain/bin
ln -sv /opt/rustc/bin/rustc third_party/rust-toolchain/bin/
ln -sv /opt/rustc/bin/rustfmt third_party/rust-toolchain/bin/

# remove x86_64 binary and use our own
rm -fv third_party/gperf/cipd/bin/gperf
ln -sv /usr/bin/gperf third_party/gperf/cipd/bin/

for _lib in ${_unwanted_bundled_libs[@]}; do
    find "third_party/$_lib" -type f \
      \! -path "third_party/$_lib/chromium/*" \
      \! -path "third_party/$_lib/google/*" \
      \! -path "third_party/harfbuzz-ng/utils/hb_scoped.h" \
      \! -regex '.*\.\(gn\|gni\|isolate\)' \
      -delete
done

./build/linux/unbundle/replace_gn_files.py --system-libraries "${!_system_libs[@]}"

python3 build/util/lastchange.py -m DAWN_COMMIT_HASH \
    -s third_party/dawn --revision gpu/webgpu/DAWN_VERSION \
    --header gpu/webgpu/dawn_commit_hash.h

tar -xf ../chromium-launcher-8.tar.gz
make -C chromium-launcher-8

if (( !_system_clang )); then
    # Use prebuilt rust as system rust cannot be used due to the error:
    #   error: the option `Z` is only accepted on the nightly compiler
    ./tools/rust/update_rust.py

    # To link to rust libraries we need to compile with prebuilt clang
    ./tools/clang/scripts/update.py
fi
if (( _system_clang )); then
    export CC=clang
    export CXX=clang++
    export AR=ar
    export NM=nm
else
    local _clang_path="$PWD/third_party/llvm-build/Release+Asserts/bin"
    export CC=$_clang_path/clang
    export CXX=$_clang_path/clang++
    export AR=$_clang_path/llvm-ar
    export NM=$_clang_path/llvm-nm
fi
