#!/bin/bash
YBLD=${YBLD:-"/ybuild"}
YREPOS="${YBLD}/repos/python"
YHEAD=${YHEAD:-"${YBLD}/prepare/ybase_header.sh"}
[ -f ${YHEAD} ] && source ${YHEAD} || { echo "Can Not Base Header"; exit 127; }

ybuild=${YBLD}/Ybuild
package=(trove-classifiers-2026.6.1.19 editables-0.6 vcs-versioning-2.2.2 setuptools_scm-10.2.1
  pathspec-1.1.1 pluggy-1.6.0 hatchling-1.31.0 pygments-2.20.0 hatch_vcs-0.5.0 urllib3-2.7.0
  six-1.17.0 pygdbmi-0.11.0.0 psutil-7.2.2 ply-3.11 asciidoc-10.2.1 certifi-2026.7.22 sentry_sdk-2.66.1
  lxml-6.1.1 cython-3.2.9)

for pkg in ${package[@]}; do
    zmsg "Next Package: ${pkg}"
    zbuild_wait 5

    ${ybuild} "${YREPOS}/${pkg}.yaml" || { zerror " Error ${pkg} "; exit 1; }
done
