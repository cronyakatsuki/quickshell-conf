import Quickshell.Io
import QtQuick

Item {
  id: root

  property real spacing: 4
  implicitWidth: icon.implicitWidth + value.implicitWidth + spacing
  implicitHeight: Math.max(icon.implicitHeight, value.implicitHeight)

  property string tempPath: ""
  property real temp: 0

  // Find which hwmon my current cpu is
  Process {
    id: discover
    command: ["sh", "-c", "d=$(dirname $(grep -l '^coretemp$' /sys/class/hwmon/hwmon*/name)); l=$(grep -l 'Package id 0' $d/temp*_label); echo ${l%_label}"]
    stdout: StdioCollector {
      onStreamFinished: root.tempPath = this.text.trim() + "_input"
    }
  }

  Component.onCompleted: discover.running = true

  FileView {
    id: stat
    path: root.tempPath
    blockLoading: true
    preload: true
    printErrors: true
    onLoaded: root.temp = parseFloat(stat.text()) / 1000
  }

  Text {
    id: icon
    text: ""
    color: "#fab387"
    font.family: "Symbols Nerd Font Mono"
    font.pixelSize: 16
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: value
    text: root.tempPath === "" ? "--°C" : Math.round(root.temp) + "°C"
    color: "#fab387"
    font.family: "Monaspace Neon Frozen"
    font.pixelSize: 16
    font.bold: true
    anchors.left: icon.right
    anchors.leftMargin: root.spacing
    anchors.verticalCenter: parent.verticalCenter
  }

  Rectangle {
    width: root.implicitWidth
    height: 2
    color: "#fab387"
    anchors.horizontalCenter: parent.horizontalCenter
    y: value.height - height
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      stat.reload();
    }
  }
}
