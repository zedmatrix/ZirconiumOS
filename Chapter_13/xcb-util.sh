#!/bin/bash
zzwhite="\033[1;37m"
zzreset="\033[0m"
zprint() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }

packagelist=(libxcvt xcb-util xcb-util-image xcb-util-keysyms xcb-util-renderutil
xcb-util-wm xcb-util-cursor libdrm)

for pkg in ${packagelist[@]}; do
    zprint "Sending ${pkg} to pkg-install"
    ./pkg-install.sh ${pkg} || break
done
