#!/bin/bash
set +h
umask 022
LFS=${LFS:-/mnt/lfs}
SOURCES=${SOURCES:-$LFS/sources}
ZBUILD=${ZBUILD:-$LFS/zbuild}

echo " Getting the Final Packages For the System Build "

srcpkg=$ZBUILD/stage2/000-wget-list-systemd
if [[ -f $srcpkg ]]; then
    wget -P $SOURCES -nc -c --input-file=stage2/000-wget-list-systemd
else
    echo "Error Missing $srcpkg File"
    exit 1
fi

srcmd5=$ZBUILD/stage2/000-md5sums
if [[ -f $srcmd5 ]]; then
    pushd $SOURCES
    md5sum -c $srcmd5
    popd
else
    echo "Error Missing $srcmd5 File"
    exit 1
fi

echo "Enter the Chroot using: stage1/7.1-zlfs-chroot.sh "
