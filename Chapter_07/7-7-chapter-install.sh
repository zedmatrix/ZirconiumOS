#!/bin/bash
set -e
YBLD=${YBLD:-"/ybuild"}
yinstall="${YBLD}/pkg-install.sh"

${YBLD}/prepare/7-5-creating-dirs.sh || exit 1
${YBLD}/prepare/7-6-create-files_sysv-and-systemd.sh  || exit 1

pushd ${YBLD}

package_list=(gettext-1.0-tmp bison-3.8.2-tmp perl-5.42.2-tmp python-3.14.6-tmp texinfo-7.3-tmp util-linux-2.42.2-tmp)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; exit 1; }
done

${YBLD}/prepare/7-z-cleanup.sh  || exit 1

popd
