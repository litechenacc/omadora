# Omadora

**Omadora** is a personal Fedora Hyprland desktop inspired by [Omarchy](https://omarchy.org/).

The name means **Omakaze Fedora**: an Omarchy-like, opinionated desktop made for Fedora, shaped around my own preferences. It is also a small nod to *Doraemon* and **tanomuyo**: the confidence of handing work to a trusted machine.

## What it is

- Fedora + Hyprland, managed as a graphical session by UWSM
- Omarchy Quickshell shell and theme assets, used as a pinned upstream reference
- A self-owned Hyprland Lua configuration and Fedora compatibility helpers
- Plasma login, Fedora portals, PipeWire/WirePlumber, hyprlock, hypridle, and hyprpaper
- Dwindle/BSP tiling with consistent window insertion and very short enabled animations
- A flattened Omadora launcher, Omarchy-style keyboard help, panels, OSD, clipboard, media, emoji, image picker, and night light
- Helium Browser as the default browser (`Super+B`) and ChatGPT as a Helium app (`Super+A`)

## What it is not

Omadora is **not** Omarchy installed on Fedora, an Arch derivative, or an installer. It does not run the LinuxBeginnings installer, use AUR tooling, replace the display manager, or adopt Omarchy's boot, `/etc`, package-management, or system-theme scripts.

The upstream source is pinned at commit `11a6ae2230abb6ab3a4af1a31a79b922ba3ead64` under `upstream/omarchy` and is treated as reference material.

## Daily shortcuts

| Shortcut | Action |
| --- | --- |
| `Super+B` | New Helium window |
| `Super+A` | ChatGPT in a Helium app window |
| `Super+Space` | Omadora launcher |
| `Super+/` or `Super+K` | Keyboard shortcut help |
| `Super+Return` | Ghostty |
| `Super+Q` | Close window |
| `Super+F` | Toggle fullscreen |
| `Super+Shift+S` | Region screenshot to clipboard |
| `Super+Ctrl+V` | Clipboard history |
| `Super+Ctrl+E` | Emoji picker |

## Layout and interaction choices

- 3px inner gaps, 6px outer gaps, 1px borders
- Caps Lock is Escape
- Left and right Ctrl/Alt are swapped
- Dwindle uses `force_split = 2` and `preserve_split = true` for predictable BSP insertion
- Animations remain enabled but run at roughly 50–80 ms

## Repository scope

This repository records the plan, decision log, manifests, session entry, helpers, and documentation. Active user configuration lives in `~/.config` and `~/.local/bin`; it is intentionally not copied into this repository with private state or browser data. Backups, logs, and the upstream checkout are excluded from Git.

See [docs/STRUCTURE.md](docs/STRUCTURE.md) for the repository map, deployment boundaries, and ownership model.

## Safety and maintenance

- Select **Omadora (Hyprland UWSM)** at the login screen.
- Fedora owns system packages and system integration. Omadora's helpers are user-level adapters only.
- Test upstream Omarchy changes selectively; do not merge or execute its system-wide scripts blindly.
- Review `PLAN.md`, `STATUS.md`, and the acceptance checklist before structural changes.

## License and attribution

Omadora is a personal configuration layer. Omarchy remains its own upstream project with its own license and authorship. This project reuses only selected upstream concepts, Quickshell components, and theme assets under their applicable upstream terms.
