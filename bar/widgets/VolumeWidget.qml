import QtQuick
import Quickshell.Services.Pipewire

Item {
  id: root
  property real spacing: 4
  implicitWidth: icon.implicitWidth + value.implicitWidth + spacing
  implicitHeight: Math.max(icon.implicitHeight, value.implicitHeight)

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property real volume: sink?.audio.volume ?? 0
  readonly property bool muted: sink?.audio.muted ?? false

  PwObjectTracker {
    objects: [root.sink]
  }

  Text {
    id: icon
    text: root.muted ? "󰖁" : root.volume > 0.66 ? "󰕾" : root.volume > 0.33 ? "󰖀" : "󰕿"
    color: "#94e2d5"
    font.family: "Symbols Nerd Font Mono"
    font.pixelSize: 16
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: value
    text: Math.round(root.volume * 100).toString().padStart(2, "0") + "%"
    color: "#94e2d5"
    font.family: "Monaspace Neon Frozen"
    font.pixelSize: 16
    font.bold: true
    anchors.left: icon.right
    anchors.leftMargin: root.spacing
    anchors.verticalCenter: parent.verticalCenter
  }

  MouseArea {
    id: buttonArea
    anchors.fill: parent
    onClicked: popup.visible = !popup.visible
  }
  VolumePanel { id: popup }

  Rectangle {
    width: root.implicitWidth
    height: 2
    color: "#94e2d5"
    anchors.horizontalCenter: parent.horizontalCenter
    y: value.height - height
  }
}
