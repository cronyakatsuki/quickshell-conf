import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs.services

Scope {
  PanelWindow {
    id: volumeOsd

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio.volume ?? 0
    readonly property bool muted: sink?.audio.muted ?? false
    property bool armed: false

    PwObjectTracker {
      objects: [volumeOsd.sink]
    }
    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
      // top: true
      left: true
      right: true
      bottom: true
    }
    margins {
      bottom: 500
    }

    Timer {
      interval: 500
      running: true
      onTriggered: volumeOsd.armed = true
    }

    Timer {
      id: hideTimer
      interval: 1500
      onTriggered: volumeOsd.visible = false
    }

    onVolumeChanged: {
      if (!volumeOsd.armed)
        return;
      volumeOsd.visible = true;
      hideTimer.restart();
    }
    onMutedChanged: {
      if (!volumeOsd.armed)
        return;
      volumeOsd.visible = true;
      hideTimer.restart();
    }

    mask: Region {
      item: box
    }

    Rectangle {
      id: box
      anchors.horizontalCenter: parent.horizontalCenter
      implicitWidth: row.implicitWidth + 40
      implicitHeight: row.implicitHeight + 30
      radius: 12
      color: Theme.base
      border.color: Theme.lavender
      border.width: 2

      RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 10
        Text {
          text: volumeOsd.muted ? "󰖁" : volumeOsd.volume > 0.66 ? "󰕾" : volumeOsd.volume > 0.33 ? "󰖀" : "󰕿"
          color: Theme.blue
          font.family: Theme.fontIcons
          font.pixelSize: 60
        }
        Text {
          text: Math.round(volumeOsd.volume * 100).toString().padStart(2, "0") + "%"
          color: Theme.text
          font.family: Theme.fontText
          font.pixelSize: Theme.fontSize + 20
          font.bold: true
          Layout.alignment: Qt.AlignVCenter
        }
      }
    }
  }
}
