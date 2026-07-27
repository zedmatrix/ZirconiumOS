#!/bin/bash
#
# Usage: source ylfs-environment.sh
#
if [[ -z ${YLFS_ENVIRONMENT} ]]; then
	export YLFS_ENVIRONMENT=1
fi

set +h
umask 022
LC_ALL=POSIX

YTARGET=$(uname -m)-lfs-linux-gnu
YARCH="glibc"

# YTARGET=$(uname -m)-lfs-linux-musl
# YARCH="musl"

YLFS=${YLFS:-"/mnt/ylfs"}
YBLD="${YLFS}/ybuild"
YSRC=${YSRC:-"${YBLD}/sources"}
YREPOS=${YREPOS:-"${YBLD}/repos"}
YHEAD=${YHEAD:-"${YBLD}/prepare/ybase_header.sh"}
YBUILD=${YBUILD:-"${YBLD}/Ybuild"}
XML_PRINT=${XML_PRINT:-FILE} # PRINT - simple output to screen

PATH=/usr/bin:/usr/sbin
if [ ! -L /bin ]; then PATH=/bin:/sbin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
# CFLAGS="-Os -pipe"
# CXXFLAGS="$CFLAGS"
# LDFLAGS=""

export MAKEFLAGS=-j$(nproc)
export YLFS YTARGET PATH CONFIG_SITE
export YSRC YBLD YREPOS YARCH
export YHEAD YBUILD XML_PRINT
# export CFLAGS CXXFLAGS LDFLAGS
