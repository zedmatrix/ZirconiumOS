#!/bin/bash
zmsg() { printf "*** %s ***\n" "${@}"; }

pkgdir="linux-6.6.94"
pkgname="linux"
pkgver="6.6.94"
pkgurl="https://cdn.kernel.org/pub/linux/kernel/v6.x/${pkgdir}.tar.xz"
md5sum="50996413e03fa86b18024b2188c2f7b5"
zbuild=${zbuild:-/zbuild}
zsource=${zsource:-/sources}

#extract
archive=$(basename $pkgurl)

if [[ ! -f "${zsource}/${archive}" ]]; then
    zmsg "Downloading: ${archive} "
    [ ! -x "/usr/bin/wget" ] && { zmsg "You Should Have Installed Wget. Missing. Exiting."; exit 1; }
    wget -P ${zsource} ${pkgurl}
fi

#tests
#diff -y --suppress-common-lines dreamlfs_config-6.6.77-lfs liveiso_config-6.6.93
#diff -y --suppress-common-lines lfsmediatv_config-6.6.74 liveiso_config-6.6.93

# preconfig - optional merge your config from the live iso
zcat /proc/config.gz > .config

cp -v ${ZBUILD}/lfsmediatv_config-6.6.74 base.config
#cp -v ${ZBUILD}/dreamlfs_config-6.6.77-lfs base.config

./scripts/kconfig/merge_config.sh -m .config base.config

# prepare
make olddefconfig
make menuconfig

# build and compile
make
make modules_install

# install kernel -r12.3-71-systemd
export pkgver=6.6.94
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-${pkgver}-lfs
cp -iv System.map /boot/System.map-${pkgver}
cp -iv .config /boot/config-${pkgver}

# optional install documenation
cp -r Documentation -T /usr/share/doc/linux-${pkgver}

# post configuration
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

