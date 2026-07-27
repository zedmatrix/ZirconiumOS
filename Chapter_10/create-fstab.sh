#!/bin/bash

YBUILD_RELEASE=${YBUILD_RELEASE:-systemd}
YBLD=${YBLD:-/ybuild}
source "${YBLD}/prepare/ybase_header.sh" || { echo "Can Not Base Header"; exit 127; }

codename="Betelgeuse"
kernelversion="7.1.4"

DRIVE="/dev/sda"
PTTYPE="gpt"

[[ $DRIVE =~ 'nvme' ]] && P=p || P=

if [[ $PTTYPE == "gpt" ]]; then
    UEFI=$(blkid -o value -s UUID ${DRIVE}${P}1)
    SWAP=$(blkid -o value -s UUID ${DRIVE}${P}2)
    ROOT=$(blkid -o value -s UUID ${DRIVE}${P}3)
    ROOTPART=$(blkid -o value -s PARTUUID ${DRIVE}${P}3)
    UEFI_MNT="$UEFI /boot/efi   vfat    noauto,codepage=437,iocharset=iso8859-1  0 1"
else
    SWAP=$(blkid -o value -s UUID ${DRIVE}1)
    ROOT=$(blkid -o value -s UUID ${DRIVE}2)
    ROOTPART=$(blkid -o value -s PARTUUID ${DRIVE}2)
fi

if [[ -b /dev/sdb ]]; then
    SOURCES=$(blkid -o value -s UUID /dev/sdb1)
fi
if [[ -b /dev/sdc ]]; then
    SWAP2=$(blkid -o value -s UUID /dev/sdc1)
fi
## create fstab
cat > /etc/fstab <<EOF
# Begin /etc/fstab

# file system  mount-point    type     options             dump  fsck
#                                                                order
EOF

## append sysv header
if [[ ${YBUILD_RELEASE} == "sysv" ]]; then
    cat >> /etc/fstab <<EOF
proc           /proc          proc     nosuid,noexec,nodev 0     0
sysfs          /sys           sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs          /run           tmpfs    defaults            0     0
devtmpfs       /dev           devtmpfs mode=0755,nosuid    0     0
tmpfs          /dev/shm       tmpfs    nosuid,nodev        0     0
cgroup2        /sys/fs/cgroup cgroup2  nosuid,noexec,nodev 0     0

EOF
fi

## Append drive info
cat >> /etc/fstab <<EOF
UUID=$ROOT      /              ext4     defaults            1     1
UUID=$SWAP      swap           swap     pri=1               0     0
UUID=$UEFI_MNT
# End /etc/fstab
EOF

[ -n ${SOURCES} ] && echo "UUID=${SOURCES}  /mnt/sources  btrfs  noauto,defaults  0  0" >> /etc/fstab
[ -n ${SWAP} ] && echo "UUID=${SWAP}  swap  swap  pri=1  0  0" >> /etc/fstab

[ -f /etc/fstab ] && zzok " Created: /etc/fstab "

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
[ -f /etc/modprobe.d/usb.conf ] && zzok " Created: /etc/modprobe.d/usb.conf "

