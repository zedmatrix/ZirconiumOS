## Chapter 12 - rebuild Yaml-Builder

`libtirpc libnsl libuv cmake yaml-cpp`
> rebuild of Ybuild

-

```
gpm unix-tree icu boost libxml2 docbook-xml itstool 
docbook-xsl-nons libxslt xmlto libevent links asciidoc 
build py-installer rsync lm-sensors lzo nettle nasm cython yasm
brotli llvm jansson net-tools libseccomp
c-ares nghttp2 libnl rpcbind rpcsvc-proto
linux-pam shadow-pam systemd-pam libcap-pam
```
---

> Test Linux-PAM Configuration
- By Logging out and logging back in
- Finalize
- `if [ -f /etc/login.access ]; then mv -v /etc/login.access{,.NOUSE}; fi`
- `if [ -f /etc/limits ]; then mv -v /etc/limits{,.NOUSE}; fi`

> Create User
- `export username= {Your New Limited Every Day User}`
- `useradd -m -G audio,video,wheel ${username}`
- `passwd ${username}`

---

### Final Security and Crypto

```
nspr nss libgpg-error libgcrypt libssh2 lmdb
cyrus-sasl openldap sudo gnutls duktape
nfs-utils npth libksba libassuan gnupg gpgme gpgmepp
docutils ply mako libyaml pyyaml iso-codes
```
