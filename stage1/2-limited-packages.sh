#!/bin/bash
print() { printf "%s\n" "$*"; }
# Get the Limited Packages for stage1

print "Getting Limited Packages"
set +h
umask 022
LFS=${LFS:-/mnt/lfs}
SOURCES=${SOURCES:-$LFS/sources}

download() {
    # Usage: $1 = file , $2 = url , $3 = md5
    local file=$1
    local url=$2
    local md5=$3
    print "Checking for $file ..."
    wget -nc -P $SOURCES "${url}"
    local newmd5=$(md5sum "$SOURCES/$file" | awk '{print $1}')
    echo "$newmd5 $file" >> md5sums
    [[ $newmd5 == $md5 ]] && print "Ok" || print "Fail $newmd5"
}

while IFS=' ' read -r md5 url; do
    # Skip empty lines and comments
    [[ -z "$md5" || "$md5" == \#* ]] && continue

    archive=$(basename "$url")
    echo "Archive: $archive URL: $url"
    download "$archive" "$url" "$md5"
done < source_list.txt
