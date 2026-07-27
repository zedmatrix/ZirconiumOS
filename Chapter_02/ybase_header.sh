#!/bin/bash
if [[ -z $YBASE_HEADER ]]; then
    echo "Sourcing Ybase Header"
    export YBASE_HEADER=1
fi

zzreset="\033[0m"
zzred="\033[1;31m"
zzgreen="\033[1;32m"
zzyellow="\033[1;33m"
zzblue="\033[1;34m"
zzpurple="\033[1;35m"
zzcyan="\033[1;36m"
zzwhite="\033[1;37m"

rows="$(stty size | cut -d ' ' -f 1)"
cols=$(expr "$(stty size | cut -d ' ' -f 2)" - 2)

zprint() { echo -e "${zzwhite} *** $* *** ${zzreset}"; }
zmsg() { echo -e "${zzcyan} *** $* *** ${zzreset}"; }

zerror() { echo -e "${zzred} *** $* *** ${zzreset}"; }
zzok() { echo -e "${zzgreen} *** $* *** ${zzreset}"; }

zstars() { echo -e "${zzblue} $(eval printf "%${cols}s" | tr ' ' '*') ${zzreset}"; }
bad_drive() { echo "Invalid Drive Options. Exiting."; exit 127; }

print_formatted_duration() {
    local duration=$1
    local color=$2
    local hour=$(printf '%02d' $((duration / 3600)))
    local mins=$(printf '%02d' $(((duration % 3600) / 60)))
    local secs=$(printf '%02d' $((duration % 60)))
    if [[ -z $color ]]; then
		zprint "${hour} Hours, ${mins} Minutes and ${secs} Seconds"
	else
		zerror "${hour} Hours, ${mins} Minutes and ${secs} Seconds"
	fi
}

# Simple Wait Before Executing Function of 5 seconds or whatever is passed
zbuild_wait() {
    local wait=${1:-2}
    zmsg "Waiting $wait seconds or Press [SPACE] to continue..."
    read -t $wait -n 1 key
    if [[ $key == " " ]]; then
        zmsg "Skipped wait."
    else
        zzok "Continuing..."
    fi
}

zprint "Rows: ${rows}"
zprint "Cols: ${cols}"
zstars
