#!/bin/bash
ZSRC=${ZSRC:-/sources}
ZBUILD=${ZBUILD:-/zbuild}

zmsg() { printf "*** %s\n" "${@}"; }
zdie() { zmsg "${@}"; exit 1; }

get() { wget -c -nc -P "${ZSRC}" "${@}"; }
check() {
    local url="${1}"
    local md5="${2}"
    local archive=$(basename ${url})
    if [[ ! -f "${ZSRC}/${archive}" ]]; then
        get "${url}"
    fi
    echo "${md5}  ${ZSRC}/${archive}" | md5sum -c - || return 1
}
[ ! -x $(which cmake) ] && zdie "Error - Missing cmake"
[ ! -x $(which wget) ] && zdie "Error - Missing wget"

LLVM_SRC_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/llvm-20.1.8.src.tar.xz"
LLVM_SRC=$(basename ${LLVM_SRC_URL})
LLVM_SRC_MD5="78040509eb91309b4ec2edfe12cd20d8"

LLVM_CMAKE_SRC="https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-cmake-20.1.8.src.tar.xz"
LLVM_CMAKE_MD5="5bfb8f4b4a2b3ccffca0d2406e4cdcc6"
LLVM_CMAKE=$(basename ${LLVM_CMAKE_SRC})

LLVM_THIRDPARTY_URL="https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-third-party-20.1.8.src.tar.xz"
LLVM_THIRDPARTY_SRC=$(basename ${LLVM_THIRDPARTY_URL})
LLVM_THIRDPARTY_MD5="2ffd8624b3cbddf55a4e74a7d8ea89fa"

CLANG_SRC_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/clang-20.1.8.src.tar.xz"
CLANG_SRC=$(basename ${CLANG_SRC_URL})
CLANG_SRC_MD5="62a0500bb932868061607cde0c01f584"

COMPILER_RT_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/compiler-rt-20.1.8.src.tar.xz"
COMPILER_RT_SRC=$(basename ${COMPILER_RT_URL})
COMPILER_RT_MD5="3869861662d173ca8303b9f1524d1e91"

zmsg "Downloading Sources"
check "${LLVM_SRC_URL}" "${LLVM_SRC_MD5}" || zdie "Failure in ${LLVM_SRC}"
check "${LLVM_CMAKE_SRC}" "${LLVM_CMAKE_MD5}" || zdie "Failure in ${LLVM_CMAKE}"
check "${LLVM_THIRDPARTY_URL}" "${LLVM_THIRDPARTY_MD5}" || zdie "Failure in ${LLVM_THIRDPARTY_SRC}"
check "${CLANG_SRC_URL}" "${CLANG_SRC_MD5}" || zdie "Failure in ${CLANG_SRC}"
check "${COMPILER_RT_URL}" "${COMPILER_RT_MD5}" || zdie "Failure in ${COMPILER_RT_SRC}"

zmsg "Extracting Sources"
packagedir=${LLVM_SRC%%.src.tar.*}
mkdir -v $ZBUILD/tmp/$packagedir

tar -xf "$ZSRC/$LLVM_SRC" -C "$ZBUILD/tmp/$packagedir" --strip-components=1 || zdie "Failure in Extracting: $LLVM_SRC"

pushd $ZBUILD/tmp/$packagedir
    tar -xf "$ZSRC/$LLVM_CMAKE"
    tar -xf $ZSRC/$LLVM_THIRDPARTY_SRC

    sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@cmake-20.1.8.src@' -i CMakeLists.txt
    sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@third-party-20.1.8.src@' -i cmake/modules/HandleLLVMOptions.cmake

    tar -xf $ZSRC/$CLANG_SRC -C tools
    mv -v tools/clang-20.1.8.src tools/clang

    tar -xf $ZSRC/$COMPILER_RT_SRC -C projects
    mv -v projects/compiler-rt-20.1.8.src projects/compiler-rt

    zmsg "Configuring $LLVM_SRC"
    grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'
    sed 's/utility/tool/' -i utils/FileCheck/CMakeLists.txt

    mkdir -v build
    CC=gcc CXX=g++ \
    cmake -B build -D CMAKE_INSTALL_PREFIX=/usr -D CMAKE_BUILD_TYPE=Release -D CMAKE_SKIP_INSTALL_RPATH=ON \
    -D LLVM_ENABLE_FFI=ON -D LLVM_BUILD_LLVM_DYLIB=ON -D LLVM_LINK_LLVM_DYLIB=ON -D LLVM_ENABLE_RTTI=ON \
    -D LLVM_TARGETS_TO_BUILD="host;AMDGPU" -D LLVM_BINUTILS_INCDIR=/usr/include -D LLVM_INCLUDE_BENCHMARKS=OFF \
    -D CLANG_DEFAULT_PIE_ON_LINUX=ON -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang -W no-dev -G Ninja

    zmsg "Building $LLVM_SRC"
    cd build && ninja

    zmsg "Testing $LLVM_SRC"
    sed -e 's/config.has_no_default_config_flag/True/' -e 's/"-fuse-ld=gold"//' \
    -i ../projects/compiler-rt/test/lit.common.cfg.py

    ninja check-all

    zmsg "Installing $LLVM_SRC"
    ninja install
popd

zmsg "Finalizing $LLVM_SRC"
mkdir -pv /etc/clang
for i in clang clang++; do
    echo -fstack-protector-strong > /etc/clang/$i.cfg
done
echo "llvm - 20.1.8 - ${LLVM_SRC_URL}" >> ${ZBUILD}/zpackage.db
