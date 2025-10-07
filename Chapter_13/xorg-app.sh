#!/bin/bash
zzwhite="\033[1;37m"
zzreset="\033[0m"
zprint() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }

# Xorg Applications

# 01-iceauth-1.0.10 02-mkfontscale-1.2.3 03-sessreg-1.1.4 04-setxkbmap-1.3.4 05-smproxy-1.0.8 06-xauth-1.1.4
# 07-xcmsdb-1.0.7 08-xcursorgen-1.0.9 09-xdpyinfo-1.3.4 10-xdriinfo-1.0.7 11-xev-1.2.6 12-xgamma-1.0.7
# 13-xhost-1.0.10 14-xinput-1.6.4 15-xkbcomp-1.4.7 16-xkbevd-1.1.6 17-xkbutils-1.0.6 18-xkill-1.0.6
# 19-xlsatoms-1.1.4 20-xlsclients-1.1.5 21-xmessage-1.0.7 22-xmodmap-1.0.11 23-xpr-1.2.0 24-xprop-1.2.8
# 25-xrandr-1.5.3 26-xrdb-1.2.2 27-xrefresh-1.1.0 28-xset-1.2.5 29-xsetroot-1.1.3 30-xvinfo-1.1.5
# 31-xwd-1.0.9 32-xwininfo-1.1.6 33-xwud-1.0.7

packagelist=(iceauth mkfontscale sessreg setxkbmap smproxy xauth xcmsdb xcursorgen xdpyinfo xdriinfo xev
xgamma xhost xinput xkbcomp xkbevd xkbutils xkill xlsatoms xlsclients xmessage xmodmap xpr xprop xrandr
xrdb xrefresh xset xsetroot xvinfo xwd xwininfo xwud)

for pkg in ${packagelist[@]}; do
    zprint "Sending ${pkg} to pkg-install"
    ./pkg-install ${pkg} || break
done
