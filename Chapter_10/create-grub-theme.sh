#!/bin/bash

source "${YHEAD}" || { echo "Can Not Base Header"; exit 127; }

DRIVE=${1:-"/dev/sda"}
codename=${2:-"Zirconium"}
kernelversion=${3:-"7.1.5"}

PTTYPE=$(lsblk -dn -o PTTYPE "$DRIVE" | head -1)
postfix="zlfs"

[[ $DRIVE =~ 'nvme' ]] && P=p || P=

# Assume GPT Drive
UEFI=$(blkid -o value -s UUID ${DRIVE}${P}1)
SWAP=$(blkid -o value -s UUID ${DRIVE}${P}2)
ROOT=$(blkid -o value -s UUID ${DRIVE}${P}3)
ROOTPART=$(blkid -o value -s PARTUUID ${DRIVE}${P}3)

mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars

# Install Directories and Theme Assets
mkdir -pv /boot/grub
mkdir -pv /boot/grub/{themes,fonts}
mkdir -pv /boot/grub/themes/zirconium/icons
cp -v /usr/share/grub/themes/starfield/*.pf2 /boot/grub/fonts
cp -v /usr/share/grub/themes/starfield/*.png /boot/grub/themes/zirconium

# Install grub.cfg theme
cp -v ${YBLD}/prepare/grub-config.cfg /boot/grub/grub.cfg || { zmsg "Failed to create grub.cfg"; exit 1; }
sed -i "s/ROOT_DRIVE/$ROOT/" /boot/grub/grub.cfg || { zmsg "Failed in insert ROOT UUID"; exit 1; }
sed -i "s/ROOTPART/$ROOTPART/" /boot/grub/grub.cfg || { zmsg "Failed in insert ROOT PART UUID"; exit 1; }
sed -i "s/VERSION/$kernelversion/g" /boot/grub/grub.cfg || { zmsg "Failed in insert VERSION"; exit 1; }
sed -i "s/CODENAME/$codename/" /boot/grub/grub.cfg || { zmsg "Failed in insert CODENAME"; exit 1; }
[ -f /boot/grub/grub.cfg ] && zzok " Created: /boot/grub/grub.cfg "

zprint "Mounting EFI Partition ${DRIVE}${P}1 "
mount --mkdir -v -t vfat ${DRIVE}${P}1 -o codepage=437,iocharset=iso8859-1 /boot/efi
grub-install --target=x86_64-efi --removable

zprint "Updating UEFI Boot"
grub-install --target=x86_64-efi --bootloader-id=ZLFS --recheck

efibootmgr | cut -f 1
