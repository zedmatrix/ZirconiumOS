#!/bin/bash
yinstall="/ybuild/yaml-install.sh"
[ $1 == "uefi" ] && let UEFI=1

ybuild_scripts=(ybuild-environment.sh ynetwork-files.sh yclock-locale.sh ysystem-config.sh
ybash-startup.sh yskel-files.sh)

for script in ${ybuild_scripts[@]}; do
    ./${script} || { echo "Error in ${script}. Exiting."; break; }
done


package_list=(which libarchive libtasn1 p11-kit make-ca libunistring libidn2 libpsl wget curl openssh
 hwdata pciutils libusb usbutils)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
done


if [[ $UEFI -eq 1 ]]; then
    echo "Installing Grub-UEFI Packages"

    package_list=(popt libpng libaio dosfstools lvm2 fuse freetype2-pass1 efivar efibootmgr grub-uefi)

    for pkg in ${package_list[@]}; do
        ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
    done
fi

# This Should Not Be Necessary
# if [[ -d "/ybuild/tmp" && $keep -eq 0 ]]; then
#     echo "Cleaning Up /ybuild/tmp/"
#     rm -rf /ybuild/tmp/*
# fi
