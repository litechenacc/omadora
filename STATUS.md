# Omadora execution status

## Completed

- [x] Project plan and acceptance checklist created.
- [x] Baseline captured in `logs/phase-0-baseline-20260806-210521.txt`.
- [x] User desktop configuration archive created and integrity-tested.
- [x] Read-only Btrfs snapshots created: `root-20260806-210722` and `home-20260806-210722`.
- [x] Phase 1 transaction dry-run reviewed with weak dependencies disabled.
- [x] Phase 1 foundation packages installed and executable versions verified.
- [x] A stock `Hyprland` login-session entry is installed at `/usr/share/wayland-sessions/hyprland.desktop`.
- [x] Phase 2 minimal self-owned Hyprland, Hypridle, and Hyprlock configurations created and parsed successfully.
- [x] Hyprland login, terminal, lock, screenshot/clipboard, and F-key volume/brightness controls passed manual verification.
- [x] Live Hyprland confirms all ten XF86 media/brightness bindings are registered.
- [x] Hyprland built-in temporary OSD added for media/brightness feedback until Quickshell supplies the permanent OSD.
- [x] Fixed the Hyprland polkit-agent autostart path and verified the agent runs in the current session.
- [x] Portal selection prerequisites verified: Hyprland session environment is present in the user manager and the packaged Hyprland portal policy selects `hyprland;gtk`.
- [x] Hypridle timeout, audio output switching, Zen file chooser, and suspend/wake passed manual verification.
- [x] Phase 4 source is pinned at `upstream/omarchy` commit `11a6ae2230abb6ab3a4af1a31a79b922ba3ead64`.
- [x] A deliberately minimal Omarchy Quickshell shell configuration was smoke-tested and is running in the current Hyprland session.
- [x] Installed `inotify-tools`, required by Omarchy's plugin watcher.
- [x] Added a Fedora-compatible `omarchy-audio-output-sink` helper in `~/.local/bin`.
- [x] Replaced imported `pactl` media-key volume control with the tracked, PipeWire-native `omadora-audio-output-volume` helper; normal and precise Fn volume bindings and the Quickshell OSD were verified.
- [x] Created and installed the additive `Omadora (Hyprland UWSM)` login session; it does not replace the stock Hyprland or KineticWE entries.

- [x] Phase 5 UWSM session verified: graphical-session.target and the Hyprland compositor unit are active.
- [x] UWSM exported the expected Hyprland and OMARCHY_PATH environment to the user manager.
- [x] XDG desktop portal, Hyprland portal backend, and GTK portal backend are all active in the UWSM session.
- [x] Hyprland, minimal Quickshell bar/audio panel, terminal, lock, and F-key controls passed manual verification in UWSM.
- [x] `hyprland-guiutils` installed from the deferred manifest after explicit approval.
- [x] Added the Omadora feature-port backlog at `docs/FEATURE-PORT.md`.
- [x] Began Shell Essentials: enabled Omarchy-compatible Quickshell OSD and notification services; added Bluetooth, network, monitor, and power bar widgets; added Fedora audio and internal-backlight compatibility helpers.
- [x] Reloaded the live Hyprland/Quickshell configuration and sent Omadora OSD and notification smoke tests.
- [x] Added Fedora-compatible NetworkManager status/band helpers; live Wi-Fi status and detailed telemetry were verified.
- [x] Installed JetBrains Mono Nerd Font locally and restarted Quickshell; this supplies the missing private-use glyphs used by Omarchy's bar widgets.
- [x] Removed the incompatible manually-installed Vicinae `/usr/local` payload, launcher files, browser host, user configuration, global shortcut, and auto-restarting `vicinae.service`; no failed user units remain.
- [x] Added Fedora-compatible DNS, text-size, monitor-state/scaling, and power-profile helpers. DNS reports DHCP, the monitor panel protocol returns live eDP-1/backlight state, and scaling no-op validation passed.
- [x] `tuned-ppd` is the Fedora power-profile provider; added a local `powerprofilesctl` compatibility client so the Omarchy-derived panel can control its D-Bus API.
- [x] Added the battery-status adapter and enabled the precise battery percentage in the bar. Fixed the internal-backlight adapter to accept Omarchy's `--no-osd --monitor OUTPUT PERCENT` panel protocol; a live 35% no-op write test passed.
- [x] Added the first Omadora interaction bindings: `Super+B` focuses/starts Fedora Chromium, `Super+/` opens the interactive shortcut helper, `Super+Space` opens the app launcher, and `Super+Escape` opens the system menu. The bindings are live and listed by the helper.
- [x] Replaced the unstable Zen `Super+B` route with Fedora Chromium. Chromium is the XDG default browser, launches with Omadora's Wayland/secret-service flags, and the helper focuses an existing Chromium window rather than spawning another one.
- [x] Added Fedora-owned `omadora-theme`; it consumes only pinned upstream color/background assets and applies Hyprland border colors, Quickshell colors, and a themed hyprpaper wallpaper. `tokyo-night` is active and persists through `~/.local/state/omarchy/current/theme` for Quickshell compatibility.
- [x] Expanded the shell with the upstream media, clipboard, emoji, image-picker, and night-light services. Clipboard capture is supplied by the shell's own `wl-paste` watchers; `cliphist` was installed as an available Fedora history backend.
- [x] Imported Omarchy's full Hyprland binding catalogue (272 live binds) without importing its autostart, package, boot, or system setup. Fedora/Omadora routes continue to override browser, launcher, system menu, panels, media keys, lock, and theme picker.
- [x] Fixed the theme picker: the theme list now finds all 22 pinned upstream themes and `perl-JSON-PP` supplies the Quickshell menu selector payload. The picker was smoke-tested through its open/wait path. Fixed hyprpaper for v0.8 syntax; the active Kanagawa wallpaper is verified on eDP-1.
- [x] Resolved the `Super+/` collision introduced by the full binding catalogue: the upstream monitor-scale binding is explicitly unbound, leaving only Omadora shortcut help on that key.
- [x] Enabled the Omarchy menu service as a Quickshell backend only (no extra bar icon) and added Fedora-safe lock/logout/reboot/shutdown action adapters. Installed `libxkbcommon-utils` for readable keycode names in shortcut help.

