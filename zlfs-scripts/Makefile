#
# install --directory --mode=0755 --owner=root --group=root /etc/profile.d
# install --directory --mode=0755 --owner=root --group=root /etc/bash_completion.d
## tar --owner=0 --group=0 -cJf zlfs-scripts-$(date '+%Y-%m-%dT%M%S').tar.xz zlfs-scripts/
MODE=755
DIRMODE=754
CONFMODE=644
REV ?= systemd

#Default Target
all: install-dirs install-etc install-root install-skel install-profile install-$(REV)

install-dirs:
	install -m ${DIRMODE} -d /etc/skel
	install -m ${DIRMODE} -d /etc/profile.d

install-sysv:
	install -m $(DIRMODE) -d /etc/sysconfig
	install -m $(CONFMODE) etc/inittab           /etc/inittab
	install -m $(CONFMODE) etc/sysconfig/clock   /etc/sysconfig/clock
	install -m $(CONFMODE) etc/sysconfig/console /etc/sysconfig/console
	install -m ${MODE} services/dhcpcd  /lib/services

install-systemd:
	install -m $(MODE) -d /etc/systemd/network
	install -m $(CONFMODE) etc/systemd/10-ethernet-dhcp.network /etc/systemd/network
	install -m $(MODE) -d /usr/lib/systemd/system
	install -m $(CONFMODE) units/sshd.service /usr/lib/systemd/system
	install -m $(CONFMODE) units/sshdat.service /usr/lib/systemd/system/sshd@.service
	install -m $(CONFMODE) units/sshd.socket /usr/lib/systemd/system
	systemctl enable sshd.service

install-etc:
	@echo "Installing LFS and BLFS /etc files"
	install -m $(CONFMODE) etc/adjtime        /etc/adjtime
	install -m $(CONFMODE) etc/bashrc         /etc/bashrc
	install -m $(CONFMODE) etc/hosts          /etc/hosts
	install -m $(CONFMODE) etc/inputrc        /etc/inputrc
	install -m $(CONFMODE) etc/issue          /etc/issue
	install -m $(CONFMODE) etc/locale.conf    /etc/locale.conf
	install -m $(CONFMODE) etc/profile        /etc/profile
	install -m $(CONFMODE) etc/shells         /etc/shells
	install -m $(CONFMODE) etc/vconsole.conf  /etc/vconsole.conf

install-root:
	@echo "Installing Root Startup Files to /root"
	install -m ${MODE} bin/CurlPaste         /usr/bin/CurlPaste
	install -m ${MODE} bin/Login-Message     /usr/bin/Login-Message
	install -m ${MODE} bin/version-check     /usr/bin/version-check
	install -m $(CONFMODE) root/bash_login   /root/.bash_login
	install -m $(CONFMODE) root/bash_logout  /root/.bash_logout
	install -m $(CONFMODE) root/bash_profile /root/.bash_profile
	install -m $(CONFMODE) root/bashrc       /root/.bashrc
	install -m $(CONFMODE) root/profile      /root/.profile

install-skel:
	@echo "Installing skel useradd Files to /skel"
	install -m $(CONFMODE) root/bash_login   /etc/skel/.bash_login
	install -m $(CONFMODE) root/bash_logout  /etc/skel/.bash_logout
	install -m $(CONFMODE) root/bash_profile /etc/skel/.bash_profile
	install -m $(CONFMODE) root/bashrc       /etc/skel/.bashrc
	install -m $(CONFMODE) root/profile      /etc/skel/.profile

install-profile:
	@echo "Installing /etc/profile.d Files"
	install -m $(CONFMODE) etc/profile.d/0path-functions.sh   /etc/profile.d/0path-functions.sh
	install -m $(CONFMODE) etc/profile.d/bash_completion.sh   /etc/profile.d/bash_completion.sh
	install -m $(CONFMODE) etc/profile.d/dircolors.sh         /etc/profile.d/dircolors.sh
	install -m $(CONFMODE) etc/profile.d/extrapaths.sh        /etc/profile.d/extrapaths.sh
	install -m $(CONFMODE) etc/profile.d/i18n.sh              /etc/profile.d/i18n.sh
	install -m $(CONFMODE) etc/profile.d/readline.sh          /etc/profile.d/readline.sh
	install -m $(CONFMODE) etc/profile.d/umask.sh             /etc/profile.d/umask.sh

.PHONY: all install-dirs install-etc install-root install-skel install-profile install-systemd install-sysv
