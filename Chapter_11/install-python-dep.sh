#!/bin/bash

YBLD=${YBLD:-/ybuild}
ybuild=${YBLD}/Ybuild

source "${YBLD}/prepare/ybase_header.sh" || { echo "Can Not Source Base Header"; exit 127; }
zstars

repos="${YBLD}/repos/python"

package_list=(trove-classifiers-2026.6.1.19.yaml  editables-0.6.yaml  vcs-versioning-1.1.1.yaml  setuptools_scm-10.0.5.yaml
  pathspec-1.1.1.yaml  pluggy-1.6.0.yaml  hatchling-1.30.1.yaml  pygments-2.20.0.yaml certifi-2026.6.17.yaml
  psutil-7.2.2.yaml pygdbmi-0.11.0.0.yaml six-1.17.0.yaml hatch_vcs-0.5.0.yaml urllib3-2.7.0.yaml
  sentry_sdk-2.63.0.yaml)

for pkg in ${package_list[@]}; do
    ${ybuild} "${repos}/${pkg}" || { zerror " Error ${pkg} "; exit ${?}; }
done
