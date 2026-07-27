## Chapter 7 - Entering Chroot and Building Additional Temporary Tools (Systemd)

+ `Zlfs-chroot.sh` - Automated Enter and Exit of Chroot Environment
+ `7-5-creating-dirs.sh` - Creating Directories
+ `7-6-create-files_systemd.sh` - Creating Essential Files and Symlinks
+ `7-6-create-files_sysv-and-systemd.sh` same as above but has sysv option.
+ `7-7-chapter-install.sh` - Installation of Tools<br>

1. `gettext-{version}-tmp` – Internationalization and localization utilities.
2. `bison-{version}-tmp` – Parser generator (yacc replacement).
3. `perl-{version}-tmp` – Practical Extraction and Reporting Language.
4. `python-{version}-tmp` – General-purpose interpreted programming language.
5. `texinfo-{version}-tmp` – Documentation system for GNU packages.
6. `util-linux-{version}-tmp` – Essential utilities for Linux system management. 

+ `7-z-cleanup.sh` - Automated Cleanup

---

### Saving the Temporary System

1. `exit` from the chroot environment
2. `cd $LFS`
3. `tar -cJpf $HOME/lfs-temp-tools-r13-dev-systemd.tar.xz .`
> You can change the $HOME to a USB or other location also saves the sources.

---

### Restore the System from the Backup
1. `export YLFS=/mnt/ylfs` - Make sure this is set
2. `cd $YLFS` - change to your prepared drive for `$YLFS`
3. `rm -rf ./*` - Remove old installation inside of `$YLFS`
4. `tar -xpf $HOME/lfs-temp-tools-r13-dev-systemd.tar.xz`
> $HOME or Where ever you saved your cross tools to.
