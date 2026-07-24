#	Betelgeuse - Zirconium Development - Release 4
Temporary Environment File: nano /tmp/ylfs-environment.sh && source
##	Prepare Disks
- From Ybuild ISO
  1. cd /ybuild/prepare
  2. ./install-filesystem.sh sda uefi
  3. ./install-directories.sh sda
  4. swapon /dev/sda2
  5. swapon /dev/sdc1
  6. mount --mkdir -v /dev/sdb1 /sources

##	Source Prepare
Git: git clone --branch={commit} {url}

Binutils-2.47.50.20260722
```
git archive --remote=git://sourceware.org/git/binutils-gdb.git \
  --format=tar.gz --prefix=binutils-2.46.1/ \
  --output=binutils-2.46.1-git.tar.gz \
  81a1c8f753e506b3890db4b1254df05aa67a0230

git clone --branch=81a1c8f753e506b3890db4b1254df05aa67a0230 git://sourceware.org/git/binutils-gdb.git
git archive --format=tar.gz --prefix=binutils-2.46.1/ --output=../binutils-2.46.1-git.tar.gz 81a1c8f753e506b3890db4b1254df05aa67a0230
```

GCC-17.0.0
```
git clone --filter=blob:none https://github.com/gcc-mirror/gcc.git
cd gcc
	git describe --tags
	git archive --format=tar.gz --prefix=gcc-17-2625-gf764d7111a2/ \
    --output=../gcc-17-2625-gf764d7111a2.tar.gz HEAD
cd ../
```
Glibc-2.43.9000:
```
git clone --filter=blob:none git://sourceware.org/git/glibc.git
git archive --format=tar.gz --prefix=glibc-2.43.9000/ \
  --output=../glibc-2.43.9000-540-g0f731d92cd.tar.gz HEAD
```
## 	Building Cross Tools
Repos: Cross<br>
Using New ./pkg-install.sh {package}
---
- binutils-2.46.1-20260722-p1 (2.47.50.20260722)
- gcc-17-2625-gf764d7111a2-p1
- linux-7.1.4-headers
- glibc-2.43.9000-540-g0f731d92cd-tmp
- libstdcpp-17-2625-gf764d7111a2
---
- m4-1.4.21-tmp
- ncurses-6.6-tmp
- bash-5.3.15-tmp
- coreutils-9.11-tmp
- diffutils-3.12-tmp
- file-5.48-tmp
- findutils-4.10.0-tmp
- gawk-5.4.1-tmp
- grep-3.12-tmp
- gzip-1.14-tmp
- make-4.4.1-tmp
- patch-2.8-tmp
- sed-4.10-tmp
- tar-1.35-tmp
- xz-5.8.3-tmp
- nano-9.1-tmp
---
- binutils-2.46.1-20260722-p2 (2.47.50.20260722)
- gcc-17-2625-gf764d7111a2-p2 (17.0.0)
---
1. Copy /sources/{gettext-1.0,bison-3.8.2,perl-5.42.2,Python-3.14.6,texinfo-7.3,util-linux-2.42.2}.tar.* sources/
+ $YLFS/usr/sbin/YLFS-chroot.sh
+ 2-creating-dirs-both.sh
+ 3-create-files_sysv-and-systemd.sh
- gettext-1.0-tmp
- bison-3.8.2-tmp
- perl-5.42.2-tmp
- python-3.14.6-tmp
- texinfo-7.3-tmp
- util-linux-2.42.2-tmp
- zz-cleanup.sh
---
Optional Save Temporary Tool Chain
---
##	Building Base System
Repos: Base
- iana-etc-20260617
- glibc-2.43.9000-540-g0f731d92cd
- zlib-1.3.2
- bzip2-1.0.8
- xz-5.8.3
- lz4-1.10.0
- zstd-1.5.7
- file-5.48
- readline-8.3
- pcre-10.47
- m4-1.4.21
- bc-7.0.3
- flex-2.6.4
- tcl-8.6.18
- expect-5.45.4
- dejagnu-1.6.3
- pkgconf-2.5.1
- gmp-6.3.0
- mpfr-4.2.2
- mpc-1.4.1
- binutils-2.46.1-20260722 (2.47.50.20260722)
- attr-2.6.0
- acl-2.4.0
- libcap-2.78
- libxcrypt-4.5.2
- shadow-4.19.4
- gawk-5.4.1
- gcc-17-2625-gf764d7111a2
- ncurses-6.6
- sed-4.10
- psmisc-23.7
- gettext-1.0
- bison-3.8.2
- gperf-3.3
- grep-3.12
- bash-5.3.15
- libtool-2.5.4
- gdbm-1.26
- expat-2.8.2
- inetutils-2.8
- less-704
- perl-5.42.2
  - class-inspector-1.36
  - file-sharedir-install-0.14
  - file-sharedir-1.118
  - xml-parser-2.59
  - intltool-0.51.0
- autoconf-2.73
- automake-1.18.1
- openssl-3.6.3
- libelf-0.195
- libffi-3.7.1
- sqlite-3.53.3
- python-3.14.6
  - flit-core-3.12.0
  - packaging-26.2
  - wheel-0.47.0
  - setuptools-83.0.0
  - ninja-1.13.2
  - meson-1.11.2
- kmod-34.2
- coreutils-9.11
- diffutils-3.12
- findutils-4.10.0
- groff-1.24.1
- gzip-1.14
- iproute2-7.1.0
- kbd-2.10.0
- libpipeline-1.5.8
- make-4.4.1
- patch-2.8
- tar-1.35
- texinfo-7.3
- nano-9.1
- markupsafe-3.0.3
- jinja2-3.1.6
- pyelftools-0.33
- systemd-261.1
- dbus-1.16.2
- man-pages-6.18
- man-db-2.13.1
- procps-ng-4.0.6
- util-linux-2.42.2
- e2fsprogs-1.47.4
- which-2.25
- openssh-10.4p1
  - allow root login: ` echo "PermitRootLogin yes" >> /etc/ssh/sshd_config `

##	Building Configuration Packages
Repos: Kernel
- lzo-2.10
- libarchive-3.8.8
- libaio-0.3.113
- libunistring-1.4.2
- libidn2-2.3.8
- libtasn1-4.21.0
- libpsl-0.23.0
- libusb-1.0.30
- libpng-1.6.58
- hwdata-0.409
- libdisplay-info-0.3.0
- popt-1.19
- p11-kit-0.26.4
- make-ca-1.16.1
- pciutils-3.15.0
- usbutils-019
- wget-1.25.0
- curl-8.21.0
- dosfstools-4.2
- efivar-39
- efibootmgr-18
- lvm2-2.03.41
- btrfs-progs-7.1
- fuse3-3.18.2
- freetype2-2.14.3
- grub-2.14-efi

##	Configure and Booting
- 1-create-fstab.sh
- linux-7.1.4
- 3-create-grub.sh
- wireless-regdb-20260530
- zlfs-scripts-20260506T1015Z
---
Reboot
---
##	Post Security
Repos: Post
- rsync-3.4.4
- git-2.54.0
  - linux-firmware-20260622 
- squashfs-tools-4.7.5
