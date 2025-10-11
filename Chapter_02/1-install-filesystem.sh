#!/bin/bash

stars_sep() { echo -e "\033[1;36m $(printf '%.0s*' {1..100}) \033[0m"; }
print_out() { echo -e "\033[1;33m *** ${*} *** \033[0m"; }
bad_drive() {
    echo "Invalid Drive Options. Exiting."
    exit 666
}
# Start Of Program
stars_sep
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


[ -b $DRIVE ] && echo "Format Options: DRIVE: $DRIVE " || bad_drive
[ $UEFI -eq 1 ] && echo "Using UEFI Setup" || echo "Using MBR Setup"
[ $FORCE -eq 1 ] && echo "Overwite Enabled" || echo "Overwite Disabled"

print_out "Partition Formatting Layout Creation"
ROOTPATH="/usr/sbin"
PATH=${ROOTPATH}:${PATH}

# Check if drive exists
if [[ ! -b "$DRIVE" ]]; then
    echo "Error: $DRIVE is not a block device."
    exit 1
fi

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
    print_out "Not Partitioned - Creating new $pt table"
    not_created=1
fi

# Detect partitions
for i in $(seq 1 $x); do
    part="${DRIVE}${nvme}${i}"
    if [[ ! -b "$part" ]]; then
        print_out "Missing $part"
        not_created=2
        continue
    fi

    parttype=$(lsblk -no FSTYPE "$part" | head -1)
    if [[ -z "$parttype" ]]; then
        print_out "Partition $part has no filesystem type yet."
    else
        print_out "Partition $part: $parttype"
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
        print_out "Creating GPT partition table with EFI, swap, and root"
        sfdisk "$DRIVE" <<< "$GPT_UEFI"
    else
        print_out "Creating DOS partition table with swap and root"
        sfdisk "$DRIVE" <<< "$MBR_DOS"
    fi
else
    # Double-check partition filesystems
    for i in $(seq 1 $x); do
        part="${DRIVE}${nvme}${i}"
        parttype=$(lsblk -no FSTYPE "$part" | head -1)
        if [[ -z "$parttype" ]]; then
            print_out "Partition $part has no filesystem type yet. Unexpected Error."
            exit 1
        else
            print_out "Partition $part: $parttype"
        fi
    done
fi

# Formatting and Checking Again
pttype=$(lsblk -n -o PTTYPE "$DRIVE" | head -1)
print_out "Drive: ${DRIVE} Partition Table Type: ${pttype}"

# Determine partition count (UEFI has EFI+SWAP+ROOT)
parts=2
[[ "$pttype" == "gpt" ]] && parts=3

for i in $(seq 1 $parts); do
    part="${DRIVE}${nvme}${i}"

    if [[ -b "$part" ]]; then
        FSTYPE=$(lsblk -n -o FSTYPE "$part" | head -1)

        if [[ -z "$FSTYPE" || "$FORCE" -eq 1 ]]; then
            print_out "$part is unformatted or FORCE enabled"

            case $i in
                1)
                    if [[ "$pttype" == "gpt" ]]; then
                        print_out "Formatting EFI System Partition as FAT32"
                        mkfs.vfat -F32 -v "$part"
                    else
                        print_out "Formatting swap (DOS type)"
                        mkswap "$part"
                    fi
                    ;;
                2)
                    if [[ "$pttype" == "gpt" ]]; then
                        print_out "Formatting swap partition"
                        mkswap "$part"
                    else
                        print_out "Formatting root partition as ext4"
                        mkfs.ext4 -v "$part"
                    fi
                    ;;
                3)
                    print_out "Formatting root partition as ext4"
                    mkfs.ext4 -v "$part"
                    ;;
            esac
        else
            print_out "$part already formatted as $FSTYPE"
        fi
    else
        print_out "Partition $part not found"
    fi
done
