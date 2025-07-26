# ZirconiumOS - Linux From Scratch

ZirconiumOS is part of the new zbuild c++ system builder<br>

## Installation - Scripts to Fully Automate and Build Linux From Scratch
1. Download [Linux From Scratch Multilib GCC-15.1.0 Kernel 6.14.4](https://ln5.sync.com/4.0/dl/f4528c4e0#69s9bi4d-rdsn3g4m-prazjz32-9drdeqqu)
2. Download [Zirconium-1.01](zirconium-1.01.tar.xz) the installer scripts
3. Requires Partition Layout
4. Extract to `/home` files `1-mount-create-directories.sh` and `check_fs.sh` Format and Initialize DRIVE=`/dev/sda`
5. `cd stage0` and `source 2-get-packages.sh` and `source 3-get-stage2-packages.sh` to get all packages
6. Extract or Copy `zirconium-1.01.tar.xz` to `/mnt/lfs/zbuild` aka `$LFS/zbuild` aka `$ZBUILD`
   ```
   LFS=${LFS:-/mnt/lfs}
   ZSRC=${ZSRC:-$LFS/sources}
   ZBUILD=${ZBUILD:-$LFS/zbuild}
   ```
7. `cd $ZBUILD && ./build-stage.sh 1`
8. `stage0/Zlfs-chroot.sh`
9. `./build-stage.sh 2`
10. This You can exit and save the temporary tool set or proceed
11. `./build-stage.sh 3`
12. `./build-stage.sh 4`
13. `./build-stage.sh 5`
14. `./build-stage.sh 6`
15. Verify `/etc/fstab` and `/boot/grub/grub.cfg`

# Beyond Linux From Scratch
> stage4 scripts to install Xorg
> ```
> git clone --filter=blob:none --sparse https://github.com/zedmatrix/ZirconiumOS.git
> cd ZirconiumOS
> git sparse-checkout set --cone stage4
> ```
 
## Initialization - Create Your Partition Layout<br>
>`stage0/check_fs.sh` Simple Formatter with Simple Layout<br>
>DOS Partition Layout
>```
>SWAP="${DRIVE}1"
>ROOT="${DRIVE}2"
>```
>GPT Partition Layout
>```
>UEFI="${DRIVE}1"
>SWAP="${DRIVE}2"
>ROOT="${DRIVE}3"
>```

## LFS Books the Scripts were generated from:
>[LFS Book r12.3-71-systemd](lfs-r12.3-71.tar.xz)<br>
>[BLFS Book r12.3-937-systemd](blfs-r12.3-937.tar.xz)<br>

## Zbuilder Program
> Written in C++ with the ability to static link and download packages.<br>
> Optional Package Archive<br>
> Package handles .zip files<br>
