# Repository structure

This repository is the **planning, documentation, and reproducible integration layer** for Omadora. It is not a complete dotfiles export or an operating-system image. Fedora owns packages and system services; active private/user state remains outside Git.

## Top-level map

```text
.
├── README.md                         Project identity, daily shortcuts, and boundaries
├── PLAN.md                           Migration plan, safety rules, and phase decisions
├── STATUS.md                         Completed work and current verification gate
├── display-manager-survey.md         Display-manager research and the SDDM decision
├── omadora-hyprland-uwsm.desktop     Additive Omadora Wayland session entry
├── manifests/                        Reviewed Fedora package manifests
├── omadora-launcher/                 Tracked launcher source and user deployer
├── helpers/                          Handy shell-hotkey and UX helpers, plus their deploy command
├── scripts/                          Root deployment and standalone maintenance scripts
├── Makefile                          Unified deployment and validation entry point
├── assets/                           Version-controlled assets/templates deployed by helpers
├── docs/                             Design records, acceptance checks, and this guide
├── upstream/                         Ignored pinned Omarchy reference checkout
├── logs/                             Ignored command/test evidence
└── backups/                          Ignored local configuration archives and snapshots
```

## Tracked areas

### `docs/`

| File | Purpose |
| --- | --- |
| `ACCEPTANCE.md` | Manual acceptance checklist for a fresh Hyprland login. |
| `FEATURE-PORT.md` | Selective Quickshell and interaction-port backlog. |
| `STRUCTURE.md` | This repository map and ownership guide. |

### `manifests/`

Reviewed package lists used during the staged Fedora setup. They describe package intent; they are not unattended installation scripts.

### `helpers/`

Helpers are the executable, maintained integration surface. They provide handy shell-hotkey and UX behavior, together with the deployment commands that install them on the machine:

| Script | Role |
| --- | --- |
| `omarchy-system-stats` | Fedora compatibility helper used by imported shell components. |
| `omadora-audio-output-volume` | PipeWire-native default-output volume helper; preserves the Quickshell OSD without requiring `pactl`. |
| `deploy.sh` | Validates or atomically installs all non-root helpers into `~/.local/bin`. |

Use `make deploy` to deploy non-root helpers and launcher files, then `sudo make deploy-root` for root-owned files. `make check` validates both parts without writing files.

### `scripts/`

Standalone maintenance and root-deployment scripts that are not shell-hotkey or UX helpers:

| Script | Role |
| --- | --- |
| `create-btrfs-snapshot.sh` | Creates the pre-change Btrfs safety snapshot. |
| `deploy-root.sh` | Root-only SDDM greeter deployer. It backs up the prior Omarchy theme/config before replacing it. |

### `omadora-launcher/`

The flattened launcher is maintained here rather than directly in the
untracked `~/.local/bin` directory. `deploy.sh` validates and atomically
installs its command layer for the current user and deploys its tracked
Quickshell menu implementation into the selected shell checkout.

### `assets/`

Declarative inputs for helpers, not a copy of all installed system state.

- `assets/sddm/omadora/Main.qml` is the maintained SDDM template: wallpaper background, no Omarchy wordmark or lock icon, and the translucent white-outlined password field.
- `scripts/deploy-root.sh` combines this template with pinned upstream SDDM assets and a fetched 4K wallpaper at deployment time.

### Session entry

`omadora-hyprland-uwsm.desktop` defines **Omadora (Hyprland UWSM)** as an additive login-session choice. It is deliberately separate from Fedora's stock Hyprland entry.

## Deliberately untracked areas

| Path | Why it is ignored |
| --- | --- |
| `upstream/` | Pinned Omarchy checkout used as read-only reference material. |
| `logs/` | Machine-specific command output and verification evidence. |
| `backups/` | Large archives and Btrfs-related recovery material. |
| Active `~/.config` and `~/.local/bin` state | May contain private state and is intentionally not copied into this repository. |

The ignored upstream checkout is currently documented in `README.md` and `STATUS.md`; do not treat it as an install source or copy its Arch-specific system scripts blindly.

## Ownership boundaries

- **Fedora:** RPM packages, system services, `/etc` policy, boot, and base display-manager installation.
- **Omadora repository:** reviewed session entry, documentation, manifests, helpers, templates, and Fedora compatibility adapters.
- **Omarchy upstream:** attributed reference source for selected Quickshell/SDDM concepts and assets.
- **User state:** live Hyprland, Quickshell, browser, and personal configuration under the home directory.

When adding work, place durable documentation in `docs/`, handy shell-hotkey or UX helpers in `helpers/`, deployable static inputs in `assets/`, and do not commit secrets, local logs, backups, or the upstream checkout.
