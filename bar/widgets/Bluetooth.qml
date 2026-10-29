import QtQuick
import Quickshell.Bluetooth
import qs.services

Item {
  id: root

  implicitWidth: widget.implicitWidth
  implicitHeight: widget.implicitHeight

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property bool enabled: adapter?.enabled ?? false
  readonly property list<BluetoothDevice> devices: adapter?.devices?.values ?? []
  readonly property bool deviceConnected: devices.some(d => d.connected)
  readonly property int connectedCount: devices.filter(d => d.connected).length

  Widget {
    id: widget
    glyph: root.deviceConnected ? "󰂱" : root.enabled ? "󰂯" : "󰂲"
    label: root.connectedCount > 0 ? root.connectedCount.toString() : ""
    accent: Theme.sky
  }

  MouseArea {
    id: buttonArea
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => {
      if (mouse.button !== Qt.RightButton)
        return;
      if (!root.adapter)
        return;
      root.adapter.enabled = !root.adapter.enabled;
    }
  }
}