- [x] Processed `2223-request.md`: tightened Hyprland gaps/borders; mapped Caps Lock to Escape; swapped Ctrl/Alt on both sides; configuration reload and XKB validation passed.
- [x] Created a fresh verified user-config archive and read-only Btrfs root/home snapshots (`20260806-223459`) before cleanup.
- [x] Removed KineticWE safely by replacing its `kwin` provider with Fedora `kwin`; removed Noctalia with `--no-autoremove`; disabled the KineticWE COPR. Plasma login, Plasma, portals, Hyprland/UWSM/Quickshell, the stock Hyprland session, and Omadora remain installed.
- [x] Started the flattened launcher replacement: `omadora-launcher` combines desktop apps with Omadora-only theme, power, panel, clipboard, emoji, calculator, and explicit command routes. `Super+Space` opens it and `Super+Escape` opens it prefiltered to `System:`; desktop icons, live calculator results, Google (`g`→Tab), ChatGPT (`a`→Tab), and Helium bookmarks are integrated; the nested Go/root routes are no longer bound.
- [x] Expanded `omadora-theme` to generate user-level Ghostty colors and a declarative local Chromium theme extension alongside Hyprland, Quickshell, and wallpaper outputs. Chromium applies the changed theme on its next full restart.
- [x] Added non-invasive Chromium startup telemetry at `~/.local/state/omadora/chromium-startup.log`; a cold `Super+B` launch reached its first window in 821 ms. Upstream Omarchy does not retain a persistent Chromium daemon; it launches Chromium through UWSM per request.
- [x] Added Fedora Chromium adapters for the imported Omarchy web-app bindings (`omarchy-launch-webapp`, focus-or-launch variants), so supported web-app shortcuts use Chromium app windows under UWSM.
- [x] Tuned Hyprland to a fast, subtle animation profile: 0.5–0.8 speed pop/fade/slide animations with a 96% window pop-in; animations remain enabled and the configuration reload was verified.
- [x] Installed official Helium (`helium-bin`) from the `imput/helium` Fedora COPR, made it the XDG default browser, and mapped `Super+B` to a new Helium window and `Super+A` to ChatGPT as a Helium app. Chromium and Zen were removed; user browser profiles were retained.

## Current verification gate: Shell Essentials

Verify that the added bar widgets are visible, that F-key volume/brightness now show the Quickshell OSD, and that a test notification appears. Broken panel actions will be ported individually; do not enable Arch-specific functionality blindly.

Known deferred item: screen-sharing verification remains to be tested with Helium.
