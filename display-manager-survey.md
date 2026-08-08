# Display Manager survey & decision (Omadora / Hyprland)

Date: 2026-08-07. Context: replacing the (now-removed) Plasma `plasmalogin`
with a display manager that matches the Om/a/omarchy Hyprland aesthetic.

## What Omarchy itself uses

Checked the pinned upstream clone at
`upstream/omarchy`. Omarchy uses **SDDM** and themes the *whole login path*,
specifically running the greeter **inside the Hyprland compositor**:

- `etc/sddm.conf.d/10-wayland.conf`:
  `[General] DisplayServer=wayland`
  `[Wayland] CompositorCommand=start-hyprland -- --config /usr/share/sddm/hyprland.lua`
- ships `default/sddm/omarchy/` (its QML theme) → `Current=omarchy`
- ships `default/sddm/hyprland.lua` (minimal compositor config for the greeter)

So "beautiful + consistent" for this project = SDDM where the login screen is a
Hyprland compositor showing a QML theme over the desktop wallpaper.

## Candidates (Fedora 44 availability checked)

| DM | Version | In Fedora? | Beauty/effort | Verdict for Omadora |
|---|---|---|---|---|
| **SDDM (qt6)** | 0.21.0 | ✅ | High beauty, CSS/QML themes, Wayland greeter, themable login path. **Native to Omarchy.** | ✅ **Recommended / DONE** |
| greetd | 0.10.3 | ✅ (no greeter in F44 repos) | Very hackable but you must build/source a greeter yourself | ⚠️ only for heavy ricing |
| lightdm | 1.32.0 | ✅ | Meg/gimic; gtk greeter looks dated | ❌ |
| ly | 1.4.0 | ✅ | Gorgeous CLI-style TUI greeter, talkykeyboard; light | ⭐ nice minimal alt |
| gdm | — | (GNOME; pulls big GNOME) | Polished but pulls GNOME stack | ❌ against Hyprlander |

## Decision & implementation

**Chosen:** SDDM hosted on a Hyprland compositor (≈ Omarchy's exact design).
Installed `sddm`, `sddm-themes`, `sddm-wayland-generic`.

Files modified:
- `/etc/sddm.conf.d/10-hyprland.conf` → `CompositorCommand=/usr/bin/hyprland --config /usr/share/sddm/hyprland.lua`
- `/usr/share/sddm/hyprland.lua` → minimal greeter compositor config
- `/etc/sddm.conf.d/40-omadora.conf` → `[Theme] Current=maldives`, Numlock
- `/usr/share/sddm/themes/maldives/background.jpg` → **your actual desktop
  wallpaper** `themes/miasma/backgrounds/nature-of-fear.jpg` (backup: `.orig`)
- `/usr/share/wayland-sessions/omadora-hyprland-uwsm.desktop` copied so SDDM lists it

Result (verified running):
```
sddm → sddm-helper → hyprland (compositor) → sddm-greeter-qt (greeter)
```
`display-manager.service → sddm.service`; `graphical.target` default.
Sessions shown: `hyprland.desktop`, `omadora-hyprland-uwsm.desktop`.

To reach it from a TTY: press **Ctrl+Alt+F7** (the DM VT), then log into
**Hyprland** or **Omadora (Hyprland UWSM)**.

## Alternatives if you want even more
- **Omarchy's own `omarchy` theme**: copy `default/sddm/omarchy/` →
  `/usr/share/sddm/themes/` and set `Current=omarchy`.
- **`ly`** if you prefer a typographic terminal login.
- Later hook Omad-theme up to the greeter so the login changes with `tokyo-night`
  etc. (this is the one thing DIVERGENCE.md currently defers).

## Note
- Only `plasma-discover*` pieces of KDE remain (a useful GUI software store,
  harmless). Everything tied to the Plasma *shell/login* is gone.
- Dolphin was kept per your request.