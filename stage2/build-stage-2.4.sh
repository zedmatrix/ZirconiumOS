#!/bin/bash
stage2=(028-ncurses-6.5.zbc 029-sed-4.9.zbc 030-psmisc-23.7.zbc 031-gettext-0.25.zbc
 032-bison-3.8.2.zbc 033-grep-3.12.zbc 034-bash-5.3-rc2.zbc 035-libtool-2.5.4.zbc
 036-gdbm-1.25.zbc 037-gperf-3.3.zbc 038-expat-2.7.1.zbc 039-inetutils-2.6.zbc)

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
