#!/bin/bash

YBLD=${YBLD:-/ybuild}
if [[ -z $YBASE_HEADER ]]; then
  if [[ -f $YHEAD ]]; then
     source "${YHEAD}"
  else
     echo "Can Not Base Header"
     exit 127
  fi
fi

codename=${codename:-"Zirconium"}
kernelversion=${kernelversion:-"7.1.4"}
DRIVE=${DRIVE:-"/dev/sda"}
PTTYPE=$(lsblk -dn -o PTTYPE "$DRIVE" | head -1)

[[ $DRIVE =~ 'nvme' ]] && P=p || P=

if [[ $PTTYPE == "gpt" ]]; then
    UEFI=$(blkid -o value -s UUID ${DRIVE}${P}1)
    SWAP=$(blkid -o value -s UUID ${DRIVE}${P}2)
    ROOT=$(blkid -o value -s UUID ${DRIVE}${P}3)
    ROOTPART=$(blkid -o value -s PARTUUID ${DRIVE}${P}3)
else
    ROOT=$(blkid -o value -s UUID ${DRIVE}2)
    ROOTPART=$(blkid -o value -s PARTUUID ${DRIVE}2)
fi

mkdir -pv /boot/grub
cat > /boot/grub/grub.cfg <<MANEOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=30

insmod part_gpt
insmod ext2
insmod gfxterm
insmod gfxmenu

set menu_color_normal=cyan/black
set menu_color_highlight=white/blue

search --no-floppy --fs-uuid --set=root $ROOT
set gfxpayload=1280x1024x32
# set gfxpayload=1024x768x32

menuentry "${codename}, GNU/Linux-${kernelversion}" {
    linux   /boot/vmlinuz-${kernelversion}-zlfs root=PARTUUID=$ROOTPART ro

}
MANEOF

if [[ ! -z $UEFI ]]; then
    cat >> /boot/grub/grub.cfg <<EFIEOF

menuentry "UEFI Firmware Setup" {
    fwsetup
}
EFIEOF
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
