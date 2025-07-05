#!/bin/bash
zmsg() { printf "*** %s\n" "$@"; }

ZBUILD=${ZBUILD:-/zbuild}

stage3=(09-which-2.23.zbc 10-libarchive-3.8.1.zbc 11-libunistring-1.3.zbc 12-libidn2-2.3.8.zbc
 13-libtasn1-4.20.0.zbc 14-libusb-1.0.29.zbc 15-libpsl-0.21.5.zbc 16-libpng-1.6.49.zbc 17-curl-8.14.1.zbc
 18-wget-1.25.0.zbc 19-popt-1.19.zbc 20-rsync-3.4.1.zbc 21-p11-kit-0.25.5.zbc 22-make-ca-1.16.1.zbc
 23-pciutils-3.14.0.zbc 24-usbutils-018.zbc 25-hwdata-0.396.zbc 26-gpm-1.20.7.zbc 27-freetype-2.13.3.zbc
 28-efivar-39.zbc 29-efibootmgr-18.zbc 30-openssh-10.0p1.zbc 31-dosfstools-4.2.zbc 32-fuse-3.17.2.zbc
 33-libaio-0.3.113.zbc 34-LVM2.2.03.32.zbc 35-grub-2.12.zbc 36-git-2.50.0.zbc)

for file in ${stage3[@]}; do
    zmsg "Executing: ${ZBUILD}/stage3/$file"
    zmsg "Press [SPACE] to skip 5s wait, or wait to continue..."

    read -t 5 -n 1 key
    if [[ $key == " " ]]; then
        echo "Skipped wait."
    else
        echo "Continuing..."
    fi

    ./zbuild "${ZBUILD}/stage3/$file" || {
        echo "Error in $file - exit code $?"
        exit 1
    }
done

zmsg " Installing: Final Configuration Scripts"
. stage3/40-final-configuration.sh

zmsg " Optional git manual and documentation install: 36.1-optional-doc-install.sh"

zmsg " Finished *** "
