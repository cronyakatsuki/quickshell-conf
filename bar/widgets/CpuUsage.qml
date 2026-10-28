import QtQuick
import Quickshell.Io

Item {
  id: root
  property real spacing: 4
  implicitWidth: icon.implicitWidth + value.implicitWidth + spacing
  implicitHeight: Math.max(icon.implicitHeight, value.implicitHeight)

  property real usage: 0

  // state between ticks (not bindings, just numbers)
  property real prevTotal: 0
  property real prevIdle: 0

  function update() {
    const lines = stat.text().split("\n");
    if (!lines.length || !lines[0].startsWith("cpu "))
      return;

    // user nice system idle iowait irq softirq steal ...
    const v = lines[0].trim().split(/\s+/).slice(1).map(Number);
    const total = v.reduce((a, b) => a + b);
    const idle = (v[3] || 0) + (v[4] || 0); // idle + iowait

    const dTotal = total - prevTotal;
    if (prevTotal >= 0 && dTotal > 0) {
      usage = 1 - (idle - prevIdle) / dTotal;
    }
    prevTotal = total;
    prevIdle = idle;
  }

  Text {
    id: icon
    text: "󰻠"
    color: "#a6e3a1"
    font.family: "Symbols Nerd Font Mono"
    font.pixelSize: 16
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: value
    text: Math.round(root.usage * 100).toString().padStart(2, "0") + "%"
    color: "#a6e3a1"
    font.family: "Monaspace Neon Frozen"
    font.pixelSize: 16
    font.bold: true
    anchors.left: icon.right
    anchors.leftMargin: root.spacing
    anchors.verticalCenter: parent.verticalCenter
  }

  FileView {
    id: stat
    path: "/proc/stat"
    blockLoading: true   // read synchronously, no stale-then-update flicker
    preload: false
    printErrors: false
    onLoaded: root.update()
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      stat.reload();          // re-reads /proc/stat → onLoaded fires → update()
      if (root.prevTotal === 0)
        root.update();  // prime the baseline on first tick
    }
  }

  Rectangle {
    width: root.implicitWidth
    height: 2
    color: "#a6e3a1"
    anchors.horizontalCenter: parent.horizontalCenter
    y: value.height - height
  }
}
