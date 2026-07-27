#!/bin/bash

source "0-setup/ybase_header.sh" || { echo "Can Not Base Header"; exit 127; }
# codename="Zirconium"
# kernelversion="6.6.120"

codename="Pegasus"
kernelversion="6.18.8"

DRIVE="/dev/vda"
PTTYPE="gpt"

[[ $DRIVE =~ 'nvme' ]] && P=p || P=

if [[ $PTTYPE == "gpt" ]]; then
    UEFI=$(blkid ${DRIVE}${P}1 | awk '{print $2}' | sed 's/"//g')
    #SWAP=$(blkid ${DRIVE}${P}2 | awk '{print $2}' | sed 's/"//g')
    ROOT=$(blkid ${DRIVE}${P}3 | awk '{print $2}' | sed 's/"//g')
    ROOTPART=$(blkid ${DRIVE}${P}3 | awk '{print $5}' | sed 's/"//g')
else
    ROOT=$(blkid ${DRIVE}2 | awk '{print $2}' | sed 's/"//g')
    ROOTPART=$(blkid ${DRIVE}2 | awk '{print $5}' | sed 's/"//g')
fi

mkdir -pv /boot/grub

cat > /boot/grub/grub.cfg <<EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=30

insmod part_gpt
insmod ext2
insmod gfxterm
insmod gfxmenu

set menu_color_normal=cyan/black
set menu_color_highlight=white/blue

search --no-floppy --fs-uuid --set=root UUID=$ROOT
#set gfxpayload=1280x1024x32
set gfxpayload=1024x768x32

menuentry "${codename}, GNU/Linux-${kernelversion}" {
    linux   /boot/vmlinuz-${kernelversion} root=PARTUUID=$ROOTPART ro

}
EOF

if [[ ! -z $UEFI ]]; then
    cat >> /boot/grub/grub.cfg <<EOF

menuentry "UEFI Firmware Setup" {
    fwsetup
}
EOF
fi

[ -f /boot/grub/grub.cfg ] && zzok " Created: /boot/grub/grub.cfg "

if [[ $PTTYPE == "dos" ]]; then
    grub-install --target=i386-pc $DRIVE
elif [[ $PTTYPE == "gpt" ]]; then
    zprint "Mounting EFI Partition ${DRIVE}${P}1 "
    mount --mkdir -v -t vfat ${DRIVE}${P}1 -o codepage=437,iocharset=iso8859-1 /boot/efi
    zprint "Updating UEFI Boot"
    grub-install --target=x86_64-efi --removable
    mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars
    grub-install --target=x86_64-efi --bootloader-id=ZLFS --recheck
    efibootmgr | cut -f 1
else
    zerror "Error Installing to Unknown Partition: ${PTTYPE}"
    exit 1
fi
