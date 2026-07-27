#!/bin/bash

# Using Ybuild ISO cd /ybuild/prepare
# Source ylfs-environment.sh First
[ -z $YLFS_ENVIRONMENT ] && { echo "Source the YLFS Environment"; exit 1; }
source ${PWD}/ybase_header.sh || { echo "Can Not Base Header"; exit 1; }

# Start Of Program
zstars
DRIVE=""
let UEFI=0
let FORCE=0

while (( "$#" )); do
   case $1 in
      sd[a-z]|vd[a-z]|hd[a-z]|nvme[0-9]n[0-9])
        DRIVE="/dev/${1}"
        [ -b $DRIVE ] || bad_drive
        ;;
      uefi)
        UEFI=1
        ;;
      force)
        FORCE=1
        ;;

      [?])
        echo "Usage: $0 [sda | vda | hda | nvme ] [uefi] [force]" >&2
        exit 1 ;;
    esac
    shift
done

[ -b $DRIVE ] && zprint "Format Options: DRIVE: $DRIVE " || bad_drive
[ $UEFI -eq 1 ] && zprint "Using UEFI Setup" || zerror "Using MBR Setup"
[ $FORCE -eq 1 ] && zerror "Overwite Enabled" || zprint "Overwite Disabled"

zprint "Partition Formatting Layout Creation"
ROOTPATH="/usr/sbin"
PATH=${ROOTPATH}:${PATH}

# Check if drive exists
if [[ ! -b "$DRIVE" ]]; then
    echo "Error: $DRIVE is not a block device."
    exit 1
fi

# If drive is nvme there add a p and force uefi
nvme=""
if [[ $DRIVE =~ 'nvme' ]]; then
    nvme=p
    UEFI=1
fi

# Check if drive is partitioned
if [[ $UEFI -eq 1 ]]; then
    x=3
    pt="gpt"
else
    x=2
    pt="dos"
fi

not_created=0
pttype=$(lsblk -dn -o PTTYPE "$DRIVE" | head -1)

if [[ "$pttype" != "$pt" ]]; then
    zprint "Not Partitioned - Creating new $pt table"
    not_created=1
fi

# Detect partitions
for i in $(seq 1 $x); do
    part="${DRIVE}${nvme}${i}"
    if [[ ! -b "$part" ]]; then
        zprint "Missing $part"
        not_created=2
        continue
    fi

    parttype=$(lsblk -no FSTYPE "$part" | head -1)
    if [[ -z "$parttype" ]]; then
        zprint "Partition $part has no filesystem type yet."
    else
        zprint "Partition $part: $parttype"
    fi
done

# Partition layout definitions
GPT_UEFI="label: gpt
size=512M, type=U
size=2G, type=S
type=L"

MBR_DOS="label: dos
size=2G, type=S
type=L"

# Create partitions if needed
if [[ $not_created -ge 1 ]]; then
    if [[ $UEFI -eq 1 ]]; then
        zprint "Creating GPT partition table with EFI, swap, and root"
        sfdisk "$DRIVE" <<< "$GPT_UEFI"
    else
        zprint "Creating DOS partition table with swap and root"
        sfdisk "$DRIVE" <<< "$MBR_DOS"
    fi
else
    # Double-check partition filesystems
    for i in $(seq 1 $x); do
        part="${DRIVE}${nvme}${i}"
        parttype=$(lsblk -no FSTYPE "$part" | head -1)
        if [[ -z "$parttype" ]]; then
            zerror "Partition $part has no filesystem type yet. Unexpected Error."
            exit 1
        else
            zprint "Partition $part: $parttype"
        fi
    done
fi
# Wait for sync()
zprint "Waiting For Sync() ... Sleeping 5 seconds"
sleep 5

# Formatting and Checking Again
pttype=$(lsblk -n -o PTTYPE "$DRIVE" | head -1)
zprint "Drive: ${DRIVE} Partition Table Type: ${pttype}"

# Determine partition count (UEFI has EFI+SWAP+ROOT)
parts=2
[[ "$pttype" == "gpt" ]] && parts=3

for i in $(seq 1 $parts); do
    part="${DRIVE}${nvme}${i}"

    if [[ -b "$part" ]]; then
        FSTYPE=$(lsblk -n -o FSTYPE "$part" | head -1)

        if [[ -z "$FSTYPE" || "$FORCE" -eq 1 ]]; then
            zprint "$part is unformatted or FORCE enabled"

            case $i in
                1)
                    if [[ "$pttype" == "gpt" ]]; then
                        zprint "Formatting EFI System Partition as FAT32"
                        mkfs.vfat -F32 -v "$part"
                    else
                        zprint "Preparing swap (DOS) partition"
                        mkswap "$part"
                    fi
                    ;;
                2)
                    if [[ "$pttype" == "gpt" ]]; then
                        zprint "Preparing swap (EFI) partition"
                        mkswap "$part"
                    else
                        print_out "Formatting root (DOS) partition as ext4"
                        mkfs.ext4 -v "$part"
                    fi
                    ;;
                3)
                    print_out "Formatting root (EFI) partition as ext4"
                    mkfs.ext4 -v "$part"
                    ;;
            esac
        else
            zprint "$part already formatted as $FSTYPE"
        fi
    else
        zprint "Partition $part not found"
    fi
done

zprint "Done"
