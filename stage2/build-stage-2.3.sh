#!/bin/bash
stage2=(016-dejagnu-1.6.3.zbc 017-pkgconf-2.4.3.zbc 018-binutils-2.44.zbc 019-gmp-6.3.0.zbc
 020-mpfr-4.2.2.zbc 021-mpc-1.3.1.zbc 022-attr-2.5.2.zbc 023-acl-2.3.2.zbc 024-libcap-2.76.zbc
 025-libxcrypt-4.4.38.zbc 026-shadow-4.17.4.zbc 027-gcc-15.1.0.zbc)

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

gcctest=stage2/027.1-gcc-15.1.0-test.sh
[ ! -x $gcctest ] && chmod -v +x $gcctest
. $gcctest

printf "\n\t\t 8.28.3. Setting the Root Password \n\n"
echo "Choose a password for user root and set it by running: "
echo "Command: passwd root"
