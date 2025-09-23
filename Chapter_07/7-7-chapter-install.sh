#!/bin/bash
yinstall="/ybuild/yaml-install.sh"
package_list=(gettext-temp bison-temp perl-temp python-temp texinfo-temp util-linux-temp)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
done

# This Should Not Be Necessary
# if [[ -d "/ybuild/tmp" ]]; then
#     echo "Cleaning Up /ybuild/tmp/"
#     rm -rf /ybuild/tmp/*
# fi
