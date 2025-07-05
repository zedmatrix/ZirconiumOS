#!/bin/bash
stage2=(050-flit_core-3.12.0.zbc 051-packaging-25.0.zbc 052-wheel-0.46.1.zbc 053-setuptools-80.9.0.zbc
 054-ninja-1.12.1.zbc 055-meson-1.8.2.zbc 056-kmod-34.2.zbc 057-coreutils-9.7.zbc 058-diffutils-3.12.zbc
 059-gawk-5.3.2.zbc 060-findutils-4.10.0.zbc 061-groff-1.23.0.zbc 062-grub-2.12.zbc 063-gzip-1.14.zbc
 064-iproute2-6.15.0.zbc 065-kbd-2.8.0.zbc 066-libpipeline-1.5.8.zbc 067-make-4.4.1.zbc 068-patch-2.8.zbc
 069-tar-1.35.zbc 070-texinfo-7.2.zbc 071-nano-8.5.zbc 072-markupsafe-3.0.2.zbc 073-jinja2-3.1.6.zbc
 074-systemd-257.6.zbc 075-dbus-1.16.2.zbc 076-man-db-2.13.1.zbc 077-procps-ng-4.0.5.zbc
 078-utili-linux-2.41.zbc 079-e2fsprogs-1.47.2.zbc)

for file in ${stage2[@]}; do
    echo "Executing: ./zbuild stage2/$file"
    echo "Press [SPACE] to skip 5s wait, or wait to continue..."

    read -t 5 -n 1 key
    if [[ $key == " " ]]; then
        echo "Skipped wait."
    else
        echo "Continuing..."
    fi

    ./zbuild "stage2/$file" || {
        echo "Error in $file - exit code $?"
        exit 1
    }
    /sbin/ldconfig
done
