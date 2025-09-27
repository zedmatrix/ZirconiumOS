## Chapter 3 - Base System Packages and Patches

Before building the temporary toolchain, we prepare the **Ybuild environment** inside `$LFS`.<br>
This provides a minimal package manager and database to automate installations during later chapters.

---

### Installing the Ybuild Auto LFS Program
**Prepare the repository**

1. Copy the `repos` directory into: `/mnt/lfs/ybuild/repos`
> Extract the [LFS-r12.4-Stable-Repos](https://ln5.sync.com/dl/9166b41a0#3inpj6jt-8thmtii6-493i2qxx-377jjahy) <br>
> Includes all yaml and source files for complete Systemd or Sys-V

**Prepare the Ybuilder**

2. Copy Files into the `/mnt/lfs/ybuild` directory:

 - `ca-bundle.crt` - Certifications to allow the libcurl module to download inside chroot.
 - `yaml-install.sh` - Simple wrapper script to install single package.
 - `ydatabase.yaml` - The Ybuild database file needed for initialization.
 - `Ybuild` - The Static Built Binary Builder/Installer.
