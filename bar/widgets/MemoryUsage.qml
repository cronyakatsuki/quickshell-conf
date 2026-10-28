import QtQuick
import Quickshell.Io

Item {
  id: root
  property real spacing: 4
  implicitWidth: icon.implicitWidth + value.implicitWidth + spacing
  implicitHeight: Math.max(icon.implicitHeight, value.implicitHeight)

  property real usage: 0

  FileView {
    id: stat
    path: "/proc/meminfo"
    blockLoading: true
    preload: true
    printErrors: false
    onLoaded: {
      let total = 0, avail = 0;
      for (const line of stat.text().split("\n")) {
        const m = line.match(/^(MemTotal|MemAvailable):\s+(\d+)/);
        if (!m)
          continue;
        if (m[1] === "MemTotal")
          total = Number(m[2]);
        else
          avail = Number(m[2]);
      }
      root.usage = total > 0 ? (1 - avail / total) : 0;
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: stat.reload()
  }

  Text {
    id: icon
    text: "󰍛"
    color: "#89b4fa"
    font.family: "Symbols Nerd Font Mono"
    font.pixelSize: 16
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: value
    text: Math.round(root.usage * 100).toString().padStart(2, "0") + "%"
    color: "#89b4fa"
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
    color: "#89b4fa"
    anchors.horizontalCenter: parent.horizontalCenter
    y: value.height - height
  }
}
