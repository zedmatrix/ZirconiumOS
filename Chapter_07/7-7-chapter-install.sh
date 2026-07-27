#!/bin/bash
set -e
YBLD=${YBLD:-"/ybuild"}
yinstall="${YBLD}/pkg-install.sh"

${YBLD}/7-5-creating-dirs.sh
${YBLD}/7-6-create-files_sysv-and-systemd.sh

pushd ${YBLD}

package_list=(gettext-1.0-tmp bison-3.8.2-tmp perl-5.42.2-tmp python-3.14.6-tmp texinfo-7.3-tmp util-linux-2.42.2-tmp)

for pkg in ${package_list[@]}; do
    if ! "${yinstall}" "$pkg"; then
        echo "Error in ${pkg}. Exiting."
        exit 1
    fi
done

${YBLD}/7-z-cleanup.sh

popd
