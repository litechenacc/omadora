#!/usr/bin/env bash
# Install the reproducible Fcitx5/Rime configuration for the current user.
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
assets_dir="$repo_dir/assets/fcitx5"
config_dir="$HOME/.config/fcitx5"
environment_dir="$HOME/.config/environment.d"
unit_dir="$HOME/.config/systemd/user"
shell_config="${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/shell.json"
ime_indicator="$HOME/.local/bin/omadora-ime-status"
rime_dir="$HOME/.local/share/fcitx5/rime"
bopomofo_source_dir="$HOME/.local/share/omadora/rime-bopomofo"
bopomofo_url=https://github.com/rime/rime-bopomofo.git
bopomofo_files=(
  bopomofo_express.schema.yaml
  bopomofo.schema.yaml
  bopomofo_tw.schema.yaml
  detenele.schema.yaml
  zhuyin.yaml
)

for command in fcitx5 git systemctl install python3; do
  command -v "$command" >/dev/null || {
    echo "Required command is unavailable: $command" >&2
    exit 1
  }
done
for source in \
  "$assets_dir/environment.d/10-omadora-fcitx.conf" \
  "$assets_dir/systemd/omadora-fcitx5.service" \
  "$assets_dir/rime/default.custom.yaml" \
  "$assets_dir/rime/bopomofo_tw.custom.yaml" \
  "$assets_dir/bin/omadora-ime-status" \
  "$assets_dir/profile" \
  "$repo_dir/scripts/configure-ime-indicator.py"; do
  [[ -f $source ]] || { echo "Missing source: $source" >&2; exit 1; }
done

case "$mode" in
  check)
    python3 "$repo_dir/scripts/configure-ime-indicator.py" --check "$shell_config"
    echo 'Fcitx5 deployment sources and dependencies are valid.'
    exit 0
    ;;
  dry-run)
    cat <<EOF
Would install $assets_dir/environment.d/10-omadora-fcitx.conf -> $environment_dir/10-omadora-fcitx.conf
Would install $assets_dir/systemd/omadora-fcitx5.service -> $unit_dir/omadora-fcitx5.service
Would install $assets_dir/profile -> $config_dir/profile
Would install $assets_dir/bin/omadora-ime-status -> $ime_indicator
Would add the Fcitx5 indicator to $shell_config
Would clone/update rime-bopomofo source at $bopomofo_source_dir from $bopomofo_url
Would install the Bopomofo schema files and tracked Rime overrides -> $rime_dir/
Would enable omadora-fcitx5.service for graphical-session.target
EOF
    exit 0
    ;;
esac

install_file() {
  local source=$1 destination=$2 mode=${3:-0644} directory temporary
  directory=$(dirname -- "$destination")
  mkdir -p "$directory"
  temporary=$(mktemp "$directory/.${destination##*/}.XXXXXX")
  install -m "$mode" "$source" "$temporary"
  mv -f "$temporary" "$destination"
}

install_file "$assets_dir/environment.d/10-omadora-fcitx.conf" "$environment_dir/10-omadora-fcitx.conf"
install_file "$assets_dir/systemd/omadora-fcitx5.service" "$unit_dir/omadora-fcitx5.service"
install_file "$assets_dir/profile" "$config_dir/profile"
install_file "$assets_dir/bin/omadora-ime-status" "$ime_indicator" 0755
python3 "$repo_dir/scripts/configure-ime-indicator.py" "$shell_config"

if [[ -d $bopomofo_source_dir/.git ]]; then
  origin=$(git -C "$bopomofo_source_dir" remote get-url origin)
  [[ $origin == "$bopomofo_url" ]] || {
    echo "Bopomofo source checkout has an unexpected origin: $origin" >&2
    exit 1
  }
  git -C "$bopomofo_source_dir" pull --ff-only
elif [[ -e $bopomofo_source_dir ]]; then
  echo "Bopomofo source directory is not a git checkout: $bopomofo_source_dir" >&2
  exit 1
else
  mkdir -p "$(dirname -- "$bopomofo_source_dir")"
  git clone --depth=1 "$bopomofo_url" "$bopomofo_source_dir"
fi

mkdir -p "$rime_dir"
for file in "${bopomofo_files[@]}"; do
  install_file "$bopomofo_source_dir/$file" "$rime_dir/$file"
done
install_file "$assets_dir/rime/default.custom.yaml" "$rime_dir/default.custom.yaml"
install_file "$assets_dir/rime/bopomofo_tw.custom.yaml" "$rime_dir/bopomofo_tw.custom.yaml"

systemctl --user daemon-reload
# Remove a stale value imported before GTK switched to Wayland text-input.
systemctl --user unset-environment GTK_IM_MODULE || true
systemctl --user enable omadora-fcitx5.service
if pgrep -x fcitx5 >/dev/null; then
  fcitx5-remote -r || true
fi

cat <<'EOF'
Fcitx5/Rime was deployed. Log out of Hyprland and log in again so environment.d
is inherited by every application and the user service starts with Wayland.
Use Ctrl+Space to toggle English and Rime. Rime is configured for 注音·臺灣正體
(bopomofo_tw, the standard 大千 keyboard layout).
EOF
