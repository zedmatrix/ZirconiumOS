#!/bin/bash
#
#   Create array list: printf ' %s ' *.xml;echo
#
zzreset="\033[0m"
zzwhite="\033[1;37m"
zzgreen="\033[1;32m"
zzred="\033[1;31m"
zzpurple="\033[1;35m"

zbuild_print() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }
zbuild_error() { echo -e "${zzred} Error: $* ${zzreset}"; }
zbuild_ok() { echo -e "${zzgreen} *** $* *** ${zzreset}"; }
stars() { echo -e "${zzpurple} $(printf '%.0s*' {1..100}) ${zzreset}"; }

XML=${1}
XSL="lfs-yaml-template.xsl"
[ ! -f ${XSL} ] && { zbuild_error "Failure finding ${XSL} File. Exiting."; exit 1; }

YAML=yaml-files
[ ! -d ${YAML} ] && mkdir -v $YAML || zbuild_ok "yaml Build Directory Found."

if [[ -f $XML ]]; then
    # Single XML file
    XMLFILES=("$XML")
elif [[ -d $XML ]]; then
    # All XML files in directory
    XMLFILES=("$XML"/*.xml)
    # Optionally handle case of no .xml files
    [[ ${#XMLFILES[@]} -eq 0 ]] && { zbuild_error "No XML files found in $XML"; exit 1; }
else
    zbuild_error "Missing $XML file or directory. Exiting."
    exit 1
fi

if [[ ${#XMLFILES[@]} -gt 0 ]]; then

    for x in ${XMLFILES[@]}; do
        if [[ -f ${x} ]]; then
            out=$(basename $x)
            zbuild_ok "Creating: ${out} "
            xsltproc -o ${YAML}/${out}.yaml --stringparam revision systemd ${XSL} ${x}
        else
            zbuild_error "XML Not Found: ${x}"
        fi

    done
else
    zbuild_error "No XML Files Found. Done."
fi
