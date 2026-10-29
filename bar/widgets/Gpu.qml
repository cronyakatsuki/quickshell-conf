import Quickshell.Io
import QtQuick
import qs.services

Item {
  id: root

  implicitWidth: widget.implicitWidth
  implicitHeight: widget.implicitHeight

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

  Widget {
    id: widget
    glyph: "󰢮"
    label: Math.round(root.util).toString().padStart(2, "0") + "%" + " " + Math.round(root.temp).toString().padStart(2, "0") + "°C"
    accent: Theme.mauve
  }
}
