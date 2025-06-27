#!/bin/bash
stage2=(040-less-678.zbc 041-perl-5.40.2.zbc 042-xml-parser-2.47.zbc 043-intltool-0.51.0.zbc
 044-autoconf-2.72.zbc 045-automake-1.18.zbc 046-openssl-3.5.0.zbc 047-elfutils-0.193.zbc
 048-libffi-3.5.1.zbc 049-Python-3.13.5.zbc)

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
