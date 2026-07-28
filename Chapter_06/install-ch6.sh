#!/bin/bash
set -e

YLFS=${YLFS:-"/mnt/ylfs"}
YBLD=${YBLD:-"${YLFS}/ybuild"}
yinstall="${YBLD}/pkg-install.sh"

package_list=(m4-1.4.21-tmp ncurses-6.6-tmp bash-5.3.15-tmp coreutils-9.11-tmp diffutils-3.12-tmp file-5.48-tmp
  findutils-4.10.0-tmp gawk-5.4.1-tmp grep-3.12-tmp gzip-1.14-tmp make-4.4.1-tmp patch-2.8-tmp sed-4.10-tmp
  tar-1.35-tmp xz-5.8.3-tmp binutils-2.46.0-p2 gcc-16.1.0-p2)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; exit 1; }
done
