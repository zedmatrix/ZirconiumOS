## Chapter 5 - Compiling a Cross-Toolchain

1. `binutils-temp1` – Provides the assembler, linker, and essential binary utilities.
2. `gcc-temp1` – GNU Compiler Collection, initial C/C++ cross-compiler.
3. `linux-headers` – Exposes the Linux API headers for use by Glibc.
4. `glibc-temp1` – The GNU C Library, core runtime libraries for programs.
   > Can be replaced with `musl` with additional patching.
5. `libstdc++` – Standard C++ library (part of GCC, needed since GCC itself uses C++).
