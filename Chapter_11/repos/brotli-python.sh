#!/bin/sh

echo "--- Generating Python Binding ---"

sed -e '/libraries +=/s/=.*/= [required_system_library[3:]]/' \
    -e '/package_configuration/d' -e '/pkgconfig/d' -i setup.py

USE_SYSTEM_BROTLI=1 pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD

pip3 install --no-index --find-links dist --no-user Brotli

echo "--- Finished ---"
