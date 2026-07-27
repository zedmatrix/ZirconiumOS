#!/bin/bash
zprint() { echo -e "\033[1;32m *** $1 *** \033[0m"; }
stars() { printf '%.0s*' {1..100}; printf '\n'; }
YLFS=${YLFS:-"/mnt/ylfs"}

# Variables to pass to chroot
YBLD="/ybuild"
YSRC="${YBLD}/sources"
YHEAD="${YBLD}/prepare/ybase_header.sh"
YREPOS="${YBLD}/repos"
YBUILD="${YBLD}/Ybuild"
YBUILD_RELEASE=${YBUILD_RELEASE:-systemd}
XML_PRINT=${XML_PRINT:-FILE}

chroot_pre() {
    stars
    zprint " === Mounting Virtual Kernel Filesystems === "
    mkdir -pv $YLFS/{dev,proc,sys,run}
    mount -v --bind /dev $YLFS/dev
    mount -vt devpts devpts -o gid=5,mode=0620 $YLFS/dev/pts
    mount -vt proc proc $YLFS/proc
    mount -vt sysfs sysfs $YLFS/sys
    mount -vt tmpfs tmpfs $YLFS/run
    if [ -h $YLFS/dev/shm ]; then
        install -v -d -m 1777 $YLFS$(realpath /dev/shm)
    else
        mount -vt tmpfs -o nosuid,nodev tmpfs $YLFS/dev/shm
    fi
    if [ ! -f $YLFS/etc/resolv.conf ]; then
        printf "nameserver 1.1.1.1\nnameserver 8.8.8.8\n" > $YLFS/etc/resolv.conf
    fi
    stars
}

chroot_exec() {
    stars
    zprint " === Entering Chroot $YLFS === "
    /usr/sbin/chroot "$YLFS" \
    /usr/bin/env -i HOME=/root TERM="$TERM" \
    PS1='($?)(Zirconium chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    YBLD=${YBLD} \
    YSRC=${YSRC} \
    YHEAD=${YHEAD} \
    YREPOS=${YREPOS} \
    YBUILD=${YBUILD} \
    XML_PRINT=${XML_PRINT} \
    YBUILD_RELEASE=${YBUILD_RELEASE} \
    MAKEFLAGS="-j$(nproc)" \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login
    zprint " === Welcome Back === "
    stars
}
check_unmount() { mountpoint -q "$1" && umount -v -l "$1"; }

chroot_post() {
    stars
    zprint " === Un-Mounting Virtual Kernel Filesystems === "
    check_unmount $LFS/sys/firmware/efi/efivars
    check_unmount $LFS/dev
    check_unmount $LFS/run
    check_unmount $LFS/proc
    check_unmount $LFS/sys
    stars
}
stars
# checks if directory exists
[ ! -d $LFS ] && { zprint "Error $LFS is not a mountpoint"; exit 1; }

# mounts virtual kernel filesystems
chroot_pre

# enters the new root environment
chroot_exec

# cleans up the virtual kernel filesystems
chroot_post

stars
