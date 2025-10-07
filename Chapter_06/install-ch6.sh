#!/bin/bash
set -e

export LFS=${LFS:=/mnt/lfs}
yinstall="${lfs}/ybuild/yaml-install.sh"

package_list=(m4-temp ncurses-temp bash-temp coreutils-temp diffutils-temp file-temp findutils-temp
 gawk-temp grep-temp gzip-temp make-temp patch-temp sed-temp tar-temp xz-temp binutils-temp2 gcc-temp2)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
done

# This Should Not Be Necessary
# echo "Cleaning Up ybuild/tmp/"
# if [[ -d "$LFS/ybuild/tmp" ]]; then
#     rm -rf ${LFS}/ybuild/tmp/* && echo "...Cleaned"
# fi
