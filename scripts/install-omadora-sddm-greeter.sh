#!/usr/bin/env bash
# Install Omadora's wallpaper-backed Omarchy-derived SDDM greeter.
# Run from any directory with: sudo ./scripts/install-omadora-sddm-greeter.sh
set -euo pipefail

if (( EUID != 0 )); then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
source_theme="$repo_root/upstream/omarchy/default/sddm/omarchy"
template="$repo_root/assets/sddm/omadora/Main.qml"
theme=/usr/share/sddm/themes/omarchy
config=/etc/sddm.conf.d/99-omadora-greeter.conf
wallpaper_url='https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=3840&q=90'
stamp=$(date +%Y%m%d-%H%M%S)
backup=/root/omadora-sddm-greeter-backup-$stamp

[[ -d "$source_theme" ]] || { echo "Missing pinned Omarchy source: $source_theme" >&2; exit 1; }
[[ -f "$template" ]] || { echo "Missing QML template: $template" >&2; exit 1; }
command -v curl >/dev/null || { echo "curl is required to fetch the wallpaper" >&2; exit 1; }

install -d -m 0700 "$backup"
[[ -d "$theme" ]] && cp -a "$theme" "$backup/theme"
[[ -f "$config" ]] && cp -a "$config" "$backup/"

# Start with the pinned upstream assets, then apply only our maintained QML template.
rm -rf "$theme"
install -d -m 0755 /usr/share/sddm/themes
cp -a "$source_theme" "$theme"
install -m 0644 "$template" "$theme/Main.qml"

wallpaper=$(mktemp)
trap 'rm -f "$wallpaper"' EXIT
curl --fail --location --silent --show-error --output "$wallpaper" "$wallpaper_url"
install -m 0644 "$wallpaper" "$theme/background.jpg"

# This late override avoids changing Fedora's stock SDDM configuration files.
cat > "$config" <<'EOF'
[Theme]
Current=omarchy

[Wayland]
CompositorCommand=/usr/bin/start-hyprland -- --config /usr/share/sddm/hyprland.lua
EOF
chmod 0644 "$config"

echo "Installed Omadora SDDM greeter. Backup: $backup"
echo "Log out or reboot to start a fresh SDDM greeter."
