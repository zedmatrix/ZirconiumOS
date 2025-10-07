#!/bin/bash
zprint() { echo -e "\033[1;32m *** $1 *** \033[0m"; }
stars() { printf '%.0s*' {1..100}; printf '\n'; }
LFS=${LFS:-/mnt/lfs}
COMMAND="$1"

if [ -z "${COMMAND}" ]; then
    zprint "Error in Makefile Command Processing"
    exit 1
fi

if [ ! -f "${LFS}/ybuild/${COMMAND}" ]; then
    zprint "Script ${COMMAND} not found in ${LFS}/ybuild/"
    exit 1
fi

chroot_pre() {
    stars
    zprint " === Mounting Virtual Kernel Filesystems === "
    mkdir -pv $LFS/{dev,proc,sys,run}
    mount -v --bind /dev $LFS/dev
    mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
    mount -vt proc proc $LFS/proc
    mount -vt sysfs sysfs $LFS/sys
    mount -vt tmpfs tmpfs $LFS/run
    if [ -h $LFS/dev/shm ]; then
        install -v -d -m 1777 $LFS$(realpath /dev/shm)
    else
        mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
    fi
    if [ ! -f $LFS/etc/resolv.conf ]; then
        printf "nameserver 1.1.1.1\nnameserver 8.8.8.8\n" > $LFS/etc/resolv.conf
    fi
    stars
}

chroot_exec() {
    stars
    zprint " === Entering Chroot $LFS === "
    /usr/sbin/chroot "$LFS" \
    /usr/bin/env -i HOME=/ybuild TERM="$TERM" \
    PS1="\[\$?\](lfs chroot) \u:\w\$ " \
    PATH=/usr/bin:/usr/sbin \
    MAKEFLAGS="-j$(nproc)" \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login -c "/ybuild/${COMMAND}"
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
