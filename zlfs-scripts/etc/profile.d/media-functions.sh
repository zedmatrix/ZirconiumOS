#!/bin/bash
# Begin of /etc/profile.d/MediaFunctions.sh

[ -x /usr/bin/mpv ] || return
Radio() {
    mpv --audio-display=no --loop-playlist --shuffle --playlist="$1"
}

Media() {
    mpv "${@}"
}

SPlay() {
    Media --shuffle --loop-playlist --playlist="$1"
}

ZPlay() {
    Media --playlist="$1"
}

export -f Radio
export -f Media
export -f SPlay
export -f ZPlay

PlayList() {
    if [[ $1 == "r" ]]; then
        find . -type f -regex '.*\.\(mp4\|mkv\)' -printf '%T@ %p\n' | sort -r | cut -d' ' -f2-
    elif [[ $1 == "n" ]]; then
        find . -type f -regex '.*\.\(mp4\|mkv\)' -printf '%T@ %p\n' | sort | cut -d' ' -f2-
    elif [[ $1 == "m" ]]; then
        find . -type f -name '*.mp3'
    else
        echo "Usage: PlayList [r|n] > playlist.m3u"
    fi
}

export -f PlayList

# End of /etc/profile.d/MediaFunctions.sh
