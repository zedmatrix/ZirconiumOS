#!/bin/bash
lfs=/mnt/lfs
yinstall="${lfs}/ybuild/yaml-install.sh"

package_list=(binutils-temp1 gcc-temp1 linux-headers glibc-temp1 libstdc++)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
done

# This Should Not Be Necessary
# echo "Cleaning Up ybuild/tmp/"
# if [[ -d "$LFS/ybuild/tmp" ]]; then
#     rm -rf ${LFS}/ybuild/tmp/* && echo "...Cleaned"
# fi
