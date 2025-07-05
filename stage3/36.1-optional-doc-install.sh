#!/bin/bash
zmsg() { printf "*** %s\n" "$@"; }
SOURCES=${SOURCES:-/sources}

mansrc="https://www.kernel.org/pub/software/scm/git/git-manpages-2.50.0.tar.xz"
docsrc="https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.50.0.tar.xz"

manpkg=$(basename $mansrc)
if [[ -f "${SOURCES}/${manpkg}" ]]; then
    zmsg " Installing: $manpkg to /usr/share/man "
    tar -xf "${SOURCES}/${manpkg}" -C /usr/share/man --no-same-owner --no-overwrite-dir

else
    zmsg " Error: Missing $manpkg "
    exit 1
fi

docpkg=$(basename $docsrc)
packagedir=$(echo "${docpkg%.tar.*}" | sed 's/-htmldocs//')
installdir="/usr/share/doc/${packagedir}"

if [[ -f "${SOURCES}/${docpkg}" ]]; then
    zmsg " Installing ${docpkg} into ${installdir}"
    mkdir -pv $installdir
    tar -xf "${SOURCES}/${docpkg}" -C "${installdir}" --no-same-owner --no-overwrite-dir

    find "${installdir}" -type d -exec chmod 755 {} \;
    find "${installdir}" -type f -exec chmod 644 {} \;

    mkdir -vp "${installdir}"/man-pages/{html,text}
    mv -v "${installdir}"/{git*.adoc,man-pages/text}
    mv -v "${installdir}"/{git*.,index.,man-pages/}html

    mkdir -vp "${installdir}"/technical/{html,text}
    mv -v "${installdir}"/technical/{*.adoc,text}
    mv -v "${installdir}"/technical/{*.,}html

    mkdir -vp "${installdir}"/howto/{html,text}
    mv -v "${installdir}"/howto/{*.adoc,text}
    mv -v "${installdir}"/howto/{*.,}html

    sed -i '/^<a href=/s|howto/|&html/|' "${installdir}"/howto-index.html
    sed -i '/^\* link:/s|howto/|&html/|' "${installdir}"/howto-index.adoc

else
    zmsg " Error: Missing $docpkg "
    exit 1
fi
