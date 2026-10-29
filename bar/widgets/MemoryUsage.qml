import QtQuick
import Quickshell.Io
import qs.services

Item {
  id: root
  implicitWidth: widget.implicitWidth
  implicitHeight: widget.implicitHeight

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

  Widget {
    id: widget
    glyph: "󰍛"
    label: Math.round(root.usage * 100).toString().padStart(2, "0") + "%"
    accent: Theme.blue
  }
}
