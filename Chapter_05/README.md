## Chapter 5 - Compiling a Cross-Toolchain

1. `binutils-{version}-p1` – Provides the assembler, linker, and essential binary utilities.
2. `gcc-{version}-p1` – GNU Compiler Collection, initial C/C++ cross-compiler.
3. `linux-{version}-headers` – Exposes the Linux API headers for use by Glibc.
4. `glibc-{version}-tmp1` – The GNU C Library, core runtime libraries for programs.
   - `musl-{version}-tmp`  A few extra packages and patches.
5. `libstdcpp-{version}` – Standard C++ library (part of GCC, needed since GCC itself uses C++).
