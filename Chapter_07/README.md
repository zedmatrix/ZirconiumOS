## Chapter 7 - Entering Chroot and Building Additional Temporary Tools (Systemd)

+ `Zlfs-chroot.sh` - Automated Enter and Exit of Chroot Environment
+ `7-5-creating-dirs.sh` - Creating Directories
+ `7-6-create-files_systemd.sh` - Creating Essential Files and Symlinks
+ `7-7-chapter-install.sh` - Installation of Tools<br>
> `gettext-temp bison-temp perl-temp python-temp texinfo-temp util-linux-temp`<br>
+ `7-z-cleanup.sh` - Automated Cleanup

### Saving the Temporary System

1. `exit` from the chroot environment
2. `cd $LFS`
3. `tar -cJpf $HOME/lfs-temp-tools-r12.4-16-systemd-wip.tar.xz .`
> You can change the $HOME to a USB or other location also saves the sources.

### Restore the System from the Backup
1. `export LFS=/mnt/lfs` - Make sure this is set
2. `cd $LFS` - change to your prepared drive for `$LFS`
3. `rm -rf ./*` - Remove old installation inside of `$LFS`
4. `tar -xpf $HOME/lfs-temp-tools-r12.4-16-systemd-wip.tar.xz`
> $HOME or Where ever you saved your cross tools to.
