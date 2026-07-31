#!/bin/sh

echo "Creating Rsyncd.conf"

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
[ -f /etc/rsyncd.conf ] && echo "*** Created: /etc/rsyncd.conf ***"

cat > /home/rsync/welcome.msg <<EOF
Welcome to $(hostname)
*****************************
EOF

[ -f /home/rsync/welcome.msg ] && echo "*** Created: /home/rsync/welcome.msg ***"
chown -v rsyncd:rsyncd /home/rsync/welcome.msg

if [[ ${YBUILD_RELEASE} == "sysv" ]]; then
    install -vm 754 ${YPKG}/initd-rsyncd /etc/rc.d/init.d/rsyncd
    ln -sfv  ../init.d/rsyncd /etc/rc.d/rc0.d/K30rsyncd
    ln -sfv  ../init.d/rsyncd /etc/rc.d/rc1.d/K30rsyncd
    ln -sfv  ../init.d/rsyncd /etc/rc.d/rc2.d/S30rsyncd
    ln -sfv  ../init.d/rsyncd /etc/rc.d/rc3.d/S30rsyncd
    ln -sfv  ../init.d/rsyncd /etc/rc.d/rc4.d/S30rsyncd
    ln -sfv  ../init.d/rsyncd /etc/rc.d/rc5.d/S30rsyncd
    ln -sfv  ../init.d/rsyncd /etc/rc.d/rc6.d/K30rsyncd
fi
