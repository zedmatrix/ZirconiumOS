#!/bin/bash
echo "Preparing and Running Tests"

mkdir -v 5-glibc-tests && pushd 5-glibc-tests

echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log

readelf -l a.out | grep ': /lib'

grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log

grep -B3 "^ $LFS/usr/include" dummy.log

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

grep "/lib.*/libc.so.6 " dummy.log

grep found dummy.log

popd
echo " Finished you can remove Directory: 5-glibc-tests"
