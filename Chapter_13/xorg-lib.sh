#!/bin/bash
zzwhite="\033[1;37m"
zzreset="\033[0m"
zprint() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }

packagelist=(xtrans libX11 libXext libFS libICE libSM libXScrnSaver libXt libXmu libXpm libXaw
 libXfixes libXcomposite libXrender libXcursor libXdamage libfontenc libXfont2 libXft libXi
 libXinerama libXrandr libXres libXtst libXv libXvMC libXxf86dga libXxf86vm libpciaccess
 libxkbfile libxshmfence libXpresent)

for pkg in ${packagelist[@]}; do
    zprint "Sending ${pkg} to pkg-install"
    ./pkg-install ${pkg} || break
done
