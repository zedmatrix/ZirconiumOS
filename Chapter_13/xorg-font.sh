#!/bin/bash
zzwhite="\033[1;37m"
zzreset="\033[0m"
zprint() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }

# Xorg Fonts

# packagelist=(font-util encodings font-alias font-adobe-utopia-type1 font-bh-ttf font-bh-type1 \
#  font-ibm-type1 font-misc-ethiopic font-xfree86-type1)

packagelist=(bdftopcf font-adobe-100dpi font-adobe-75dpi font-jis-misc font-daewoo-misc font-isas-misc font-misc-misc)

for pkg in ${packagelist[@]}; do
    zprint "Sending ${pkg} to pkg-install"
    ./pkg-install.sh ${pkg} || break
done
