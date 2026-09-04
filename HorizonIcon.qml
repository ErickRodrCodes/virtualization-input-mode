import QtQuick
import Quickshell

Item {
  id: root
  property real iconSize: Math.min(width, height)
  property real iconOpacity: 1.0
  implicitWidth: iconSize
  implicitHeight: iconSize

  Image {
    anchors.centerIn: parent
    width: root.iconSize
    height: root.iconSize
    source: Qt.resolvedUrl("assets/horizon-client.svg")
    sourceSize.width: Math.round(width * Screen.devicePixelRatio)
    sourceSize.height: Math.round(height * Screen.devicePixelRatio)
    fillMode: Image.PreserveAspectFit
    opacity: root.iconOpacity
  }
}
