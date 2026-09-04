import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  property var shell: null
  property var manifest: null
  property bool ready: false
  property bool vdiOpen: false
  property bool modeForced: false

  readonly property string submapName: "horizon-vdi"
  readonly property string setupExpression:
    "hl.define_submap(\"" + submapName + "\", function() "
    + "hl.bind(\"SUPER + CTRL + ESCAPE\", hl.dsp.submap(\"reset\"), "
    + "{ description = \"Emergency unlock Omarchy shortcuts\" }) end)"

  function checkForVdi() {
    if (!ready || clientQuery.running)
      return

    clientQuery.command = ["hyprctl", "clients", "-j"]
    clientQuery.running = true
  }

  function applyClientList(output) {
    var clients

    try {
      clients = JSON.parse(String(output || "[]"))
    } catch (error) {
      return
    }

    var found = clients.some(function(window) {
      return window.class === "Horizon-client"
        && window.title !== "Omnissa Horizon Client"
    })

    if (found === vdiOpen)
      return

    vdiOpen = found

    if (found) {
      modeCommand.command = [
        "hyprctl", "dispatch", "hl.dsp.submap(\"" + submapName + "\")"
      ]
      modeForced = true
    } else if (modeForced) {
      modeCommand.command = ["hyprctl", "dispatch", "hl.dsp.submap(\"reset\")"]
      modeForced = false
    } else {
      return
    }

    modeCommand.running = true
  }

  Timer {
    interval: 750
    running: root.ready
    repeat: true
    triggeredOnStart: true
    onTriggered: root.checkForVdi()
  }

  Process {
    id: setupCommand
    command: ["hyprctl", "repl", root.setupExpression]
    onExited: function(exitCode) {
      root.ready = exitCode === 0
      if (root.ready)
        root.checkForVdi()
    }
  }

  Process {
    id: clientQuery
    command: []
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.applyClientList(text)
    }
  }

  Process {
    id: modeCommand
    command: []
  }

  Component.onCompleted: setupCommand.running = true

  Component.onDestruction: {
    if (modeForced)
      Quickshell.execDetached([
        "hyprctl", "dispatch", "hl.dsp.submap(\"reset\")"
      ])
  }
}
