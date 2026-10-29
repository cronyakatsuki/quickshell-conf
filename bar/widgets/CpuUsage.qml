import QtQuick
import Quickshell.Io
import qs.services

Item {
  id: root

  implicitWidth: widget.implicitWidth
  implicitHeight: widget.implicitHeight

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

  FileView {
    id: stat
    path: "/proc/stat"
    blockLoading: true   // read synchronously, no stale-then-update flicker
    preload: false
    printErrors: false
    onLoaded: root.update()
  }

  Widget {
    id: widget
    glyph: "󰻠"
    label: Math.round(root.usage * 100).toString().padStart(2, "0") + "%"
    accent: Theme.green
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
}
