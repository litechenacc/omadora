# Omadora: Fedora Hyprland + Quickshell migration

## Goal
Replace the daily KineticWE/Noctalia session with a UWSM-managed Hyprland session and a small Fedora-compatible port of the Omarchy Quickshell desktop. Preserve a working fallback until the new session passes acceptance tests.

## Non-negotiable safety rules

- Do not run the LinuxBeginnings installer wholesale or install its Kool dotfiles.
- Do not replace the display manager during the initial migration.
- Do not remove KineticWE, Noctalia, Plasma, or existing portal packages before the Hyprland acceptance test passes.
- Make a Btrfs snapshot and a user-config backup before installing packages.
- Each phase has a measurable success condition and a rollback path.

## Current baseline

- Fedora 44, AMD Radeon 840M/860M (`amdgpu`), ASUS Zenbook 14 UM3406KA.
- Root and home are separate Btrfs subvolumes.
- Login manager: `plasmalogin`.
- Current daily-test session: Omadora (Hyprland UWSM + Quickshell); KineticWE/Plasma remains an available fallback.
- PipeWire and WirePlumber are already present and working.
- Enabled COPR `lionheartp/Hyprland` currently provides the needed Hyprland, UWSM, Quickshell, and Hyprland portal packages.
- The LinuxBeginnings/Fedora-Hyprland installer is reference-only: it would enable unrelated COPRs and install a different Waybar/AGS-based desktop.
- Omarchy is reference/port source, not an installable Fedora dotfile package. Its commands and Arch-specific system integration must not be copied blindly.

## Execution phases

### 0. Safety baseline and rollback

1. Record package, service, repository, graphics, filesystem, and session baseline.
2. Create a timestamped user configuration backup.
3. Create verified read-only Btrfs snapshots of root and home. This requires interactive sudo.

**Verification:** backup archive exists and lists correctly; snapshot list contains both snapshots.

### 1. Minimal Hyprland package foundation

Install only the reviewed core package set from Fedora/current Hyprland COPR:

- `hyprland`, `hypridle`, `hyprlock`, `hyprpaper`, `hyprsunset`, `hyprpolkitagent`
- `uwsm`, `quickshell`
- `xdg-desktop-portal-hyprland`, retained `xdg-desktop-portal-gtk`
- support tools: `brightnessctl`, `grim`, `slurp`, `wl-clipboard`, `playerctl`, `pavucontrol`

**Verification:** RPM ownership and executable versions are recorded; an unmodified Hyprland session entry is visible at login.

### 2. Minimal independent Hyprland session

Create a self-owned minimal configuration with terminal, lock, idle, polkit, direct PipeWire media keys, brightness keys, screenshots, clipboard, and wallpaper.

**Verification:** login succeeds and all core key functions work without KDE/Noctalia processes.

### 3. Desktop plumbing acceptance

Validate monitor changes, lid/sleep/wake, audio-device switching, Bluetooth, portals/file chooser, screen sharing, screenshots, lock/unlock, and login/logout.

**Verification:** every item in `docs/ACCEPTANCE.md` passes from a Hyprland login.

### 4. Omarchy Quickshell port

Create a separate, version-controlled Fedora port. Bring in Omarchy's Quickshell shell first, then only selected Hyprland behavior and small Fedora helper scripts. Do not install Arch packages or copy Omarchy `/etc` overrides.

**Verification:** one Quickshell process supplies bar, OSD, and panels with no Waybar/AGS/Noctalia duplicate components.

### 5. UWSM session integration

Run Hyprland and applications under UWSM; import the graphical environment into systemd and D-Bus.

**Verification:** D-Bus-activated applications, portals, polkit, and user services have the correct Wayland environment after a fresh login.

### 6. Daily-driver trial

Use Hyprland for at least one week while retaining KineticWE as fallback. `hyprland-guiutils` is scheduled in `manifests/deferred-packages.txt`; review it after this stable base trial rather than reacting to Hyprland's post-login recommendation immediately.

