#!/usr/bin/env bash
# Deploy the Omadora launcher command layer into the current user's PATH.
# This intentionally does not modify Hyprland or Quickshell configuration.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./deploy.sh [--dry-run] [--check] [--dest DIR] [--omarchy-path DIR]

Install the launcher commands in ~/.local/bin (or DIR), then apply the small
initial-query compatibility patch to the active Omarchy menu QML. --check
validates sources and runtime dependencies without writing files. --dry-run
prints planned changes without writing files.
EOF
}

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_dir="$root/bin"
dest_dir="${HOME}/.local/bin"
omarchy_path="${OMARCHY_PATH:-$(cd -- "$root/../upstream/omarchy" 2>/dev/null && pwd || printf '%s' "$root/../upstream/omarchy")}"
dry_run=false
check_only=false

while (($#)); do
  case "$1" in
    --dry-run) dry_run=true ;;
    --check) check_only=true ;;
    --dest)
      shift
      (($#)) || { echo "--dest requires a directory" >&2; exit 2; }
      dest_dir=$1
      ;;
    --omarchy-path)
      shift
      (($#)) || { echo "--omarchy-path requires a directory" >&2; exit 2; }
      omarchy_path=$1
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

# Install helpers before the entry point so its dependency is available first.
commands=(omadora-shell omadora-menu-select omadora-menu-input omadora-system-logout omadora-open-url omadora-theme-picker-preview omadora-launcher omadora-launcher-toggle)
for command in "${commands[@]}"; do
  source="$source_dir/$command"
  [[ -f $source ]] || { echo "Missing source: $source" >&2; exit 1; }
  bash -n "$source"
done

# These are intentionally runtime checks: `omarchy-shell` is the existing
# Quickshell IPC adapter, while the other commands execute selected actions.
runtime=(python3 perl quickshell timeout)
missing=()
for command in "${runtime[@]}"; do command -v "$command" >/dev/null 2>&1 || missing+=("$command"); done
if ((${#missing[@]})); then
  printf 'Missing runtime command(s): %s\n' "${missing[*]}" >&2
  exit 1
fi

menu_qml="$omarchy_path/shell/plugins/menu/Menu.qml"
menu_patch_tool="$root/tools/apply-menu-initial-query.py"
[[ -f $menu_qml ]] || { echo "Missing active menu QML: $menu_qml" >&2; exit 1; }
[[ -f $menu_patch_tool ]] || { echo "Missing menu patch tool: $menu_patch_tool" >&2; exit 1; }
python3 "$menu_patch_tool" --check "$menu_qml" >/dev/null

if $check_only; then
  echo "Launcher sources and core runtime dependencies are valid."
  exit 0
fi

launcher_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/omadora"
launcher_env="$launcher_config_dir/launcher.env"

if $dry_run; then
  for command in "${commands[@]}"; do printf 'Would install %s -> %s/%s\n' "$source_dir/$command" "$dest_dir" "$command"; done
  [[ -f $launcher_env ]] || printf 'Would create %s with OMARCHY_PATH=%s\n' "$launcher_env" "$omarchy_path"
  python3 "$menu_patch_tool" --check "$menu_qml"
  exit 0
fi

mkdir -p "$dest_dir" "$launcher_config_dir"
if [[ ! -f $launcher_env ]]; then
  temporary=$(mktemp "$launcher_config_dir/.launcher.env.XXXXXX")
  printf 'OMARCHY_PATH=%q\n' "$omarchy_path" >"$temporary"
  chmod 600 "$temporary"
  mv -f "$temporary" "$launcher_env"
  echo "Created $launcher_env"
fi
for command in "${commands[@]}"; do
  target="$dest_dir/$command"
  temporary=$(mktemp "$dest_dir/.${command}.XXXXXX")
  trap 'rm -f "${temporary:-}"' EXIT
  install -m 0755 "$source_dir/$command" "$temporary"
  mv -f "$temporary" "$target"
  trap - EXIT
  echo "Installed $target"
done

# The picker needs an initial query for the Super+Escape System route. Keep
# this tiny, version-checked compatibility change as a managed patch rather
# than silently copying an entire upstream QML plugin into the repository.
python3 "$menu_patch_tool" "$menu_qml"
