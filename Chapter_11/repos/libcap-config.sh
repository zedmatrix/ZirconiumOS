#!/bin/sh

test_dir() {
	[ -f "/etc/pam.d/${1}" ] && echo "*** Created: /etc/pam.d/${1} ***"
}

echo " Configuring ${PKGDIR} "

mv -v /etc/pam.d/system-auth{,.bak}

cat > /etc/pam.d/system-auth << "EOF"
# Begin /etc/pam.d/system-auth

auth      optional    pam_cap.so
auth      required    pam_unix.so

# End /etc/pam.d/system-auth
EOF
test_dir system-auth
