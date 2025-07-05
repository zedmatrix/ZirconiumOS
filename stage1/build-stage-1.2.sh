#!/bin/bash
stage1=(6.1-m4-1.4.20.zbc 6.2-ncurses-6.5.zbc 6.3-bash-5.3-rc2.zbc 6.4-coreutils-9.7.zbc 6.5-diffutils-3.12.zbc
 6.6-file-5.46.zbc 6.7-findutils-4.10.0.zbc 6.8-gawk-5.3.2.zbc 6.9-grep-3.12.zbc
 6.10-gzip-1.14.zbc  6.11-make-4.4.1.zbc 6.12-patch-2.8.zbc 6.13-sed-4.9.zbc 6.14-tar-1.35.zbc
 6.15-xz-5.8.1.zbc 6.16-binutils-2.44.zbc 6.17-gcc-15.1.0.zbc)

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

echo " Now chroot Exec: 7.1-zlfs-chroot.sh "

echo " Now Exec: 7.2-dirs-files-symlinks.sh "
