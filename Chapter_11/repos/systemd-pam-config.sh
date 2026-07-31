#!/bin/sh

test_dir() {
	[ -f "/etc/pam.d/${1}" ] && echo "*** Created: /etc/pam.d/${1} ***"
}

echo " Configuring ${PKGDIR} "

mv -v /etc/pam.d/system-session{,.bak}

cat > /etc/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session for systemd

session  required    pam_unix.so
session  required    pam_loginuid.so
session  optional    pam_systemd.so

# End /etc/pam.d/system-session for systemd
EOF
test_dir system-session

cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user

account  required    pam_access.so
account  include     system-account

session  required    pam_env.so
session  required    pam_limits.so
session  required    pam_loginuid.so
session  optional    pam_keyinit.so force revoke
session  optional    pam_systemd.so

auth     required    pam_deny.so
password required    pam_deny.so

# End /etc/pam.d/systemd-user
EOF
test_dir systemd-user
