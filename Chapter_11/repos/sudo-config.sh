#!/bin/sh

echo " Configuring ${PKGDIR} "

cat > /etc/sudoers.d/00-sudo << "EOF"
# Begin of 00-sudo

Defaults secure_path="/usr/sbin:/usr/bin"

%wheel ALL=(ALL) ALL

# Examples:
# somebody ALL=(ALL): somecommand
# somebody ALL=(someoneelse) NOPASSWD: somecommand

# End of 00-sudo
EOF
[ -f "/etc/sudoers.d/00-sudo" ] && echo "*** Created: /etc/sudoers.d/00-sudo"

cat > /etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo

# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/sudo
EOF
[ -f "/etc/pam.d/sudo" ] && echo "*** Created: /etc/pam.d/sudo"
chmod 644 /etc/pam.d/sudo
