# Omadora launcher

This directory is the tracked source and deployment unit for the flattened
Omadora launcher. It replaces the untracked copies formerly maintained under
`~/.local/bin`.

## Components

- `bin/omadora-launcher` — builds searchable app/action entries and dispatches
  the selected item.
- `bin/omadora-shell` — Omadora-owned Quickshell IPC bridge; it reads the
  deployment-created launcher path fallback when UWSM did not export one.
- `bin/omadora-menu-select` — synchronous selector bridge to the existing
  Quickshell `omarchy.menu` plugin, including an optional initial query, safe
  second-press toggle, and structured app rows that retain desktop icons.
- `bin/omadora-menu-input` — free-form input bridge used by calculator and
  command actions; calculator input has a live, safe arithmetic preview.
- In the flattened launcher, type `g`, then `Tab`, enter a query and press
  Enter to open its Google search in Helium.
- `qml/Menu.qml` — tracked Omadora menu implementation, including launcher
  modes, icons, calculator, and bookmark behavior.
- `tools/apply-menu-initial-query.py` — validates and deploys that managed QML
  into the selected shell checkout.
- `bin/omadora-launcher-toggle` — low-latency binding entry point: dismisses
  an already-open menu without rebuilding launcher rows.
- `bin/omadora-system-logout` — user-session logout action.
- `bin/omadora-open-url` — opens URLs through XDG and focuses Helium.
- `deploy.sh` — validates and atomically installs those commands for the
  current user.

The UI remains the enabled Quickshell menu plugin. The `omarchy.menu` plugin id
is an upstream compatibility interface; all launcher-side scripts that call it
are maintained in this directory.

## Deploy

```bash
cd omadora-launcher
./deploy.sh --check
./deploy.sh
```

By default commands install to `~/.local/bin`. On first deployment it also
creates `~/.config/omadora/launcher.env`, pointing at the sibling repository
`upstream/omarchy` checkout. For another location, deploy explicitly:

```bash
./deploy.sh --omarchy-path /path/to/omarchy
```

To inspect without changes:

```bash
./deploy.sh --dry-run
```

For a test destination, use `./deploy.sh --dest /path/to/bin`.

## Activation

The live Hyprland bindings in `~/.config/hypr/hyprland.lua` invoke
`omadora-launcher-toggle` for Super+Space and
`omadora-launcher-toggle --query 'System: '` for Super+Escape. Deployment takes effect immediately for new launcher invocations;
reload Hyprland after changing the binding file itself.

## Boundaries

This directory manages every launcher-side script and its deployment. It does
not bundle the Omarchy Quickshell shell itself: a new machine must have the
pinned `upstream/omarchy` checkout and Quickshell available. Deployment installs the tracked Omadora menu implementation into that shell
checkout; it
does not alter Fedora system configuration or login/session setup.
