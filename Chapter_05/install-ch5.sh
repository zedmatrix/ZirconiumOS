#!/bin/bash
set -e

export LFS=${LFS:=/mnt/lfs}
yinstall="${LFS}/ybuild/yaml-install.sh"

package_list=(binutils-temp1 gcc-temp1 linux-headers glibc-temp1 libstdc++)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
done
