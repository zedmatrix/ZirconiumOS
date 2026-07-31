#!/bin/sh

echo "Preparing llvm-cmake"
tar -xf ${YSRC}/llvm-cmake-${PKGVER}.src.tar.xz
sed "/LLVM_COMMON_CMAKE_UTILS/s@../cmake@cmake-${PKGVER}.src@" -i CMakeLists.txt

echo "Preparing llvm-third-party"
tar -xf ${YSRC}/llvm-third-party-${PKGVER}.src.tar.xz
sed "/LLVM_THIRD_PARTY_DIR/s@../third-party@third-party-${PKGVER}.src@" -i cmake/modules/HandleLLVMOptions.cmake

echo "Preparing clang"
tar -xf ${YSRC}/clang-${PKGVER}.src.tar.xz -C tools &&
mv tools/clang-${PKGVER}.src tools/clang

echo "Preparing compiler-rt"
tar -xf ${YSRC}/compiler-rt-${PKGVER}.src.tar.xz -C projects &&
mv projects/compiler-rt-${PKGVER}.src projects/compiler-rt

echo "Patching /usr/bin/env python "
grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'

echo "Ensure installing the FileCheck program"
sed 's/utility/tool/' -i utils/FileCheck/CMakeLists.txt

echo "DONE"
