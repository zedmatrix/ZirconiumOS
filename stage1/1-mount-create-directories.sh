#!/bin/bash
LFS=${LFS:-/mnt/lfs}

source check_fs.sh || { echo "Failed to source check_fs"; exit 1; }

# Mount ROOT partition if not already mounted
if ! mountpoint -q "$LFS"; then
    echo "Mounting $ROOT to $LFS"
    mount -v --mkdir "$ROOT" "$LFS" || {
        echo "Failed to mount $ROOT to $LFS"
        exit 1
    }
    chown -v root:root $LFS
    chmod -v 755 $LFS
else
    echo "$LFS is already mounted."
fi

[[ -n $SWAP ]] && /sbin/swapon $SWAP || { echo "Failed to Activate Swap"; exit 1; }

# Setup zbuild paths
mkdir -pv $LFS/zbuild/{tmp,log}
ln -sv zbuild.cfg.lfs $LFS/zbuild/zbuild.cfg

# Setup LFS Limited directories
mkdir -pv $LFS/{etc,var,tools,sources} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
