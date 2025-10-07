#!/bin/bash
set -e
pushd /ybuild

yinstall="/ybuild/yaml-install.sh"

package_list=(man-pages iana-etc glibc tzdata zlib bzip2 xz lz4 zstd file readline pcre2 m4 bc
  flex tcl expect dejagnu pkgconf binutils gmp mpfr mpc attr acl libcap libxcrypt shadow gcc
  ncurses sed psmisc gettext bison grep bash libtool gdbm gperf expat inetutils less perl xml-parser
  intltool autoconf automake openssl libelf libffi sqlite python flit-core packaging wheel setuptools
  ninja meson kmod coreutils diffutils gawk findutils groff grub gzip iproute2 kbd libpipeline
  make patch tar texinfo nano markupsafe jinja2 systemd dbus man-db procps util-linux e2fsprogs)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
done

popd
