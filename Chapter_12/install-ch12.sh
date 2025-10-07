#!/bin/bash

yinstall="/ybuild/yaml-install.sh"

package_list=(libtirpc libnsl libuv cmake yaml-cpp gpm unix-tree icu boost
 libxml2 docbook-xml docbook-xsl-nons libxslt xmlto itstool asciidoc links
 py-build py-installer rsync lm-sensors lzo brotli nettle nasm yasm llvm
 cython jansson libevent c-ares nghttp2 libnl rpcbind rpcsvc-proto net-tools libseccomp
 linux-pam shadow-pam systemd-pam libcap-pam nspr nss libgpg-error libgcrypt libssh2
 lmdb cyrus-sasl openldap sudo gnutls duktape nfs-utils npth libksba libassuan
 gnupg gpgme gpgmepp docutils ply mako libyaml pyyaml iso-codes
)

for pkg in ${package_list[@]}; do
    ${yinstall} ${pkg} || { echo "Error in ${pkg}. Exiting."; break; }
done
