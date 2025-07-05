#!/bin/bash
zmsg() { printf "*** %s\n" "$@"; }
cat > /etc/profile.d/zbuild-environment.sh << "EOF"
#!bin/bash
# Begin of /etc/profile.d/zbuild-environment.sh
zzred="${zzred:-\033[1;31m}"
zzgreen="${zzgreen:-\033[1;32m}"
zzyellow="${zzyellow:-\033[1;33m}"
zzreset="${zzreset:-\033[0m}"

ZBUILD="/zbuild"
SOURCES="/sources"

zprint() { printf "${zzyellow} *** %s *** ${zzreset} \n" "${@}"; }

export zzred zzgreen zzyellow zzreset SOURCES
export -f zprint
export CFLAGS="-Os -pipe"
export CXXFLAGS="$CFLAGS"

export MAKEFLAGS=-j$(nproc)

# End of /etc/profile.d/zbuild-environment.sh
EOF
[ -f "/etc/profile.d/zbuild-environment.sh" ] && zmsg " Created: /etc/profile.d/zbuild-environment.sh"

cat > /lib/lsb/init-functions.sh << "EOF"
#!/bin/bash
# Begin /lib/lsb/init-functions.sh
DISTRO=${DISTRO:-"ZirconiumOS"}
DISTRO_CONTACT=${DISTRO_CONTACT:-"zedmatrix@libera.chat"}
DISTRO_MINI=${DISTRO_MINI:-"ZLFS_OS"}

ZNORM="\\033[0;39m"        # Standard console grey
ZPASS="\\033[1;32m"        # Success is green
ZWARN="\\033[1;33m"        # Warnings are yellow
ZFAIL="\\033[1;31m"        # Failures are red
ZINFO="\\033[1;36m"        # Information is light cyan
BRACKET="\\033[1;34m"      # Brackets are blue

# Use a colored prefix
BMPREFIX="      "
PASS_PREFIX="${ZPASS}  *  ${ZNORM}"
FAIL_PREFIX="${ZFAIL}*****${ZNORM}"
WARN_PREFIX="${ZWARN} *** ${ZNORM}"
SKIP_PREFIX="${INFO}  S   ${ZNORM}"

PASS_SUFFIX="${BRACKET}[${ZPASS} PASS ${BRACKET}]${ZNORM}"
FAIL_SUFFIX="${BRACKET}[${ZFAIL} FAIL ${BRACKET}]${ZNORM}"
WARN_SUFFIX="${BRACKET}[${ZWARN} WARN ${BRACKET}]${ZNORM}"
SKIP_SUFFIX="${BRACKET}[${ZINFO} SKIP ${BRACKET}]${ZNORM}"

# POSIX friendly
MAX_SIZE=$(stty size)
MAX_ROWS=${MAX_SIZE%% *}
MAX_COLS=${MAX_SIZE##* }

if [ ${MAX_COLS} = "0" ]; then
    MAX_COLS=80
fi

## Measurements for positioning result messages
LEFT_COL=$((${MAX_COLS} - 8))
RIGHT_COL=$((${LEFT_COL} - 2))

## Set Cursor Position Commands, used via echo
SET_LEFT="\\033[${LEFT_COL}G"      # at the $LEFT_COL char
SET_RIGHT="\\033[${RIGHT_COL}G"    # at the $RIGHT_COL char
CURS_UP="\\033[1A\\033[0G"         # Up one line, at the 0'th char
CURS_ZERO="\\033[0G"

message_pass() {
    echo -n -e "${BMPREFIX}${@}"
    echo -e "${CURS_ZERO}${PASS_PREFIX}${SET_LEFT}${PASS_SUFFIX}"
}
message_fail() {
    echo -n -e "${BMPREFIX}${@}"
    echo -e "${CURS_ZERO}${FAIL_PREFIX}${SET_LEFT}${FAIL_SUFFIX}"
}
message_warn() {
    echo -n -e "${BMPREFIX}${@}"
    echo -e "${CURS_ZERO}${WARN_PREFIX}${SET_LEFT}${WARN_SUFFIX}"
}
message_skip() {
    echo -n -e "${BMPREFIX}${@}"
    echo -e "${CURS_ZERO}${SKIP_PREFIX}${SET_LEFT}${SKIP_SUFFIX}"
}

# End of /lib/lsb/init-functions.sh
EOF
[ -f "/lib/lsb/init-functions.sh" ] && zmsg " Created: /lib/lsb/init-functions.sh"
