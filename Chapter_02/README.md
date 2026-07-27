## Prepare Zirconium Linux From Scratch

`ylfs-environment.sh`<br>
> Source before initializing disks

---
`ybase_header.sh`<br>
> Functions used during the initialization and building
---

`1-install-filesystem.sh`<br>
> Takes Options
* Drive Letter (example: sda)
* uefi - enable 3 partition basic creation
* force - enable force formatting and creation
---

`2-install-directories.sh`<br>
> Takes Options
* Drive Letter (example: sda)
