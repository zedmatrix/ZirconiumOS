#!/bin/bash
print() { printf "%s\n" "$*"; }

print "Getting Main Systemd Packages"
set +h
umask 022
LFS=${LFS:-/mnt/lfs}
ZSRC=${ZSRC:-$LFS/sources}
ZBUILD=${ZBUILD:-$LFS/zbuild}

download() {
    # Usage: $1 = file , $2 = url
    local file=$1
    local url=$2
    wget -nc -P $ZSRC "$url"
    local md5=$(md5sum "$ZSRC/$file" | awk '{print $1}')
    echo "$md5  $file" >> zbuild-md5sums
}

while IFS=' ' read -r url; do
    [[ -z "$url" || "$url" == \#* ]] && continue

    archive=$(basename "$url")
    echo "Archive: $archive URL: $url"
    if [[ ! -f $ZSRC/$archive ]]; then
        print "Downloading: $file "
        download "$archive" "$url"
    else
        print "Skipping: $archive"
    fi
done < stage2-main-systemd

export LFS ZSRC ZBUILD
