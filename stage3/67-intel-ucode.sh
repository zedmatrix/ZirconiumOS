#!/bin/bash
zdie() { "Error: ${@}. Exiting."; exit 1; }

ZBUILD=${ZBUILD:-/zbuild}
SOURCES=${SOURCES:-/sources}

ztemp="${ZBUILD}/tmp/microcode-20250512"

zprint "Intel ucode - Cloning into ${ztemp}"
#printf "%02x-%02x-%02x\n" `lscpu | grep -e "CPU family:" -e "Model:" -e "Stepping:" | cut -d: -f2`

pkgurl="https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/archive/refs/tags/microcode-20250512.tar.gz"
archive=$(basename $pkgurl)

mkdir -pv ${ztemp} || zdie "Creating ${ztemp}"
if [[ ! -f "${SOURCES}/${archive}" ]]; then
    [ ! -x "/usr/bin/wget" ] && zdie "wget needed"
    wget -P ${SOURCES} ${pkgurl} || zdie "wget ${?}"
fi

tar -xf "${SOURCES}/${archive}" -C ${ztemp} --strip-components=1

pushd "${ztemp}" || zdie "Entering ${ztemp}"
    cpu_id=$(printf "%02x-%02x-%02x\n" \
    $(lscpu | grep -E "CPU family:|Model:|Stepping:" | awk -F: '{gsub(/ /,"",$2); print $2}')) &&

    echo $cpu_id

popd
