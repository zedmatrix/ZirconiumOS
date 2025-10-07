#!/bin/bash
set -e
pushd /ybuild

./7-5-creating-dirs.sh
./7-6-create-files_systemd.sh

yinstall="/ybuild/yaml-install.sh"
package_list=(gettext-temp bison-temp perl-temp python-temp texinfo-temp util-linux-temp)

for pkg in ${package_list[@]}; do
    if ! "${yinstall}" "$pkg"; then
        echo "Error in ${pkg}. Exiting."
        exit 1
    fi
done

./7-z-cleanup.sh

popd
