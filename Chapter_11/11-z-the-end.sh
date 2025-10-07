#!/bin/bash

release="r12.4-16-systemd-wip"
codename="zirconium"

echo $release > /etc/lfs-release

cat > /etc/lsb-release << EOF
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="$release"
DISTRIB_CODENAME="$codename"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

cat > /etc/os-release << EOF
NAME="Linux From Scratch"
VERSION="$release"
ID=lfs
PRETTY_NAME="Linux From Scratch $release"
VERSION_CODENAME="$codename"
HOME_URL="https://www.linuxfromscratch.org/lfs/"
RELEASE_TYPE="development"
EOF
