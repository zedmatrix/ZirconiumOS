#!/bin/bash
## For Auto YLFS - July 30th - 2026
YLFS=${YLFS:="/mnt/ylfs"}

save_usrlib="$(cd $YLFS/usr/lib; ls ld-linux*[^g])
             libc.so
             libthread_db.so.1
             libquadmath.so.0.0.0
             libstdc++.so.6.0.35
             libitm.so.1.0.0
             libatomic.so.1.2.0"

pushd $YLFS/usr/lib

for LIB in $save_usrlib; do
    objcopy --only-keep-debug --compress-debug-sections=zstd $LIB $LIB.dbg
    cp $LIB /tmp/$LIB
    strip --strip-debug /tmp/$LIB
    objcopy --add-gnu-debuglink=$LIB.dbg /tmp/$LIB
    install -vm755 /tmp/$LIB $YLFS/usr/lib
    rm /tmp/$LIB
done

export online_usrbin="bash find strip"
export online_usrlib="libbfd-2.47.20260726.so
               libsframe.so.3.0.0
               libhistory.so.8.3
               libncursesw.so.6.6
               libm.so.6
               libreadline.so.8.3
               libz.so.1.3.2
               libzstd.so.1.5.7
               $(cd $YLFS/usr/lib; find libnss*.so* -type f)"

for BIN in $online_usrbin; do
    cp -v $YLFS/usr/bin/$BIN /tmp/$BIN
    strip --strip-unneeded /tmp/$BIN
    install -vm755 /tmp/$BIN $YLFS/usr/bin
    rm /tmp/$BIN
done

for LIB in $online_usrlib; do
    cp -v $YLFS/usr/lib/$LIB /tmp/$LIB
    strip --strip-unneeded /tmp/$LIB
    install -vm755 /tmp/$LIB $YLFS/usr/lib
    rm /tmp/$LIB
done

for i in $(find $YLFS/usr/lib -type f -name \*.so* ! -name \*dbg) \
         $(find $YLFS/usr/lib -type f -name \*.a)                 \
         $(find $YLFS/usr/{bin,sbin,libexec} -type f); do
    case "$online_usrbin $online_usrlib $save_usrlib" in
        *$(basename $i)* )
            ;;
        * ) [[ $(file $i | grep 'not stripped') ]] && strip --strip-unneeded $i
            ;;
    esac
done

popd
unset BIN LIB save_usrlib online_usrbin online_usrlib
