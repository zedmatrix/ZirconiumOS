#!/bin/bash
zmsg() { printf "*** %s\n" "$@"; }

ZBUILD=${ZBUILD:-/zbuild}

stage4=(025-xtrans-1.6.0.zbc 026-libX11-1.8.12.zbc 027-libXext-1.3.6.zbc 028-libFS-1.0.10.zbc
 029-libICE-1.1.2.zbc 030-libSM-1.2.6.zbc 031-libXScrnSaver-1.2.4.zbc 032-libXt-1.3.1.zbc 033-libXmu-1.2.1.zbc
 034-libXpm-3.5.17.zbc 035-libXaw-1.0.16.zbc 036-libXfixes-6.0.1.zbc 037-libXcomposite-0.4.6.zbc
 038-libXrender-0.9.12.zbc 039-libXcursor-1.2.3.zbc 040-libXdamage-1.1.6.zbc 041-libfontenc-1.1.8.zbc
 042-libXfont2-2.0.7.zbc 043-libXft-2.3.9.zbc 044-libXi-1.8.2.zbc 045-libXinerama-1.1.5.zbc
 046-libXrandr-1.5.4.zbc 047-libXres-1.2.2.zbc 048-libXtst-1.2.5.zbc 049-libXv-1.0.13.zbc 050-libXvMC-1.0.14.zbc
 051-libXxf86dga-1.1.6.zbc 052-libXxf86vm-1.1.6.zbc 053-libpciaccess-0.18.1.zbc 054-libxkbfile-1.1.3.zbc
 055-libxshmfence-1.3.3.zbc 056-libXpresent-1.0.1.zbc)

for file in ${stage4[@]}; do
    zmsg "Executing: ${ZBUILD}/stage4/$file"
    zmsg "Press [SPACE] to skip 5s wait, or wait to continue..."

    read -t 5 -n 1 key
    if [[ $key == " " ]]; then
        echo "Skipped wait."
    else
        echo "Continuing..."
    fi

    ./zbuild "${ZBUILD}/stage4/$file" || {
        echo "Error in $file - exit code $?"
        exit 1
    }
    /usr/sbin/ldconfig
done
