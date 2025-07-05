#!/bin/bash
stage2=(001-man-pages-6.14.zbc 002-iana-etc-20250519.zbc 003-glibc.zbc
 004-zlib-1.3.1.zbc 005-bzip2-1.0.8.zbc 006-xz-5.8.1.zbc 007-lz4-1.10.0.zbc
 008-zstd-1.5.7.zbc 009-file-5.46.zbc 010-readline-8.3-rc2.zbc 011-m4-1.4.20.zbc
 012-bc-7.0.3.zbc 013-flex-2.6.4.zbc 014-tcl-8.6.16.zbc 015-expect-5.45.4.zbc)

for file in ${stage2[@]}; do
    echo "Executing: ./zbuild stage2/$file"
    echo "Press [SPACE] to skip 5s wait, or wait to continue..."

    read -t 5 -n 1 key
    if [[ $key == " " ]]; then
        echo "Skipped wait."
    else
        echo "Continuing..."
    fi

    ./zbuild "stage2/$file" || {
        echo "Error in $file - exit code $?"
        exit 1
    }

done
