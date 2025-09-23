#!/bin/bash

mkdir -vp /usr/share/doc/git-2.51.0

echo "Extracting Archives"
tar -xf ${YSRC}/git-manpages-2.51.0.tar.xz -C /usr/share/man --no-same-owner --no-overwrite-dir
tar -xf ${YSRC}/git-htmldocs-2.51.0.tar.xz -C /usr/share/doc/git-2.51.0 --no-same-owner --no-overwrite-dir

echo "Re-Organizing Manual and Documentation"
find /usr/share/doc/git-2.51.0 -type d -exec chmod 755 {} \;
find /usr/share/doc/git-2.51.0 -type f -exec chmod 644 {} \;

mkdir -vp /usr/share/doc/git-2.51.0/man-pages/{html,text}
mv /usr/share/doc/git-2.51.0/{git*.adoc,man-pages/text}
mv /usr/share/doc/git-2.51.0/{git*.,index.,man-pages/}html

mkdir -vp /usr/share/doc/git-2.51.0/technical/{html,text}
mv /usr/share/doc/git-2.51.0/technical/{*.adoc,text}
mv /usr/share/doc/git-2.51.0/technical/{*.,}html

mkdir -vp /usr/share/doc/git-2.51.0/howto/{html,text}
mv /usr/share/doc/git-2.51.0/howto/{*.adoc,text}
mv /usr/share/doc/git-2.51.0/howto/{*.,}html

sed -i '/^<a href=/s|howto/|&html/|' /usr/share/doc/git-2.51.0/howto-index.html
sed -i '/^\* link:/s|howto/|&html/|' /usr/share/doc/git-2.51.0/howto-index.adoc
