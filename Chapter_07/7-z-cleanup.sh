#!/bin/bash

echo "Cleaning Info, Man and Doc"
rm -rf /usr/share/{info,man,doc}/*

echo "Removing Libtool Archive Files"
find /usr/{lib,libexec} -name \*.la -delete

echo "Removing Temp Tooldir"
rm -rf /tools

echo "Removing Ybuild Temp Files"
rm -rf /ybuild/tmp/*

echo "* Done *"
