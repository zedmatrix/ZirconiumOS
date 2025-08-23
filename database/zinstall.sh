#!/bin/bash
set +h
umask 022

zzreset="\033[0m"
zzwhite="\033[1;37m"

zzred="\033[1;31m"
zzgreen="\033[1;32m"
zzyellow="\033[1;33m"
zzblue="\033[1;34m"
zzpurple="\033[1;35m"
zzcyan="\033[1;36m"

zprint() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }
zzok() { echo -e "${zzgreen} *** $* *** ${zzreset}"; }
zmsg() { echo -e "${zzred} *** $* *** ${zzreset}"; }
zstars() { echo -e "${zzpurple} $(printf '%.0s*' {1..100}) ${zzreset}"; }

# Verify if package was installed and is the same version
zcheck_func() {
    local pkg="${1}"
    local pn=${pkg%-*}
    local pv=${pkg##*-}
    local found=$(grep "^${pn}" "${ZBUILD}/zpackage.db")

    if [[ -n ${found} ]]; then
        zprint "Found ${pkg} in ${ZBUILD}/zpackage.db"
        local found_ver=$(echo "$found" | awk -F' - ' '{gsub(/^ +| +$/, "", $2); print $2}')

        if [[ ${found_ver} == ${pv} ]]; then
            zprint "Package: ${pn} Version: ${found_ver} Found. Not Installing"
            return 1
        fi
    else
        zprint "Not Found in ${ZBUILD}/zpackage.db";
    fi
    return 0
}
# Simple Wait Before Executing Function of 5 seconds or whatever is passed
zbuild_wait() {
    local wait=${1:-5}
    zmsg "Waiting $wait seconds or Press [SPACE] to continue..."
    read -t $wait -n 1 key
    if [[ $key == " " ]]; then
        zmsg "Skipped wait."
    else
        zzok "Continuing..."
    fi
}
# Start of Script
ZREPOSITORY=${ZREPOSITORY:-"/var/db/repos"}
ZSRC=${ZSRC:-"/sources"}
ZBUILD=${ZBUILD:-"/zbuild"}
ZBUILD_CONFIG=${ZBUILD_CONFIG:-"/etc/zbuild.conf"}

zstars
# Test if the zbuild program is rebuilt and installed in PATH
[ -x $(which zbuild) ] && echo "Installed" || { echo "zbuild Not Found in Path. Exiting."; exit 1; }

zpkg=${1}
# Find package directory
[ -z $zpkg ] && { zmsg "Missing Search Argument"; exit 99; }
zpkg_dir=$(find ${ZREPOSITORY} -type d -name "${zpkg}-[0-9]*")

if [[ -n $zpkg_dir ]]; then
    zzok ${zpkg_dir}
    zcategory=$(basename $(dirname ${zpkg_dir}))     # which BLFS category
    zprint "Package Category: ${zcategory}"

    zpackage=$(basename ${zpkg_dir})
    zzok ${zpackage}
    if ! zcheck_func ${zpackage}; then      #check if installed/upgrading
        exit 1
    fi

    zpkg_def=$(find ${zpkg_dir} -type f -name "${zpackage}.zbc")      # Passed to zbuild
    zprint "Package: ${zpkg_def}"

    # Copy any sources from repos to working source tree only if non-existence
    if [[ -d "${zpkg_dir}/sources" ]]; then
        zprint "Found: ${zpkg_dir}/sources"
        cp -nv "${zpkg_dir}/sources/"* ${ZSRC} || { echo "Failed to Copy Sources. Exiting."; exit 1; }
    else
        zmsg "Failed to Find Sources. Exiting."
        exit 1
    fi

    # Verify that any depends are met from reading the simple zpackage.db
    if [[ -f "${zpkg_dir}/depends.sh" ]]; then
        zprint "Found: ${zpkg_dir}/depends.sh"
        source "${zpkg_dir}/depends.sh"
        echo "return: ${zcheck}"
        if [[ ${zcheck} -eq 0 ]]; then
            zbuild_wait
            zzok "Executing: ${zpkg_def}"
            zbuild ${zpkg_def} || { zmsg "Error Building: ${?} .Exiting."; exit 1; }
            /sbin/ldconfig
        else
            zmsg "Missing Depends. Exiting."
        fi
    else
        zmsg "Missing DEPENDS File"
    fi
else
    zmsg "Package: ${zpkg} Not Found"
    exit 99
fi
zstars
