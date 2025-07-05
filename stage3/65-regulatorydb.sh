#!/bin/bash
zdie() { "Error: ${@}. Exiting."; exit 1; }

SOURCES=${SOURCES:-/sources}

zprint "Firmware for Regulatory Database of Wireless Devices"

pkgurl="https://mirrors.edge.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2025.02.20.tar.xz"
package=$(basename $pkgurl)
packagedir=${package%*.tar*}

zprint "Working Archive: $package - To: $packagedir"

if [[ ! -f "${SOURCES}/${package}" ]]; then
    [ ! -x "/usr/bin/wget" ] && zdie "wget Needed"
    wget -P ${SOURCES} ${pkgurl} || zdie "wget: ${?}"
fi

mkdir -pv /tmp/${packagedir} || zdie "Creating Temporary Directory"

tar xf "${SOURCES}/${package}" -C /tmp/${packagedir} --strip-components=1 || zdie "Extraction: ${?}"

pushd /tmp/${packagedir}
    mkdir -p /usr/lib/firmware
    cp -v regulatory.db regulatory.db.p7s /usr/lib/firmware
popd

rm -rf /tmp/${packagedir} && zprint " Temporary Directory Cleaned "
