#!/bin/bash
zdie() { "Error: ${@}. Exiting."; exit 1; }

ZBUILD=${ZBUILD:-/zbuild}

firmware="linux-firmware-20250627"
ztemp=${ZBUILD}/tmp/${firmware}

zprint "Linux Firmware - Cloning into ${ztemp}"

pkgurl="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git"

mkdir -pv ${ztemp} || zdie "Creating ${ztemp}"
mkdir -pv /usr/lib/firmware || zdie "Creating /usr/lib/firmware"

pushd "${ztemp}" || zdie "Entering ${ztemp}"

    git clone --depth=1 "$pkgurl" ${ztemp} || zdie "Git clone failed"

    if [[ -x ${ztemp}/copy-firmware.sh ]]; then
        zprint "Found copy-firmware.sh, Copying Firmware"
        ./copy-firmware.sh /usr/lib/firmware
    else
        zprint "copy-firmware.sh not found or not executable."
    fi

popd
