import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.services

PopupWindow {
  color: "transparent"

  visible: false
  implicitWidth: 280
  implicitHeight: content.implicitHeight + 2 * content.anchors.margins
  anchor {
    item: buttonArea
    edges: Edges.Bottom
    gravity: Edges.Bottom
  }

  Rectangle {
    id: root
    color: Theme.base
    border.width: 2
    border.color: Theme.overlay0

    anchors.fill: parent
    radius: 12

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio.volume ?? 0

    readonly property list<PwNode> outputNodes: {
      const nodes = Pipewire.nodes.values.filter(n => n.isSink && !n.isStream);
      return nodes;
    }

    ColumnLayout {
      id: content
      anchors.fill: parent
      anchors.margins: 20
      spacing: 5
      ComboBox {
        id: outputBox
        Layout.fillWidth: true
        model: root.outputNodes
        textRole: "description"
        currentIndex: root.outputNodes.findIndex(n => n === root.sink)
        onActivated: index => Pipewire.preferredDefaultAudioSink = root.outputNodes[index]
      }

      Slider {
        id: outputSlider
        Layout.fillWidth: true
        from: 0
        to: 1
        value: root.volume
        onMoved: root.sink.audio.volume = value
      }
    }
  }
}
