#!/bin/bash
## Used during the cross compilation chatpers 5 and 6
YLFS=${YLFS:-"/mnt/ylfs"}
YBLD=${YBLD:-"${YLFS}/ybuild"}

## Used during chroot and reboot root
YBLD=${YBLD:-"/ybuild"}

## Defaults for all auto packing building
YSRC=${YSRC:-"${YBLD}/sources"}
YHEAD=${YHEAD:-"${YBLD}/prepare/ybase_header.sh"}
YREPOS=${YREPOS:-"${YBLD}/repos"}
YBUILD=${YBUILD:-"${YBLD}/Ybuild"}

if [[ -z $YBASE_HEADER ]]; then
    if [[ -f ${YHEAD} ]]; then
        source "${YHEAD}"
    else
        echo "Can Not Source ${YHEAD}"
        exit 127
    fi
fi

package=${1}
if [[ -z $package ]]; then
    zerror "Missing Package Argument. Exiting."
    zprint "Usage: ./${0} [package name]"
    exit 2
fi
zstars

# Start of Script
YBefore=`date +%s`
package_dir=$(find ${YREPOS} -type f -name "${package}.yaml")

if [[ -n $package_dir ]]; then
    zzok "Installing: ${package_dir}"
    zbuild_wait 5

    ${YBUILD} ${package_dir}
    exit_code=${?}
    if [[ $exit_code -eq 0 ]]; then
        if [[ $YARCH == "glibc" && -z ${YLFS} ]]; then
            zzok "Updating ld config"
            /sbin/ldconfig
        fi
        zzok "Build Successful"
    fi
else
    zerror "Package: ${package_dir} Not Found"
    exit 127
fi

YAfter=`date +%s`
let duration=YAfter-YBefore

if [[ ${exit_code} -ne 0 ]]; then
    zerror "Error Code: ${exit_code}"
    print_formatted_duration ${duration} "NOTOK"
else
    print_formatted_duration ${duration}
fi
zstars
exit $exit_code
