# Hyprland acceptance checklist

Do not proceed to cleanup until every required test passes after a fresh login.

## Core session

- [x] Hyprland starts from the login manager.
- [x] A terminal starts.
- [x] `hyprlock` locks and unlocks successfully.
- [x] `hypridle` locks after its configured timeout.
- [ ] A privileged action shows a working polkit prompt.
- [ ] Logout returns to the login manager.

## Laptop controls

- [x] F1/F2/F3 mute, lower, and raise the default output volume.
- [x] F5/F6 lower and raise internal-display brightness.
- [ ] Media next/previous/play-pause work when a compatible player is active.
- [ ] Touchpad toggle and keyboard backlight work if supported by the hardware.

## Audio and devices

- [ ] PipeWire output volume changes correctly.
- [x] Default output switching works.
- [ ] Microphone mute works.
- [ ] Bluetooth headset audio works, if a headset is available.

## Displays and power

- [ ] Internal display has usable scale and refresh rate.
- [ ] External display connect/disconnect works.
- [ ] Lid close, suspend, wake, and unlock work.

## Desktop integration

- [x] Screenshot region works.
- [x] Clipboard copy/paste works.
- [ ] File chooser works in Helium.
- [ ] Helium screen sharing works.
- [ ] Notifications work.
- [ ] Quickshell has no duplicate bar, notification, or OSD process.
