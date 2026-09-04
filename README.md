# Horizon VDI Input Mode

An Omarchy service plugin that temporarily disables compositor keybindings
while an Omnissa Horizon remote desktop is open. This lets shortcuts such as
`Alt+Tab` and `Super` combinations reach the Windows VDI.

The Horizon launcher window does not activate the mode. Opening a remote
desktop activates the `horizon-vdi` Hyprland submap; closing the final remote
desktop restores Omarchy's default bindings.

Use `Super+Ctrl+Escape` as an emergency local unlock. After an emergency
unlock, input mode stays unlocked for that VDI session and activates again the
next time a VDI is opened.

The repository retains the official Horizon Client SVG as an asset for a
future UI, but this known-good baseline exposes no panel or widget.

## Install

Place this directory at:

`~/.config/omarchy/plugins/io.github.tbogard.horizon-input`

Then enable it:

```sh
omarchy plugin enable io.github.tbogard.horizon-input
```

## Uninstall

```sh
omarchy plugin disable io.github.tbogard.horizon-input
```

Then remove the plugin directory.
