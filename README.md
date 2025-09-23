## Zirconium OS - systemd

- `Chapter_02/1-install-filesystem.sh` 
- `Chapter_02/2-install-directories.sh`
> Should be run from a usb drive or from the host build tools.<br>
> If Preparing NEW, Use the live iso and copy this repo to a usb stick.

### Installing

* Copy the `repos` into `/mnt/lfs/ybuild/repos`
* Copy Files from Chapter_03: 
* `ca-bundle.crt` - Certifications to allow the libcurl module to download inside chroot.
* `yaml-install.sh` - Simple wrapper script to install single package.
* `ydatabase.yaml` - The Ybuild database file needed for initialization.
* `Ybuild` - The Static Built Binary Builder/Installer.
> into the `/mnt/lfs/ybuild` directory

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
> the y*.sh script files should be placed with the install_ch9.
- `Chapter_11/repos` git, sound open firmware, linux firmware and intel microcode creation.
- `Chapter_11/11-z-the-end.sh` Final release files.
> At This Point You can Reboot into your new system.

### Chapter 12
* Some Necessary Packages for Security and Building

### Chapter 13
* Necessary Packages to build Xorg
