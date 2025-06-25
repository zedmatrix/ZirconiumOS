#!/bin/bash
stage1=(7.3-gettext-0.25.zbc 7.4-bison-3.8.2.zbc 7.5-perl-5.40.2.zbc 7.6-Python-3.13.5.zbc
 7.7-texinfo-7.2.zbc 7.8-util-linux-2.41.zbc 7.9-nano-8.5.zbc)

for file in ${stage1[@]}; do
    echo "Executing: ./zbuild stage1/$file"
    echo "Press [SPACE] to skip 5s wait, or wait to continue..."

    read -t 5 -n 1 key
    if [[ $key == " " ]]; then
        echo "Skipped wait."
    else
        echo "Continuing..."
    fi

    ./zbuild "stage1/$file" || {
        echo "Error in $file - exit code $?"
        exit 1
    }

done

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

echo "At This Point you can Exit and Save the Stage 1 LFS Temporary Tools"

printf "Instructions: exit && cd $LFS \n"

printf " tar --exclude='sources' -cJpf $SOURCES/lfs-temp-tools-r12.3-71-systemd.tar.xz . \n"
