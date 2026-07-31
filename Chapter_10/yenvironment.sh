#!/bin/bash
#
# Usage: source yenvironment.sh
#
set +h
umask 022
# LC_ALL=POSIX
LANG=en-US.UTF-8

YTARGET=$(uname -m)-lfs-linux-gnu
YARCH="glibc"

# YTARGET=$(uname -m)-lfs-linux-musl
# YARCH="musl"

YBLD=${YBLD:-"/ybuild"}
YSRC=${YSRC:-"${YBLD}/sources"}
YHEAD=${YHEAD:-"${YBLD}/prepare/ybase_header.sh"}
YREPOS=${YREPOS:-"${YBLD}/repos"}
# YBUILD_RELEASE=sysv
YBUILD_RELEASE=${YBUILD_RELEASE:-systemd}
YBUILD=${YBUILD:-"${YBLD}/Ybuild"}
# YCHECK=${YCHECK:-YES} # pre package now
XML_PRINT=${XML_PRINT:-FILE}

PATH=/usr/bin:/usr/sbin

# CFLAGS="-Os -pipe"
# CXXFLAGS="$CFLAGS"
# LDFLAGS=""

export MAKEFLAGS=-j$(nproc)
export PATH YSRC YBLD YREPOS YARCH YHEAD
export YBUILD YCHECK XML_PRINT YBUILD_RELEASE
