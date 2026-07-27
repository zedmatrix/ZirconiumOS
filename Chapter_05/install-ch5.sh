#!/bin/bash
set -e

YLFS=${YLFS:-"/mnt/ylfs"}
YBLD=${YBLD:-"${YLFS}/ybuild"}
yinstall="${YBLD}/pkg-install.sh"

package_list=(binutils-2.46.0-p1 gcc-16.1.0-p1 linux-6.6.142-headers glibc-2.43-tmp libstdcpp-16.1.0)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
done
