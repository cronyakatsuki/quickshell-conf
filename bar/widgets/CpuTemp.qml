import Quickshell.Io
import QtQuick
import qs.services

Item {
  id: root

  implicitWidth: widget.implicitWidth
  implicitHeight: widget.implicitHeight

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

  Widget {
    id: widget
    glyph: ""
    label: root.tempPath === "" ? "--°C" : Math.round(root.temp) + "°C"
    accent: Theme.peach
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
