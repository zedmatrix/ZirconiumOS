#!/bin/sh
echo "Creating Image Directories"
mkdir -pv ${DESTDIR}/usr/share/doc/aspell-${PKGVER}/aspell{,-dev}.html
mkdir -pv ${DESTDIR}/usr/bin

echo "Installing Documentation"

install -vm644 manual/aspell.html/* ${DESTDIR}/usr/share/doc/aspell-${PKGVER}/aspell.html
install -vm644 manual/aspell-dev.html/* ${DESTDIR}/usr/share/doc/aspell-${PKGVER}/aspell-dev.html

install -vm 755 scripts/ispell ${DESTDIR}/usr/bin/
install -vm 755 scripts/spell ${DESTDIR}/usr/bin/

echo "**** Done ****"
