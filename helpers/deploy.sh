#!/usr/bin/env bash
# Deploy all tracked non-root shell-hotkey and UX helpers.
set -euo pipefail

usage() {
  echo "Usage: $0 [--check|--dry-run]" >&2
}

mode=deploy
case "${1:-}" in
  '') ;;
  --check) mode=check ;;
  --dry-run) mode=dry-run ;;
  -h|--help) usage; exit 0 ;;
  *) usage; exit 2 ;;
esac

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
destination_dir="${HOME}/.local/bin"
helpers=(omadora-audio-output-volume omarchy-system-stats omadora-theme)

[[ -x /usr/bin/wpctl ]] || {
  echo 'wpctl is required; install the WirePlumber/PipeWire CLI first.' >&2
  exit 1
}

for helper in "${helpers[@]}"; do
  source_file="$repo_dir/helpers/$helper"
  [[ -f $source_file ]] || { echo "Missing helper: $source_file" >&2; exit 1; }
  bash -n "$source_file"
done

case "$mode" in
  check)
    echo 'Non-root helper sources and dependencies are valid.'
    ;;
  dry-run)
    for helper in "${helpers[@]}"; do
      printf 'Would install %s -> %s/%s\n' "$repo_dir/helpers/$helper" "$destination_dir" "$helper"
    done
    ;;
  deploy)
    mkdir -p "$destination_dir"
    for helper in "${helpers[@]}"; do
      target="$destination_dir/$helper"
      temporary=$(mktemp "$destination_dir/.${helper}.XXXXXX")
      trap 'rm -f "${temporary:-}"' EXIT
      install -m 0755 "$repo_dir/helpers/$helper" "$temporary"
      mv -f "$temporary" "$target"
      trap - EXIT
      echo "Installed $target"
    done
    ;;
esac
