#!/bin/bash
SOURCES=${SOURCES:-/sources}
ZBUILD=${ZBUILD:-/zbuild}

zmsg() { printf "*** %s\n" "${@}"; }
zdie() { zmsg "${@}"; exit 1; }

get() { wget -c -nc -P "${SOURCES}" "${@}"; }
check() {
    local url="${1}"
    local md5="${2}"
    local archive=$(basename ${url})
    if [[ ! -f "${SOURCES}/${archive}" ]]; then
        get "${url}"
    fi
    echo "${md5}  ${SOURCES}/${archive}" | md5sum -c - || return 1
}

LLVM_SRC_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.1/llvm-20.1.1.src.tar.xz"
LLVM_SRC=$(basename ${LLVM_SRC_URL})
LLVM_SRC_MD5="4dded37d4e2a030793de925ed6894eb6"

LLVM_CMAKE_SRC="https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-cmake-20.1.1.src.tar.xz"
LLVM_CMAKE_MD5="10dd36ab16d9e022fc8fd0e0a61f0dbc"
LLVM_CMAKE=$(basename ${LLVM_CMAKE_SRC})

LLVM_THIRDPARTY_URL="https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-third-party-20.1.1.src.tar.xz"
LLVM_THIRDPARTY_SRC=$(basename ${LLVM_THIRDPARTY_URL})
LLVM_THIRDPARTY_MD5="a3ba9494f84ac5e2bebd02a3cea31b6d"

CLANG_SRC_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.1/clang-20.1.1.src.tar.xz"
CLANG_SRC=$(basename ${CLANG_SRC_URL})
CLANG_SRC_MD5="739e2a7a7fc7cca0767340be32f07754"

COMPILER_RT_URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.1/compiler-rt-20.1.1.src.tar.xz"
COMPILER_RT_SRC=$(basename ${COMPILER_RT_URL})
COMPILER_RT_MD5="6e04c453ff3df173112e290e53580c2b"

zmsg "Downloading Sources"
check "${LLVM_SRC_URL}" "${LLVM_SRC_MD5}" || zdie "Failure in ${LLVM_SRC}"
check "${LLVM_CMAKE_SRC}" "${LLVM_CMAKE_MD5}" || zdie "Failure in ${LLVM_CMAKE}"
check "${LLVM_THIRDPARTY_URL}" "${LLVM_THIRDPARTY_MD5}" || zdie "Failure in ${LLVM_THIRDPARTY_SRC}"
check "${CLANG_SRC_URL}" "${CLANG_SRC_MD5}" || zdie "Failure in ${CLANG_SRC}"
check "${COMPILER_RT_URL}" "${COMPILER_RT_MD5}" || zdie "Failure in ${COMPILER_RT_SRC}"

zmsg "Extracting Sources"
packagedir=${LLVM_SRC%%.src.tar.*}
mkdir -v $ZBUILD/tmp/$packagedir

tar -xf "$SOURCES/$LLVM_SRC" -C "$ZBUILD/tmp/$packagedir" --strip-components=1 || zdie "Failure in Extracting: $LLVM_SRC"

pushd $ZBUILD/tmp/$packagedir
    tar -xf "$SOURCES/$LLVM_CMAKE"
    tar -xf $SOURCES/$LLVM_THIRDPARTY_SRC

    sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@cmake-20.1.1.src@' -i CMakeLists.txt
    sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@third-party-20.1.1.src@' -i cmake/modules/HandleLLVMOptions.cmake

    tar -xf $SOURCES/$CLANG_SRC -C tools
    mv -v tools/clang-20.1.1.src tools/clang

    tar -xf $SOURCES/$COMPILER_RT_SRC -C projects
    mv -v projects/compiler-rt-20.1.1.src projects/compiler-rt

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

    systemd-run --user --pty -d -G -p LimitCORE=0 ninja check-all

    zmsg "Installing $LLVM_SRC"
    ninja install
popd

zmsg "Finalizing $LLVM_SRC"
mkdir -pv /etc/clang
for i in clang clang++; do
    echo -fstack-protector-strong > /etc/clang/$i.cfg
done

