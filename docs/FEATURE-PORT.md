# Omadora feature-port backlog

Omadora is a Fedora port inspired by Omarchy, not an Arch installation. The current upstream checkout remains a pinned reference. The `omarchy-*` names in `~/.local/bin` are temporary compatibility adapters required by upstream Quickshell QML; user-facing branding stays **Omadora**.

## A. Shell essentials — active

1. Quickshell OSD for volume and brightness.
2. Shell notification service.
3. Visible bar widgets: Bluetooth, network/Wi-Fi, audio, monitor, power.
4. Fedora PipeWire and backlight helpers for the audio/monitor panels.

**Acceptance:** F-keys show the Quickshell OSD; network, audio, and power controls are visible and usable.

## B. Omadora interaction model

1. Port the core Omarchy window/workspace/media bindings into the self-owned Hyprland Lua config.
2. Add `Super+K` to an Omadora keybinding/help surface.
3. Add an Omadora root menu/launcher path and map its actions to `uwsm app`.
4. Keep unsupported Arch-specific actions absent rather than presenting broken controls.

**Acceptance:** core shortcuts have discoverable help and launch applications through UWSM.

## C. Theme system

1. Create a Fedora-owned theme state directory and theme command, branded `omadora-theme`.
2. Reuse Omarchy theme color assets only; do not run its Arch-wide theme installer.
3. Generate Hyprland colors and Quickshell shell colors from the chosen theme.
4. Add a safe theme picker only after at least two themes switch cleanly.

**Acceptance:** selecting a theme changes Hyprland borders and Quickshell colors, persists across logout/login, and has a documented reset path.

## D. Feature expansion

Implement monitor, power, Bluetooth, network, clipboard, and screenshot panels one at a time. Each panel must have Fedora helpers, a live-session test, and a rollback before it is enabled.

## Deferred

- Helium screen-sharing verification.
- External-monitor handling.
- Arch-only Omarchy package/update/boot/system configuration features.
