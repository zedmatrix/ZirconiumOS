#!/bin/bash
YBLD=${YBLD:-"/ybuild"}
yinstall="${YBLD}/pkg-install.sh"

UEFI=${UEFI:-1}

package_list=(libaio-0.3.113 libunistring-1.4.2 libidn2-2.3.8 libtasn1-4.21.0 libpsl-0.23.0 libusb-1.0.30
  libpng-1.6.58 hwdata-0.409 popt-1.19 p11-kit-0.26.4 make-ca-1.16.1 pciutils-3.15.0 usbutils-019
  wget-1.25.0 curl-8.21.0 dosfstools-4.2)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; exit 1; }
done

if [[ $UEFI -eq 1 ]]; then
    echo "Installing Grub-UEFI Packages"

    package_list=(efivar-39 efibootmgr-18 lvm2-2.03.41 fuse3-3.18.2 freetype2-2.14.3
     grub-2.14-efi libdisplay-info-0.3.0 lzo-2.10 btrfs-progs-7.1)

    for pkg in ${package_list[@]}; do
        ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; exit 1; }
    done
fi

if [[ ${YBUILD_RELEASE} == systemd ]]; then
    ${yinstall} zlfs-scripts-20260710T0847Z
fi

##  Image Dir Clean up
# if [[ -d "/ybuild/image" && $keep -eq 0 ]]; then
#     echo "Cleaning Up /ybuild/image/"
#     rm -r /ybuild/image/*
# fi
