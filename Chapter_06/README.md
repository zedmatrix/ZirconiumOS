## Chapter 6 - Cross Compiling Temporary Tools

### Temporary Toolchain Programs

1. `m4-{version}-tmp` – Macro processing language used by autoconf.
2. `ncurses-{version}-tmp` – Terminal handling library for text user interfaces.
3. `bash-{version}-tmp` – The GNU Bourne Again SHell.
4. `coreutils-{version}-tmp` – Essential file, shell, and text utilities.
5. `diffutils-{version}-tmp` – Tools to compare files and directories.
6. `file-{version}-tmp` – Determines file type based on content.
7. `findutils-{version}-tmp` – Searching and locating files.
8. `gawk-{version}-tmp` – Text processing language (GNU awk).
9. `grep-{version}-tmp` – Pattern matching and searching text.
10. `gzip-{version}-tmp` – Compression and decompression utility.
11. `make-{version}-tmp` – Tool to control the build process.
12. `patch-{version}-tmp` – Apply diffs to files.
13. `sed-{version}-tmp` – Stream editor for text transformations.
14. `tar-{version}-tmp` – Archiving utility for tape and file collections.
15. `xz-{version}-tmp` – Compression using the LZMA2 algorithm.
16. `nano-{version}-tmp` - An Editor to modify the yaml files in chroot.
> These form the basic compiler tools required for the next stage.

---

### Rebuilding the Compiler (Pass 2)

16. `binutils-{version}-p2` – Assembler, linker, and binary utilities.
17. `gcc-{version}-p2` – GNU Compiler Collection (C/C++ compiler).

> At this stage we finally build pass 2 of the compiler, replacing the cross-tools.
