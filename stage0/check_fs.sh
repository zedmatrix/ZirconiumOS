#!/bin/bash

printf "\n\t Partition Formatting Default Layout Creation \n"

DRIVE=${DRIVE:-/dev/sda}

# Check if drive exists
if [[ ! -b "$DRIVE" ]]; then
    echo "Error: $DRIVE is not a block device."
    exit 1
fi

# Check if drive is partitioned
pttype=$(lsblk -n -o PTTYPE $DRIVE | head -1)
printf "\n\t Drive: %s Partition Type: %s \n" $DRIVE $pttype

if [[ $pttype == "dos" ]]; then
    SWAP="${DRIVE}1"
    ROOT="${DRIVE}2"
    printf "\n\t Assuming (SWAP:%s) (ROOT:%s) \n" $SWAP $ROOT
else
    UEFI="${DRIVE}1"
    SWAP="${DRIVE}2"
    ROOT="${DRIVE}3"
    printf "\n\t Assuming (UEFI:%s) (SWAP:%s) (ROOT:%s) \n" $UEFI $SWAP $ROOT
fi
#
# Check formatted && Collect partitions
#
PARTS=()
[[ -n "$UEFI" ]] && PARTS+=("$UEFI")
[[ -n "$SWAP" ]] && PARTS+=("$SWAP")
[[ -n "$ROOT" ]] && PARTS+=("$ROOT")

# Check for formatting
for part in "${PARTS[@]}"; do
    if [[ -b "$part" ]]; then
        FSTYPE=$(lsblk -n -o FSTYPE "$part" | head -n 1)
        if [[ -z "$FSTYPE" ]]; then
            echo "$part is unformatted"

            # Format depending on purpose
            case "$part" in
                "$UEFI") mkfs.vfat -v -F32 "$UEFI" ;;
                "$SWAP") mkswap "$SWAP" ;;
                "$ROOT") mkfs.ext4 -v "$ROOT" ;;
            esac
        else
            echo "$part already formatted as $FSTYPE"
        fi
    fi
done

[[ -n "$UEFI" ]] && export UEFI
[[ -n "$SWAP" ]] && export SWAP
[[ -n "$ROOT" ]] && export ROOT
