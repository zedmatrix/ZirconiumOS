#!/bin/bash
zmsg() { printf "%s\n" "${@}"; }

## Xorg Libraries
counter=25
filelist=xorglib-filelist.txt
baseurl="https://www.x.org/pub/individual/lib/"

grep -v '^#' "$filelist" | while read -r pkgmd5 archive
do
    packagedir=${archive%.tar.?z*}
    pkgname=${packagedir%-*}
    pkgver=${packagedir##*-}
    zmsg "Creating $packagedir"

    prefix=$(printf "%03d" "$counter")
    target_name="${prefix}-${packagedir}.zbc"
    cp -v xorglib_base-config.zbc "$target_name"

    sed -i "s/PDIRNAME/${packagedir}/g" "$target_name"
    sed -i "s/PNAME/${pkgname}/" "$target_name"
    sed -i "s/PVER/${pkgver}/" "$target_name"
    sed -i "s/PMD5/${pkgmd5}/" "$target_name"
    sed -i "s|PURL|${baseurl}${archive}|" "$target_name"

    case $packagedir in
        libXfont2-[0-9]* )
            zmsg "      Check this file $target_name"
            echo "--disable-devel-docs" >> "$target_name"
        ;;
        libXt-[0-9]* )
            zmsg "      Check this file $target_name"
            echo "--with-appdefaultdir=/etc/X11/app-defaults" >> "$target_name"
        ;;
        libXpm-[0-9]* )
            zmsg "      Check this file $target_name"
            echo "--disable-open-zfile" >> "$target_name"
        ;;
        libpciaccess* )
            zmsg "      Check this file $target_name"
            echo "prepare=[meson setup build --prefix=/usr --buildtype=release]" >> "$target_name"
            echo "build=[meson compile -C build]" >> "$target_name"
            echo "install=[meson install -C build]" >> "$target_name"
        ;;
    esac
    counter=$((counter + 1))
done
