#!/bin/bash
zmsg() { printf "%s\n" "${@}"; }

## Xorg Libraries
counter=130
filelist=xorgfont-filelist.txt
baseurl="https://www.x.org/pub/individual/font/"

grep -v '^#' "$filelist" | while read -r pkgmd5 archive
do
    packagedir=${archive%.tar.?z*}
    pkgname=${packagedir%-*}
    pkgver=${packagedir##*-}
    zmsg "Creating $packagedir"

    prefix=$(printf "%03d" "$counter")
    target_name="${prefix}-${packagedir}.zbc"
    cp -v xorgfont_base-config.zbc "$target_name"

    sed -i "s/PDIRNAME/${packagedir}/g" "$target_name"
    sed -i "s/PNAME/${pkgname}/" "$target_name"
    sed -i "s/PVER/${pkgver}/" "$target_name"
    sed -i "s/PMD5/${pkgmd5}/" "$target_name"
    sed -i "s|PURL|${baseurl}${archive}|" "$target_name"

    counter=$((counter + 1))
done
