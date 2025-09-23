## Base System Packages and Patches

### Installing
* Copy the `repos` into `/mnt/lfs/ybuild/repos`
* Copy Files:
* `ca-bundle.crt` - Certifications to allow the libcurl module to download inside chroot.
* `yaml-install.sh` - Simple wrapper script to install single package.
* `ydatabase.yaml` - The Ybuild database file needed for initialization.
* `Ybuild` - The Static Built Binary Builder/Installer.
> into the `/mnt/lfs/ybuild` directory
