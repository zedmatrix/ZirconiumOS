#!/bin/bash
YLFS=${YLFS:="/mnt/ylfs"}

echo "Starting"

rm -rf $YLFS/tmp/{*,.*}

find $YLFS/usr/lib $YLFS/usr/libexec -name \*.la -delete

find $YLFS/usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
# find $YLFS/usr -depth -name $(uname -m)-lfs-linux-musl\* | xargs rm -rf

# userdel -r tester

echo "Done"
