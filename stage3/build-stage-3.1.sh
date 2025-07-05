#!/bin/bash
zmsg() { printf "*** %s\n" "$@"; }

install -v -m755 -d /etc/systemd/network
install -v -m755 -d /etc/profile.d/
install -v -m755 -d /etc/skel/
install -v -m755 -d /lib/lsb/
mkdir -pv /etc/systemd/system/getty@tty1.service.d

ZBUILD=${ZBUILD:-/zbuild}

stage3=(01-network-files.sh 02-clock-locale.sh 03-system-config.sh 04-pathfunctions.sh
 05-bash-startup.sh 06-skel-files.sh 07-extra-scripts.sh 08-zbuild-environment.sh)

for file in ${stage3[@]}; do
    zmsg "Executing: ${ZBUILD}/stage3/$file"
    zmsg "Press [SPACE] to skip 5s wait, or wait to continue..."

    read -t 5 -n 1 key
    if [[ $key == " " ]]; then
        echo "Skipped wait."
    else
        echo "Continuing..."
    fi

    . "${ZBUILD}/stage3/$file" || {
        echo "Error in $file - exit code $?"
        exit 1
    }
done

dircolors -p > /etc/dircolors
zmsg " Created: /etc/dircolors"
