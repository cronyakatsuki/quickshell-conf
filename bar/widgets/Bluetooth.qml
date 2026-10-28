import QtQuick
import Quickshell.Bluetooth

Item {
  id: root

  property real spacing: 4
  implicitWidth: icon.implicitWidth + value.implicitWidth + spacing
  implicitHeight: Math.max(icon.implicitHeight, value.implicitHeight)

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property bool enabled: adapter?.enabled ?? false
  readonly property list<BluetoothDevice> devices: adapter?.devices?.values ?? []
  readonly property bool deviceConnected: devices.some(d => d.connected)
  readonly property int connectedCount: devices.filter(d => d.connected).length

  Text {
    id: icon
    text: root.deviceConnected ? "󰂱" : root.enabled ? "󰂯" : "󰂲"
    color: "#89dceb"
    font.family: "Symbols Nerd Font Mono"
    font.pixelSize: 16
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: value
    text: root.connectedCount > 0 ? root.connectedCount.toString() : ""
    visible: root.connectedCount > 0
    color: "#89dceb"
    font.family: "Monaspace Neon Frozen"
    font.pixelSize: 16
    font.bold: true
    anchors.left: icon.right
    anchors.leftMargin: root.spacing
    anchors.verticalCenter: parent.verticalCenter
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

  Rectangle {
    width: root.implicitWidth
    height: 2
    color: "#89dceb"
    anchors.horizontalCenter: parent.horizontalCenter
    y: value.height - height
  }
}
