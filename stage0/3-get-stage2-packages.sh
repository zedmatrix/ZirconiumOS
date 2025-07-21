#!/bin/bash
print() { printf "%s\n" "$*"; }

print "Getting Stage 3 Extra Packages"
set +h
umask 022
LFS=${LFS:-/mnt/lfs}
ZSRC=${ZSRC:-$LFS/sources}
ZBUILD=${ZBUILD:-$LFS/zbuild}

download() {
    # Usage: $1 = file , $2 = url , $3 = md5
    local file=$1
    local url=$2
    local md5=$3
    print "Checking for $file ..."
    if [[ ! -f "${ZSRC}/$file" ]]; then
        wget -nc -P $ZSRC "${url}"
    fi
    local newmd5=$(md5sum "$ZSRC/$file" | awk '{print $1}')
    echo "$newmd5 $file" >> zbuild-stage2-md5sums
    [[ $newmd5 == $md5 ]] && print "$file Ok" || print "$file Fail $newmd5"
}

while IFS=' ' read -r md5 url; do
    # Skip empty lines and comments
    [[ -z "$md5" || "$md5" == \#* ]] && continue

    archive=$(basename "$url")
    echo "Archive: $archive URL: $url"
    download "$archive" "$url" "$md5"
done < stage2-extra-packages

export LFS ZSRC ZBUILD
