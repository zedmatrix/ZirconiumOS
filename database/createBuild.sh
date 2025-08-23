#!/bin/bash
set +h
umask 022
zzreset="\033[0m"
zzwhite="\033[1;37m"
zzred="\033[1;31m"
zzgreen="\033[1;32m"
zzpurple="\033[1;35m"
ZGET="/var/db/zget"

zprint() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }
zmsg() { echo -e "${zzred} *** $* *** ${zzreset}"; }
zzok() { echo -e "${zzgreen} *** $* *** ${zzreset}"; }
stars() { echo -e "${zzpurple} $(printf '%.0s*' {1..80}) ${zzreset}"; }

package="${1}"
stars
if [[ -z "${package}" || ! -f "${package}" ]]; then
    zmsg "Error. Required ${package} Missing. Exiting."
    exit 1
else
    zprint "Creating: ${package}"
fi
# Get any depends
depend=$(grep 'DEPEND' ${package} | sed 's/.*(\(.*\)).*/\1/'); echo $dep
optional=$(grep 'optional' ${package} | sed 's/.*(\(.*\)).*/\1/')

# Create package source and dir
packagedir=${package%.zbc}
mkdir -pv $packagedir
cat > ${packagedir}/depends.sh <<EOF
#!/bin/bash
# Create: tar --owner=root --group=root -cf ${packagedir}.tar ${packagedir}/*
check_depend() {
    local DEPEND=\${@}
    for dep in \${DEPEND[@]}; do
        if ! grep -q "^\$dep" "\$ZBUILD/zpackage.db"; then
            zmsg "Missing: \${dep}"
            let zcheck+=1
        else
            zzok "Found: \${dep}"
        fi
    done
}

ZSRC=\${ZSRC:-/sources}
ZBUILD=\${ZBUILD:-/zbuild}
let zcheck=0
packagedir=$packagedir

required=(${depend})
optional=(${optional})

if [[ \${#optional[@]} -eq 0 ]]; then
    zzok "Optional Depends Not Set"
else
    check_depend \${optional[@]}
    let zcheck=0
fi

if [[ \${#required[@]} -eq 0 ]]; then
    zzok "Required Depends Not Set"
else
    check_depend \${required[@]}
fi

EOF
pushd $packagedir || { zmsg "Error Moving into $packagedir Exiting."; exit 1; }

stars
mv -v ../${package} .
$ZGET $package
stars

popd
