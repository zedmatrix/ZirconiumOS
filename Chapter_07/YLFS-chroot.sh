#!/bin/bash
YLFS=${YLFS:-/mnt/ylfs}

# Variables to pass to chroot
YBLD="/ybuild"
YSRC="${YBLD}/sources"
YHEAD="${YBLD}/prepare/ybase_header.sh"
YREPOS="${YBLD}/repos"
YBUILD="${YBLD}/Ybuild"
YBUILD_RELEASE=${YBUILD_RELEASE:-systemd}
XML_PRINT=${XML_PRINT:-FILE}

rows="$(stty size | cut -d ' ' -f 1)"
cols=$(expr "$(stty size | cut -d ' ' -f 2)" - 2)
zzreset="\033[0m"
zzred="\033[1;31m"
zzgreen="\033[1;32m"
zzyellow="\033[1;33m"
zzblue="\033[1;34m"
zzpurple="\033[1;35m"
zzcyan="\033[1;36m"
zzwhite="\033[1;37m"

zprint() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }
zstars() { echo -e "${zzblue} $(eval printf "%${cols}s" | tr ' ' '*') ${zzreset}"; }

chroot_pre() {
    zstars
    zprint " === Mounting Virtual Kernel Filesystems === "
    mkdir -pv $YLFS/{dev,proc,sys,run}
    mount --types proc /proc $YLFS/proc
    mount --rbind /sys $YLFS/sys
    mount --make-rslave $YLFS/sys
    mount --rbind /dev $YLFS/dev
    mount --make-rslave $YLFS/dev
    mount --rbind /run $YLFS/run
    mount --make-slave $YLFS/run

    if [ -h $YLFS/dev/shm ]; then
        install -v -d -m 1777 ${YLFS}$(realpath /dev/shm)
    else
        mount -vt tmpfs -o nosuid,nodev tmpfs $YLFS/dev/shm
    fi
    if [ ! -f $YLFS/etc/resolv.conf ]; then
        printf "nameserver 1.1.1.1\nnameserver 8.8.8.8\n" > $YLFS/etc/resolv.conf
    fi
    zstars
}

chroot_exec() {
    zstars
    zprint " === Entering Chroot $YLFS === "
    /usr/sbin/chroot "$YLFS" \
    /usr/bin/env -i HOME=/root TERM="$TERM" \
    PS1='($?)(Zirconium-chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    MAKEFLAGS="-j$(nproc)" \
    TESTSUITEFLAGS="-j$(nproc)" \
    YBLD=${YBLD} \
    YSRC=${YSRC} \
    YHEAD=${YHEAD} \
    YREPOS=${YREPOS} \
    YBUILD=${YBUILD} \
    XML_PRINT=${XML_PRINT} \
    YBUILD_RELEASE=${YBUILD_RELEASE} \
    /bin/bash --login
    zprint " === Welcome Back === "
    zstars
}
check_unmount() { mountpoint -q "$1" && umount -v -l "$1"; }

chroot_post() {
    zstars
    zprint " === Un-Mounting Virtual Kernel Filesystems === "
    check_unmount $YLFS/sys/firmware/efi/efivars
    check_unmount $YLFS/dev
    check_unmount $YLFS/run
    check_unmount $YLFS/proc
    check_unmount $YLFS/sys
    zstars
}

zstars
# checks if directory exists
[ ! -d $YLFS ] && { zprint "Error $YLFS is not a mountpoint"; exit 1; }

# mounts virtual kernel filesystems
chroot_pre

# enters the new root environment
chroot_exec

# cleans up the virtual kernel filesystems
chroot_post

zstars
