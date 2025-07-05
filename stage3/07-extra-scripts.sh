#!/bin/bash
zmsg() { printf "*** %s\n" "$@"; }

cat > /etc/profile.d/CurlPaste.sh << "EOF"
#!/bin/bash
# Begin of /etc/profile.d/CurlPaste.sh
[ -x /usr/bin/curl ] || return
CurlPaste() {
    local file=$1
    if [[ -z $file ]]; then
        printf "Error: Usage: $0 [file] \n"
        return 1
    fi

    if [[ -f $file ]]; then
        printf "\n\t Uploading ${file} to 0x0 \n"
        curl -F'file=@-' https://0x0.st < "${file}"
    else
        printf "\n\t Warning: File does not exist. \n"
        return 1
    fi
}
export -f CurlPaste

# End of /etc/profile.d/CurlPaste.sh
EOF
[ -f "/etc/profile.d/CurlPaste.sh" ] && zmsg " Created: /etc/profile.d/CurlPaste.sh"

cat > /etc/profile.d/MediaFunctions.sh << "EOF"
#!/bin/bash
# Begin of /etc/profile.d/MediaFunctions.sh
[ -x /usr/bin/mpv ] || return
Radio() {
    mpv --geometry=320x200+1280+60 --loop-playlist --shuffle --playlist="$1"
}

alias MPV='mpv --geometry=1280x720+1280+60'
Media() {
    MPV --profile=fast --hwdec=auto-safe --loop-playlist --playlist="$1"
}
SPlay() {
    MPV --profile=fast --hwdec=auto-safe --shuffle --loop-playlist --playlist="$1"
}
ZPlay() {
    MPV --profile=fast --hwdec=auto-safe "$1"
}

export -f Radio
export -f Media
export -f SPlay
export -f ZPlay

PlayList() {
    if [[ $1 == "r" ]]; then
        find . -name "*.mp4" -type f -printf '%T@ %p\n' | sort -r | cut -d' ' -f2-
    elif [[ $1 == "n" ]]; then
        find . -name "*.mp4" -type f -printf '%T@ %p\n' | sort | cut -d' ' -f2-
    else
        echo "Usage: PlayList [r|n] > playlist.m3u"
    fi
}

Shuffle() {
    if [[ -z $1 ]]; then
        echo "#EXTM3U"
        find . -name "*.mp4" -type f | shuf -n 10
    elif [[ $1 =~ ^[0-9]+$ ]]; then
        echo "#EXTM3U"
        find . -name "*.mp4" -type f | shuf -n "$1"
    else
        echo "Usage: Shuffle [number] > playlist.m3u"
    fi
}

export -f PlayList
export -f Shuffle

# End of /etc/profile.d/MediaFunctions.sh
EOF
[ -f "/etc/profile.d/MediaFunctions.sh" ] && zmsg " Created: /etc/profile.d/MediaFunctions.sh"

cat > /etc/profile.d/SourceGet.sh << "EOF"
#!/bin/bash
# Begin of /etc/profile.d/SourceGet.sh
[ -x /usr/bin/wget ] || return
SourceGet() {
    [ -z "${SOURCES}" ] && { echo "Missing \$SOURCES variable exiting."; exit 1; }
    if [[ -z $1 ]]; then
        printf "\n %s \n" "Usage: $0 [url/file]"
        return 1
    fi

    local url=$1
    wget "$url" --no-clobber -P "${SOURCES}"
}
export -f SourceGet

# End of /etc/profile.d/SourceGet.sh
EOF
[ -f "/etc/profile.d/SourceGet.sh" ] && zmsg " Created: /etc/profile.d/SourceGet.sh"
