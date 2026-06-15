#!/usr/bin/env bash
set -euo pipefail

HOST=${1:?usage: burn-iso.sh <hostname> <device>}
DEVICE=${2:?usage: burn-iso.sh <hostname> <device>}

echo "===> Building ISO for ${HOST}"
nix build .#nixosConfigurations.iso-${HOST}.config.system.build.isoImage

ISO=$(readlink -f result/iso/*.iso)

echo "===> Writing ${ISO} to ${DEVICE}"
echo "     THIS WILL DESTROY ALL DATA ON ${DEVICE}"
read -rp "     Are you sure? [y/N] " confirm
[[ $confirm == [yY] ]] || exit 1

sudo dd if="$ISO" of="$DEVICE" bs=4M status=progress oflag=sync

echo "===> Done"
