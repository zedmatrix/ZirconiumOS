#!/bin/bash
# PKGDIR = PKGNAME + PKGVER

DOCDIR="${DESTDIR}/usr/share/doc/git-${PKGVER}"
MANDIR="${DESTDIR}/usr/share/man"
mkdir -pv ${DOCDIR}
mkdir -pv ${MANDIR}

echo "Extracting Archives"
tar -xf ${YSRC}/git-manpages-${PKGVER}.tar.xz -C ${MANDIR} --no-same-owner --no-overwrite-dir
tar -xf ${YSRC}/git-htmldocs-${PKGVER}.tar.xz -C ${DOCDIR} --no-same-owner --no-overwrite-dir

echo "Re-Organizing Manual and Documentation"
find ${DOCDIR} -type d -exec chmod 755 {} \;
find ${DOCDIR} -type f -exec chmod 644 {} \;

mkdir -vp ${DOCDIR}/man-pages/{html,text}
mv ${DOCDIR}/{git*.adoc,man-pages/text}
mv ${DOCDIR}/{git*.,index.,man-pages/}html

mkdir -vp ${DOCDIR}/technical/{html,text}
mv ${DOCDIR}/technical/{*.adoc,text}
mv ${DOCDIR}/technical/{*.,}html

mkdir -vp ${DOCDIR}/howto/{html,text}
mv ${DOCDIR}/howto/{*.adoc,text}
mv ${DOCDIR}/howto/{*.,}html

sed -i '/^<a href=/s|howto/|&html/|' ${DOCDIR}/howto-index.html
sed -i '/^\* link:/s|howto/|&html/|' ${DOCDIR}/howto-index.adoc
