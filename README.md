# Virtualization Input Mode

An Omarchy bar plugin that temporarily yields compositor-level shortcuts to a
guest application. It is intended for virtual machines, VDIs, remote desktop
clients, nested compositors, game streaming, and any other application that
needs to receive combinations such as `Alt+Tab` or `Super`.

## Why it is needed

Omarchy implements its desktop shortcuts in Hyprland. Those global bindings
remain active while a VM or remote desktop has focus, so Hyprland consumes the
key combination before the guest can receive it. This is especially visible
with the `Super` key and `Alt+Tab`: instead of reaching the guest operating
system, they continue to control the local Omarchy desktop.

Virtualization Input Mode activates an otherwise empty Hyprland submap. While
that submap is active, the usual Omarchy bindings are not matched and the key
events can reach the focused application. Turning the mode off restores the
default Omarchy submap.

The toggle is fully manual and does not require a particular application or
open window. `Super+Ctrl+Escape` is always available inside the special submap
as an emergency way to restore Omarchy shortcuts.

The active submap survives an Omarchy shell restart. When the shell returns,
the plugin reads Hyprland's current submap and restores the toggle's displayed
state instead of resetting the user's choice.

## Optional status providers

The current plugin includes a separate, read-only Omnissa Horizon detector.
It reports whether a Horizon VDI window is open, but it never enables,
disables, or gates Virtualization Input Mode. Other virtualization detectors
can be added later without changing the toggle.

The current Horizon logo is temporary and will be replaced with a vendor-
neutral virtualization/input icon.

## Install

Place this directory at:

`~/.config/omarchy/plugins/io.github.tbogard.virtualization-input-mode`

Then enable it:

```sh
omarchy plugin enable io.github.tbogard.virtualization-input-mode --section right
```

## Diagnostics

Open **Diagnostic log** from the panel, or inspect:

`~/.local/state/virtualization-input-mode/activity.log`

## Uninstall

```sh
omarchy plugin disable io.github.tbogard.virtualization-input-mode
```

Then remove the plugin directory.
