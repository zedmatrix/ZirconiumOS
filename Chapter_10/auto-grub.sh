#!/bin/bash

YBLD=${YBLD:-/ybuild}
source "${YBLD}/prepare/ybase_header.sh" || { echo "Can Not Base Header"; exit 127; }

codename="Zirconium"
kernelversion="6.6.142"

DRIVE="/dev/sda"
PTTYPE="gpt"

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
zprint "Auto GRUB Create Config"

mkdir -p /etc/default
cat > /etc/default/grub <<CONFEOF
GRUB_DEFAULT=0
GRUB_TIMEOUT=30
GRUB_DISTRIBUTOR="${codename}"

GRUB_DEVICE_PARTUUID=${ROOTPART}
GRUB_DISABLE_LINUX_PARTUUID=false

GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX=""
GRUB_THEME="/boot/grub/themes/starfield/theme.txt"
CONFEOF
[ -f /etc/default/grub ] && zzok " Created: /etc/default/grub "

grub-mkconfig -o /boot/grub/grub.cfg
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
