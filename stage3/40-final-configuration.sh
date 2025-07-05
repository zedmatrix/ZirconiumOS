#!/bin/bash
zmsg() { printf "*** %s\n" "$@"; }
SOURCES=${SOURCES:-/sources}
ZBUILD=${ZBUILD:-/zbuild}
ZTEMP=${ZTEMP:=$ZBUILD/tmp}

cat > /etc/rsyncd.conf << "EOF"
# This is a basic rsync configuration file
# It exports a single module without user authentication.

motd file = /home/rsync/welcome.msg
use chroot = yes

[localhost]
    path = /home/rsync
    comment = Default rsync module
    read only = yes
    list = yes
    uid = rsyncd
    gid = rsyncd

EOF
[ -f "/etc/rsyncd.conf" ] && zmsg "Created: /etc/rsyncd.conf"

zmsg " Configuring sshd"
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "KbdInteractiveAuthentication yes" >> /etc/ssh/sshd_config

cat > /etc/fuse.conf << "EOF"
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#
#mount_max = 1000

# Allow non-root users to specify the 'allow_other' or 'allow_root'
# mount options.
#
#user_allow_other
EOF
[ -f "/etc/fuse.conf" ] && zmsg " Created: /etc/fuse.conf"

pkgurl="https://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20241211.tar.xz"
archive=$(basename $pkgurl)
pkgdir=${archive%.tar*}

if [[ ! -f "${SOURCES}/$archive" ]]; then
    zmsg " Downloading: ${archive} "
    wget -P $SOURCES $pkgurl
fi

if [[ ! -d "${ZTEMP}/${pkgdir}" ]]; then
    zmsg " Extracting: ${archive} to ${pkgdir} "
    mkdir -pv "${ZTEMP}/${pkgdir}"
    tar -xf "${SOURCES}/$archive" -C "${ZTEMP}/${pkgdir}" --strip-components=1
fi

pushd "${ZTEMP}/${pkgdir}"
    zmsg " Installing: rsync systemd files "
    make install-rsyncd

    zmsg " Installing: sshd systemd files "
    make install-sshd

    zmsg " Installing: gpm systemd files "
    make install-gpm
popd
