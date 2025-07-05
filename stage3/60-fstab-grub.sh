#!/bin/bash
zmsg() { printf "*** %s ***\n" "${@}"; }

zmsg "Creating /etc/fstab"
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

/dev/sda2     /            ext4     defaults            1     1
/dev/sda1     swap         swap     pri=1               0     0

# End /etc/fstab
EOF

zmsg "Creating /boot/grub/grub.cfg"

grub-install /dev/sda
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,2)
set gfxpayload=1024x768x32

menuentry "GNU/Linux, Linux-6.6.94-lfs-r12.3-71-systemd" {
        linux   /boot/vmlinuz-6.6.94-lfs root=/dev/sda2 ro
}
EOF
