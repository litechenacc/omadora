# Omarchy → Omadora divergence report

**Date:** 2026-08-06
**Upstream reference:** Omarchy commit `11a6ae2230abb6ab3a4af1a31a79b922ba3ead64`

Omadora is a selective Fedora port inspired by Omarchy. It is intentionally not a downstream distribution or a whole-tree fork.

| Area | Omarchy approach | Omadora approach |
| --- | --- | --- |
| Base platform | Arch-focused desktop and tooling | Fedora 44 user environment |
| Installation | Omarchy/LinuxBeginnings install paths and Arch package assumptions | No installer or AUR use; reviewed Fedora RPM transactions only |
| Upstream source | Active Omarchy configuration | Pinned, read-only reference checkout; selected assets/QML/bindings are adopted deliberately |
| Session lifecycle | Omarchy session conventions | UWSM-managed Hyprland graphical session |
| Login/display manager | Omarchy system integration can theme the login path | Retains Plasma login and the stock Hyprland session; Omadora is an additive session entry |
| Portals and polkit | Omarchy-oriented integration | Fedora portal packages retained; `hyprpolkitagent` retained to avoid competing authentication agents |
| Shell | Omarchy Quickshell | Omarchy Quickshell components with Fedora adapters and an Omadora shell configuration |
| Bar and menus | Upstream menu structure and commands | One flattened `omadora-launcher`; only Fedora-safe, mapped actions are exposed |
| System actions | Arch package, service, boot, and `/etc` helpers | User-level lock/logout/reboot/shutdown adapters only; Fedora owns system configuration |
| Themes | Broad Omarchy theming, including system surfaces | `omadora-theme` applies pinned colors/backgrounds to Hyprland, Quickshell, Ghostty, and hyprpaper only |
| Window behavior | Upstream defaults and binding catalogue | Dwindle BSP policy is explicit (`force_split = 2`, `preserve_split = true`); gaps/borders and input layout are personal choices |
| Motion | Upstream defaults | Animations stay enabled, using short 0.5–0.8 timing for responsiveness |
| Keyboard bindings | Full Omarchy catalogue | Catalogue imported selectively at user level; collisions and unsupported routes are unbound or overridden |
| Browsers | Upstream supports its expected browser routes | Helium is the Fedora default and primary route (`Super+B`); ChatGPT opens as a Helium app (`Super+A`); Chromium and Zen were removed |
| Browser web apps | Upstream Chromium-family assumptions | Local `omarchy-launch-webapp` compatibility helper opens Helium app windows via UWSM |
| Audio, display, network, power | Omarchy helpers assume its system stack | Local helpers translate to PipeWire/WirePlumber, NetworkManager, backlight, monitor, DNS, battery, and `tuned-ppd` facilities |
| Removal policy | N/A | KineticWE and Noctalia were removed only after verified backups and Btrfs snapshots; Plasma remains available |
| Updates | Omarchy package/update flows | Fedora DNF manages Fedora packages; Helium uses its official `imput/helium` COPR; upstream changes are reviewed manually |

## Deliberate exclusions

The following Omarchy areas are out of scope unless separately reviewed for Fedora:

- Arch repositories, AUR, package installation, and upgrade scripts
- `/etc` edits, bootloader/Plymouth configuration, and display-manager replacement
- Omarchy SDDM and boot theming
- Arch-specific browser extension locations, package paths, and service assumptions
- Any menu action without a verified Fedora implementation

## Local additions

Omadora adds Fedora-specific compatibility helpers, a UWSM session entry, a flattened launcher, a local theme command, a short-animation profile, a predictable Dwindle policy, Caps→Escape, Ctrl/Alt swaps, and browser shortcuts chosen for this desktop.

## Result

The visible interaction model takes inspiration from Omarchy, while ownership remains clear: Fedora owns the operating system; Omadora owns its user-level integration; Omarchy remains an attributed upstream reference.
