#!/bin/sh
echo "Configuring Dictionary"

mkdir -pv ${DESTDIR}/usr/share/dict
xzcat ${YSRC}/cracklib-words-2.10.3.xz > ${DESTDIR}/usr/share/dict/cracklib-words

ln -vsf cracklib-words ${DESTDIR}/usr/share/dict/words

echo $(hostname) >> ${DESTDIR}/usr/share/dict/cracklib-extra-words

mkdir -pv ${DESTDIR}/usr/lib/cracklib

# echo "Creating Cracklib Dictionary"
# create-cracklib-dict /usr/share/dict/cracklib-words /usr/share/dict/cracklib-extra-words

# echo "Testing Python Module"
# python3 -c 'import cracklib; cracklib.test()'
