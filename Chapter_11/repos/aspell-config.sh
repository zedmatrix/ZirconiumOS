#!/bin/sh
echo "Configuring and Installing the English dictionary"
tar -xf ${YSRC}/aspell6-en-2026.02.25-0.tar.bz2

cd aspell6-en-2026.02.25-0

./configure
make

make install

echo "**** Done ****"
