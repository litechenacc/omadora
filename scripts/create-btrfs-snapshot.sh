#!/usr/bin/env bash
# Create read-only snapshots outside the mounted root/home subvolumes.
# Run interactively: ~/wts/omadora/scripts/create-btrfs-snapshot.sh
set -euo pipefail

project="$HOME/wts/omadora"
stamp=$(date +%Y%m%d-%H%M%S)
root_source=$(findmnt -no SOURCE /)
home_source=$(findmnt -no SOURCE /home)

[[ $root_source == *'['*']' ]] || { echo 'Root is not a Btrfs subvolume source.' >&2; exit 1; }
[[ $home_source == *'['*']' ]] || { echo 'Home is not a Btrfs subvolume source.' >&2; exit 1; }

root_device=${root_source%%\[*}
home_device=${home_source%%\[*}
root_subvol=${root_source#*[}; root_subvol=${root_subvol%]}
home_subvol=${home_source#*[}; home_subvol=${home_subvol%]}

[[ $root_device == "$home_device" ]] || { echo 'Root and home are on different Btrfs devices; this script intentionally stops.' >&2; exit 1; }

mountpoint=$(mktemp -d)
cleanup() { sudo umount "$mountpoint" 2>/dev/null || true; rmdir "$mountpoint" 2>/dev/null || true; }
trap cleanup EXIT

sudo mount -o subvolid=5 "$root_device" "$mountpoint"
snapshot_dir="$mountpoint/@snapshots/omadora"
sudo mkdir -p "$snapshot_dir"
sudo btrfs subvolume snapshot -r "$mountpoint/$root_subvol" "$snapshot_dir/root-$stamp"
sudo btrfs subvolume snapshot -r "$mountpoint/$home_subvol" "$snapshot_dir/home-$stamp"
sudo btrfs subvolume show "$snapshot_dir/root-$stamp" | tee "$project/logs/snapshot-root-$stamp.txt"
sudo btrfs subvolume show "$snapshot_dir/home-$stamp" | tee "$project/logs/snapshot-home-$stamp.txt"
echo "Verified read-only snapshots created under @snapshots/omadora at timestamp $stamp."
