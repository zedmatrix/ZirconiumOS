#!/bin/bash

[ ! -z $YHEAD ] && source $YHEAD || { echo "Can Not Base Header"; exit 1; }
source "${YBLD}/prepare/ylfs-environment.sh" || { echo "Can Not Source Environment"; exit 1; }

zprint "Getting Zirconium SystemD Packages"

download() {
    local url=$2
    local file=$1
    wget -nc -P ${YSRC} "${url}"
    local sha256=$(sha256sum "${YSRC}/${file}" | awk '{print $1}')
    if [[ ! -z ${sha256} ]]; then
        echo "${sha256}  ${file}" >> ybuild-sha256sums
    else
        zerror "Error in SHA256Sum"
    fi
}

while IFS=' ' read -r url; do
    # Skip blank lines or comments
    [[ -z "${url}" || "${url}" == \#* ]] && continue
    archive=$(basename "${url}")

    if [[ ! -f "${YSRC}/${archive}" ]]; then
        zprint " Downloading: ${archive} URL: ${url} "
        download "${archive}" "${url}"
    else
        zprint " Verifying: ${archive} "
        sha256=$(sha256sum "${YSRC}/${archive}" | awk '{print $1}')
        if [[ ! -z ${sha256} ]]; then
            echo "${sha256}  ${archive}" >> ybuild-sha256sums
        else
            zerror "Error in SHA256Sum"
        fi
    fi
done < "${YBLD}/prepare/zirconium_packages.wget"
