## Chapter 6 - Cross Compiling Temporary Tools

### Temporary Toolchain Programs

1. `m4-temp` – Macro processing language used by autoconf.  
2. `ncurses-temp` – Terminal handling library for text user interfaces.  
3. `bash-temp` – The GNU Bourne Again SHell.  
4. `coreutils-temp` – Essential file, shell, and text utilities.  
5. `diffutils-temp` – Tools to compare files and directories.  
6. `file-temp` – Determines file type based on content.  
7. `findutils-temp` – Searching and locating files.  
8. `gawk-temp` – Text processing language (GNU awk).  
9. `grep-temp` – Pattern matching and searching text.  
10. `gzip-temp` – Compression and decompression utility.  
11. `make-temp` – Tool to control the build process.  
12. `patch-temp` – Apply diffs to files.  
13. `sed-temp` – Stream editor for text transformations.  
14. `tar-temp` – Archiving utility for tape and file collections.  
15. `xz-temp` – Compression using the LZMA2 algorithm.  

> These form the basic compiler tools required for the next stage.

---

### Rebuilding the Compiler (Pass 2)

16. `binutils-temp2` – Assembler, linker, and binary utilities.  
17. `gcc-temp2` – GNU Compiler Collection (C/C++ compiler).  

> At this stage we finally build pass 2 of the compiler, replacing the cross-tools.
