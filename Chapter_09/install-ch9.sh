#!/bin/bash
YBLD=${YBLD:-"/ybuild"}
yinstall="${YBLD}/pkg-install.sh"

[ $1 == "uefi" ] && let UEFI=1

package_list=(libaio-0.3.113 libunistring-1.4.2 libidn2-2.3.8 libtasn1-4.21.0 libpsl-0.21.5 libusb-1.0.30
  libpng-1.6.58 hwdata-0.408 popt-1.19 p11-kit-0.26.2 make-ca-1.16.1 pciutils-3.15.0 usbutils-019
  wget-1.25.0 curl-8.20.0 dosfstools-4.2 )

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
done

if [[ $UEFI -eq 1 ]]; then
    echo "Installing Grub-UEFI Packages"

    package_list=(efivar-39 efibootmgr-18 lvm2-2.03.41 fuse3-3.18.2 freetype2-2.14.3
     grub-2.14-efi libdisplay-info-0.3.0 lzo-2.10 btrfs-progs-7.0)

    for pkg in ${package_list[@]}; do
        ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
    done
fi

if [[ ${YBUILD_RELEASE} == systemd ]]; then
    ${yinstall} zlfs-scripts-20260710T0847Z
fi
# This Should Not Be Necessary
# if [[ -d "/ybuild/tmp" && $keep -eq 0 ]]; then
#     echo "Cleaning Up /ybuild/tmp/"
#     rm -rf /ybuild/tmp/*
# fi
