#!/bin/bash
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
SOURCES=$LFS/sources

PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export CFLAGS="-Os -pipe"
export CXXFLAGS="$CFLAGS"

export MAKEFLAGS=-j$(nproc)
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE SOURCES

# Restore Envionment
SWAP="/dev/sda1"
ROOT="/dev/sda2"

if ! mountpoint -q "$LFS"; then
    echo "Mounting $ROOT to $LFS"
    mount -v --mkdir "$ROOT" "$LFS" || {
        echo "Failed to mount $ROOT to $LFS"
        return 1
    }
    chown -v root:root $LFS
    chmod -v 755 $LFS
else
    echo "$LFS is already mounted."
fi

if [[ -n "$SWAP" ]]; then
    if grep -q "^$SWAP" /proc/swaps; then
        echo "Swap already active: $SWAP"
    elif /sbin/blkid "$SWAP" | grep -q 'TYPE="swap"'; then
        echo "Activating swap: $SWAP"
        /sbin/swapon "$SWAP" || { echo "Failed to activate swap"; return 1; }
    else
        echo "$SWAP is not a valid swap partition"
        return 1
    fi
fi

