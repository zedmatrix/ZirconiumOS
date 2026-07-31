#!/bin/sh

echo "Configuring rpcbind sysv init script"

install -v -m 754 ${YPKG}/rpcbind.script /etc/rc.d/init.d/rpcbind

ln -sfv  ../init.d/rpcbind /etc/rc.d/rc0.d/K49rpcbind
ln -sfv  ../init.d/rpcbind /etc/rc.d/rc1.d/K49rpcbind
ln -sfv  ../init.d/rpcbind /etc/rc.d/rc2.d/S22rpcbind
ln -sfv  ../init.d/rpcbind /etc/rc.d/rc3.d/S22rpcbind
ln -sfv  ../init.d/rpcbind /etc/rc.d/rc4.d/S22rpcbind
ln -sfv  ../init.d/rpcbind /etc/rc.d/rc5.d/S22rpcbind
ln -sfv  ../init.d/rpcbind /etc/rc.d/rc6.d/K49rpcbind

echo "Done"