**Verification:** all acceptance tests pass repeatedly and no blocker remains.

### 7. Deliberate cleanup

After a final snapshot, remove only components explicitly chosen for removal.

**Verification:** package removal transaction is reviewed, and Hyprland still starts after reboot.

## Progress review (2026-08-06)

- Phases 0–2 are complete: baseline/config archive and read-only Btrfs snapshots exist; the independent Hyprland session passed its core login, lock, media, brightness, screenshot, clipboard, idle, audio-switching, portal/file-chooser, and suspend/wake checks.
- Phases 4–5 are substantially complete: the Omarchy source is pinned as reference only; Quickshell runs under UWSM with the graphical-session target, portals, and a single Omadora bar/OSD/notification stack.
- Shell Essentials are actively being hardened one helper at a time. Fedora-owned adapters now cover audio, Wi-Fi status/band, internal backlight, DNS, monitor state/scaling, text size, battery telemetry, and `tuned-ppd` power profiles. The media, clipboard, emoji, image-picker, and night-light shell services are also enabled. They require functional verification from the live panels, not merely command output.
- Vicinae was an unrelated manually installed `/usr/local` AppImage payload incompatible with the system Qt private API. It was removed, including its user service and stale launcher integration.
- A Fedora-owned `omadora-theme` layer now applies pinned upstream color/background assets to Hyprland, Quickshell, and hyprpaper. It deliberately does not apply Omarchy's display-manager, boot, package, or `/etc` theme integration. `tokyo-night` is the initial active theme.
- Chromium is now the Fedora/XDG browser and the Omadora browser route focuses an existing Chromium window. Omarchy's bundled Chromium extensions are not enabled because their installed paths and update model are Arch-specific.
- Phase 3 remains open for the deferred screen-sharing check; Phase 6 (one-week daily-driver trial) and Phase 7 cleanup have not begun. KineticWE/Plasma must remain installed until Phase 6 passes.

## Request workstream: 2223 (`2223-request.md`)

The complete user request is retained in [`2223-request.md`](2223-request.md). It supersedes the former immediate-action ordering for the following user-level work while preserving the system-integration safety boundary.

1. **Input and layout — complete.** Hyprland uses 3px inner gaps, 6px outer gaps, and 1px borders. Caps Lock maps to Escape; left and right Ctrl/Alt are swapped through accepted XKB options. `hyprctl reload` and an XKB compilation check passed.
2. **Full user-level theming — in progress.** Extend `omadora-theme` beyond Quickshell/Hyprland/hyprpaper to user-owned terminal and Chromium preferences where the upstream format is portable. Keep display-manager, boot, `/etc`, and Arch package theming out of scope.
3. **Chromium responsiveness — queued.** Capture a cold-start timing and Chromium logs; retain Wayland/GPU acceleration and avoid unsupported upstream extension paths. Fix only evidence-backed launch/configuration causes.
4. **Flattened Omadora launcher — queued.** Replace the current root/apps/system menu routes with one searchable launcher containing desktop apps, calculator expressions, Omadora commands, power actions, and theme selection. It must exclude unmapped Omarchy/Arch actions. The old Go/root menu will be removed only after the replacement is verified.
5. **KineticWE removal — complete.** Fresh verified user-config archive and read-only root/home Btrfs snapshots were created at `20260806-223459`. KineticWE was safely replaced with Fedora `kwin` to preserve Plasma dependencies; `noctalia-git` was removed with `--no-autoremove`, retaining `gpu-screen-recorder` and fonts. The KineticWE COPR was disabled. `plasmalogin`, Plasma, Hyprland, UWSM, Quickshell, and the Omadora/stock-Hyprland sessions remain installed.

## Immediate next action

Complete items 2–4: broaden portable user-level theme outputs, collect Chromium cold-start evidence, and implement/test the flattened Omadora launcher before retiring the remaining root/apps/system-menu routes.
