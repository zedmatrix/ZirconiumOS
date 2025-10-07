#!/bin/bash
zzwhite="\033[1;37m"
zzreset="\033[0m"
zprint() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }

# Xorg Fonts

packagelist=(mtdev libevdev libinput xf86-input-evdev xf86-input-libinput xf86-input-synaptics xf86-input-wacom)

for pkg in ${packagelist[@]}; do
    zprint "Sending ${pkg} to pkg-install"
    ./pkg-install.sh ${pkg} || break
done
