# Horizon VDI Input Mode

An Omarchy bar plugin with a manual input-mode toggle for Omnissa Horizon.
When enabled, shortcuts such as `Alt+Tab` and `Super` combinations reach the
Windows VDI instead of being handled by Omarchy.

Click the Horizon logo in the bar and turn on **Horizon Input Mode** before
working in a remote desktop. Turn it off to restore Omarchy shortcuts. The
toggle works independently of Horizon and does not inspect open windows.

Use `Super+Ctrl+Escape` as an emergency local unlock. After an emergency
unlock. The toggle always reads the active Hyprland submap, so its displayed
state reflects the compositor rather than a cached request.

## Install

Place this directory at:

`~/.config/omarchy/plugins/io.github.tbogard.horizon-input`

Then enable it:

```sh
omarchy plugin enable io.github.tbogard.horizon-input --section right
```

## Uninstall

```sh
omarchy plugin disable io.github.tbogard.horizon-input
```

Then remove the plugin directory.
