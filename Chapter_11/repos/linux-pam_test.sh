#!/bin/sh
install -v -m755 -d /etc/pam.d

cat > /etc/pam.d/other << "EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF
[ -f /etc/pam.d/other ] && echo "Created: /etc/pam.d/other"
echo "Now Testing ${PKGDIR}"
