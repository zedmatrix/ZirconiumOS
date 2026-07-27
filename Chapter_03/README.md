## Chapter 3 - Base System Packages and Patches

Before building the temporary toolchain, we prepare the **Ybuild environment** inside `$YLFS`.<br>
This provides a minimal package manager and database to automate installations during later chapters.

---

### Installing the Ybuild Auto LFS Program
**Prepare the repository**

1. Copy the `repos` directory into: `/mnt/yfs/ybuild/repos`
> [Latest Zirconium Live ISO](https://ln5.sync.com/dl/671e3b6d0#98prd74m-2j7j3g67-ns5rnmpb-ig8rzvgj) <br>
> Includes Build Tools and Yaml Files for Latest

**Prepare the Ybuilder**

2. Copy Files from `/ybuild` into the `/mnt/ylfs/ybuild` directory:

 - `ca-bundle.crt` - Certifications to allow the libcurl module to download archives.
 - `yaml-install.sh` - Simple wrapper script to install single package.
 - `ydatabase.yaml` - The Ybuild database file needed for initialization.
 - `magic.mgc` - Magic runtime file from File-5.47 to allow archive detection.
 - `Ybuild` - The Static Built Binary Builder/Installer.
 - `yaml-get` - Downloader for all Sources and Patches in a yaml file to `$YSRC`
 - `ystrip-static` - Static binary to strip files from image directory.
 - `pkg-install.sh` - Bash wrapper to Ybuild.
