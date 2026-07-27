#!/bin/bash
# source ylfs-environment.sh first
[ -z $YLFS_ENVIRONMENT ] && { echo "Source the YLFS Environment"; exit 1; }
source ${PWD}/ybase_header.sh || { echo "Can Not Base Header"; exit 1; }

DRIVE=""
case $1 in
    sd[a-z]|vd[a-z]|hd[a-z]|nvme[0-9]n[0-9])
        DRIVE="/dev/${1}"
        [ -b $DRIVE ] || bad_drive
        ;;
    [?])
        echo "Usage: $0 [sda | vda | hda | nvme ]" >&2
        exit 1
        ;;
esac

[ -b $DRIVE ] && echo "Install Drive: $DRIVE " || bad_drive

ROOTPATH="/usr/sbin"
PATH=${ROOTPATH}:${PATH}

# Check Drive
pttype=$(lsblk -n -o PTTYPE $DRIVE | head -1)
printf "\n\t Drive: %s Partition Type: %s \n" $DRIVE $pttype

[[ $DRIVE =~ 'nvme' ]] && P=p || P=

if [[ $pttype == "dos" ]]; then
    SWAP="${DRIVE}1"
    ROOT="${DRIVE}2"
    printf "\n\t Assuming (SWAP:%s) (ROOT:%s) \n" $SWAP $ROOT
else
    UEFI="${DRIVE}${P}1"
    SWAP="${DRIVE}${P}2"
    ROOT="${DRIVE}${P}3"
    printf "\n\t Assuming (UEFI:%s) (SWAP:%s) (ROOT:%s) \n" $UEFI $SWAP $ROOT
fi

# Mount ROOT partition if not already mounted
if ! mountpoint -q "$YLFS"; then
    echo "Mounting $ROOT to $YLFS"
    mount -v --mkdir "$ROOT" "$YLFS" || {
        echo "Failed to mount $ROOT to $YLFS"
        exit 1
    }
    chown -v root:root $YLFS
    chmod -v 755 $YLFS
else
    echo "$YLFS is already mounted."
fi

[ ! -z $SWAP ] && /sbin/swapon -e --show $SWAP

# Setup yaml-builder paths
mkdir -pv $YLFS/ybuild/{xml,tmp,log,repos,image,prepare,sources}

# Setup LFS Limited directories
mkdir -pv $YLFS/{etc,var,tools} $YLFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  [ ! -e "$YLFS/$i" ] && ln -sv usr/$i $YLFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $YLFS/lib64 ;;
esac
