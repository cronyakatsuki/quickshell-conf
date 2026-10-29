import QtQuick
import Quickshell.Services.Pipewire
import qs.services

Item {
  id: root
  implicitWidth: widget.implicitWidth
  implicitHeight: widget.implicitHeight

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property real volume: sink?.audio.volume ?? 0
  readonly property bool muted: sink?.audio.muted ?? false

  PwObjectTracker {
    objects: [root.sink]
  }

  Widget {
    id: widget
    glyph: root.muted ? "󰖁" : root.volume > 0.66 ? "󰕾" : root.volume > 0.33 ? "󰖀" : "󰕿"
    label: Math.round(root.volume * 100).toString().padStart(2, "0") + "%"
    accent: Theme.teal
  }

  MouseArea {
    id: buttonArea
    anchors.fill: parent
    onClicked: popup.visible = !popup.visible
  }

  VolumePanel {
    id: popup
  }
}
