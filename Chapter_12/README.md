## Chapter 12 - Rebuild Yaml-Builder

To rebuild **Ybuild** with full support, several libraries and tools must be installed.

---

### Core Dependencies for Ybuild

- `libtirpc` – Transport Independent RPC library.  
- `libnsl` – Network Services Library (legacy support).  
- `libuv` – Multi-platform support library with async I/O.  
- `cmake` – Cross-platform build system.  
- `yaml-cpp` – C++ YAML parser and emitter.  

---
### Build Support and Documentation Tools

- `gpm` – Console mouse server.  
- `unix-tree` – Tree-style directory listing.  
- `icu` – Unicode and internationalization library.  
- `boost` – C++ utility libraries.  
- `libxml2`, `docbook-xml`, `docbook-xsl-nons`, `libxslt`, `xmlto`, `itstool` – XML/DocBook processing.  
- `asciidoc` – Lightweight markup for docs.  
- `links` – Text/graphical web browser.  
- `build` – A simple, correct Python build frontend.  
- `py-installer` – Freeze Python applications into executables.  
- `rsync` – File synchronization utility.  

---
### Performance and Hardware Tools

- `lm-sensors` – Hardware monitoring tools.  
- `lzo`, `brotli` – Compression libraries.  
- `nettle` – Low-level crypto library.  
- `nasm`, `yasm` – Assemblers.  
- `llvm` – Compiler infrastructure.  
- `cython` – Python to C compiler.  
- `jansson` – JSON library.  
- `libevent` – Event notification library.  

---
### Networking and System Libraries

- `c-ares` – Asynchronous DNS requests.  
- `nghttp2` – HTTP/2 support library.  
- `libnl` – Netlink protocol library.  
- `rpcbind`, `rpcsvc-proto` – RPC service utilities.  
- `net-tools` – Legacy networking tools.  
- `libseccomp` – Secure computing mode filtering.  

---
### Authentication and PAM

- `linux-pam` – Pluggable Authentication Modules.  
- `shadow-pam` – Shadow password utilities with PAM.  
- `systemd-pam` – PAM integration for systemd.  
- `libcap-pam` – Capabilities library with PAM support.  

**Test Linux-PAM Configuration:**  
- Log out and back in to ensure PAM is working.  
- Disable legacy files if present:  
  - `if [ -f /etc/login.access ]; then mv -v /etc/login.access{,.NOUSE}; fi`
  - `if [ -f /etc/limits ]; then mv -v /etc/limits{,.NOUSE}; fi`

> Create User
- `export username=`{Your New Limited Every Day User}
- `useradd -m -G audio,video,wheel ${username}`
- `passwd ${username}`

---
### Final Security and Crypto Stack

- `nspr, nss` – Netscape Portable Runtime & Security Services.
- `libgpg-error, libgcrypt` – Core GnuPG crypto libraries.
- `libssh2` – SSH client library.
- `lmdb` – Lightning Memory-Mapped Database.
- `cyrus-sasl, openldap` – Authentication and LDAP support.
- `sudo` – Privilege escalation tool.
- `gnutls` – SSL/TLS library.
- `duktape` – Embedded JavaScript engine.
- `nfs-utils` – NFS support utilities.
- `npth` – Threading library for GnuPG.
- `libksba, libassuan` – GnuPG support libraries.
- `gnupg, gpgme, gpgmepp` – GnuPG and its developer libraries.
- `docutils, ply, mako` – Python-based build and documentation tools.
- `libyaml, pyyaml` – YAML processing libraries.
- `iso-codes` – ISO country, language, and currency codes.

---

✅ After this stage, Ybuild is fully rebuilt with PAM support, crypto libraries, and documentation tools, ready for extended BLFS use.

