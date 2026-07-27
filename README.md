# Zirconium Linux From Scratch - r13

[Zirconium Dev ISO 26-June-2026](https://ln5.sync.com/dl/671e3b6d0#98prd74m-2j7j3g67-ns5rnmpb-ig8rzvgj)
> Complete with Ybuild and yaml definitions for LFS r13-dev<br>

## Zirconium OS - systemd

- `Chapter_02/ylfs-environment.sh` - Source the Environment.
- `Chapter_02/1-install-filesystem.sh` - Install the Filesystem.
- `Chapter_02/2-install-directories.sh` - Install the Limited Directories.
> Can be run from the Live ISO as the file system is writable, but not permanent.

### Installing

* Copy the `repos` into `/mnt/ylfs/ybuild/repos`
* Copy Files from Chapter_03: 
 - `ca-bundle.crt` - Certifications to allow the libcurl module to download archives.
 - `yaml-install.sh` - Simple wrapper script to install single package.
 - `ydatabase.yaml` - The Ybuild database file needed for initialization.
 - `magic.mgc` - Magic runtime file from File-5.47 to allow archive detection.
 - `Ybuild` - The Static Built Binary Builder/Installer.
 - `yaml-get` - Downloader for all Sources and Patches in a yaml file to `$YSRC`
 - `ystrip-static` - Static binary to strip files from image directory.
 - `pkg-install.sh` - Bash wrapper to Ybuild.
> into the `/mnt/ylfs/ybuild` directory

* Copy Files:
- `Chapter_05/install-ch5.sh` wrapper script to install all of chapter 5 cross compiler.
- `Chapter_06/install-ch6.sh` wrapper script to install all of chapter 6 cross compile tools.
- `Chapter_07/Zlfs-chroot.sh` Automated Enter and Exit from the Chroot Environment.
- `Chapter_07/7-5-creating-dirs.sh` Create File System paths.
- `Chapter_07/7-6-create-files_systemd.sh` Create Essential Files and Symlinks
- `Chapter_07/7-7-chapter-install.sh` wrapper to install extra temporary tools.
- `Chapter_08/install-ch8.sh` wrapper script to install all of chapter 8 base system.
- `Chapter_09/repos` Extra Packages for download, certification, ssh and uefi boot.
- `Chapter_09/create-fstab-grub.sh` Takes Drive Letter to create `/etc/fstab` and `/boot/grub/grub.cfg`
- `Chapter_09/install-ch9.sh` wrapper to install all of chapter 9.
- `Chapter_10/` - Kernel Install
> At This Point You can Reboot into your new system.

### Chapter 11
* Some Necessary Packages for Security and Building

### Chapter 12
* Necessary Packages to build Glib2 and Media

### Chapter 13
+ Necessary Packages for Rust and Xorg

### Chapter 14
+ Some Packages for Minimal Desktop

### Chapter 15
+ Packages for XFCE or Qt6

### Chapter 16
+ Package for KDE or GNOME
