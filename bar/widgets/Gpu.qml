import Quickshell.Io
import QtQuick

Item {
  id: root
  property real spacing: 4
  implicitWidth: icon.implicitWidth + value.implicitWidth + spacing
  implicitHeight: Math.max(icon.implicitHeight, value.implicitHeight)

  property real util: 0
  property real temp: 0

  Process {
    id: nvidia
    command: ["nvidia-smi", "--query-gpu=utilization.gpu,temperature.gpu", "--format=csv,noheader,nounits"]
    stdout: StdioCollector {
      onStreamFinished: {
        const [utilPct, tempC] = this.text.trim().split(", ");
        root.util = Number(utilPct);
        root.temp = Number(tempC);
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      nvidia.running = true;
    }
  }

  Text {
    id: icon
    text: "󰢮"
    color: "#cba6f7"
    font.family: "Symbols Nerd Font Mono"
    font.pixelSize: 17
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: value
    text: Math.round(root.util).toString().padStart(2, "0") + "%" + " " + Math.round(root.temp).toString().padStart(2, "0") + "°C"
    color: "#cba6f7"
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
    color: "#cba6f7"
    anchors.horizontalCenter: parent.horizontalCenter
    y: value.height - height
  }
}
