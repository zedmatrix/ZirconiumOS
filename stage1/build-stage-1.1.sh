#!/bin/bash
stage1=(5.1-binutils-2.44.zbc 5.2-gcc-15.1.0.zbc 5.3-linux-6.6.94.zbc 5.4-glibc-2.41.zbc 5.5-Libstdcpp.zbc)

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

echo "Test Exec: 5.4.1.glibc-tests.sh "
