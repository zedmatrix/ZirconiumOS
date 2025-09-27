## Chapter 9 - Essential Scripts

These scripts finalize the base system by setting up environment paths, networking, locales, and user defaults.  

### Core Scripts

| Script                 | Purpose                                                                 |
|-------------------------|-------------------------------------------------------------------------|
| `ybuild-environment.sh` | Defines path functions and allows pasting logs to [0x0.st](https://0x0.st). |
| `ynetwork-files.sh`     | Configures **systemd-networkd** and **systemd-resolved**.              |
| `yclock-locale.sh`      | Sets system clock, timezone, and locale.                               |
| `ysystem-config.sh`     | Installs initial shell configuration files.                           |
| `ybash-startup.sh`      | Enables Bash completion and directory colors.                         |
| `yskel-files.sh`        | Creates user skeleton files for new accounts.                         |

---

### Essential Tools

These utilities are required for networking, crypto, compression, and hardware support:  

 1. `which` – Locate executables in PATH.  
 2. `libarchive`, `libtasn1`, `p11-kit`, `make-ca` – Crypto and certificate handling.  
 3. `openssh` – Secure remote access via SSH.  
 4. `libunistring`, `libidn2`, `libpsl`, `wget`, `curl` – String handling and network downloads.  
 5. `hwdata`, `pciutils`, `libusb`, `usbutils` – Hardware identification and USB/PnP utilities.  

---

### GRUB UEFI Booting

Required libraries and tools to support EFI booting:  

 6. `popt`, `libpng`, `libaio` – Libraries needed by GRUB and related tools.  
 7. `dosfstools` – FAT filesystem utilities (for EFI partitions).  
 8. `lvm2` – Logical Volume Management support.  
 9. `fuse` – Filesystem in Userspace support.  
 10. `freetype2-pass1` – Font rendering library (needed for GRUB menus).  
 11. `efivar`, `efibootmgr` – Manage EFI variables and boot entries.  
 12. `grub-uefi` – The GRUB bootloader built for UEFI systems.  

---

> ✅ At this stage, the base system is configured, essential tools are installed, and the bootloader is ready to be set up for UEFI booting.
