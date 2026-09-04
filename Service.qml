import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root
  property var shell: null
  property var manifest: null
  readonly property string pluginDir: manifest && manifest.__sourceDir
    ? manifest.__sourceDir
    : Quickshell.env("HOME") + "/.config/omarchy/plugins/io.github.tbogard.horizon-input"
  property bool ready: false
  property bool active: false
  property bool busy: false
  property string diagnosticLog: "Loading diagnostic log…"
  property string message: ready ? (active
    ? "Omarchy shortcuts are paused. Horizon receives Alt+Tab and Super shortcuts."
    : "Omarchy shortcuts are active.") : "Preparing Horizon input mode…"

  readonly property string submapName: "horizon-vdi"
  function setActive(enabled) {
    if (!ready || busy) return
    busy = true
    modeCommand.command = [pluginDir + "/scripts/input-mode", enabled ? "on" : "off"]
    modeCommand.running = true
  }

  function refresh() {
    if (!statusQuery.running) {
      statusQuery.command = ["hyprctl", "submap"]
      statusQuery.running = true
    }
    if (!logQuery.running) {
      logQuery.command = [pluginDir + "/scripts/input-mode", "log"]
      logQuery.running = true
    }
  }

  Timer {
    interval: 1000
    running: root.ready
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Process {
    id: setupCommand
    command: [root.pluginDir + "/scripts/input-mode", "setup"]
    onExited: function(exitCode) {
      root.ready = exitCode === 0
      if (root.ready) root.refresh()
      else root.message = "Could not register the Horizon input mode."
    }
  }

  Process {
    id: modeCommand
    command: []
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: if (String(text).trim() !== "") root.message = String(text).trim()
    }
    stderr: StdioCollector {
      waitForEnd: true
      onStreamFinished: if (String(text).trim() !== "") root.message = String(text).trim()
    }
    onExited: function(exitCode) {
      if (exitCode !== 0 && root.message === "") root.message = "Hyprland rejected the input-mode change."
      statusQuery.command = ["hyprctl", "submap"]
      statusQuery.running = true
    }
  }

  Process {
    id: statusQuery
    command: []
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        root.active = String(text || "").trim() === root.submapName
        root.busy = false
      }
    }
    onExited: function(exitCode) {
      if (exitCode !== 0) {
        root.busy = false
        root.message = "Could not read the active Hyprland keymap."
      }
    }
  }

  Process {
    id: logQuery
    command: []
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.diagnosticLog = String(text || "").trim()
    }
  }

  Component.onCompleted: setupCommand.running = true
  Component.onDestruction: {
    if (active) Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.submap(\"reset\")"])
  }
}
