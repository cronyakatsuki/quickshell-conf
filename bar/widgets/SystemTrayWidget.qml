import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick.Layouts
import Quickshell

RowLayout {
  id: root
  spacing: 6

  property var handle

  Repeater {
    model: SystemTray.items

    IconImage {
      id: icon
      required property SystemTrayItem modelData
      source: modelData.icon
      implicitSize: 16

      MouseArea {
        id: buttonArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
          if (icon.modelData.onlyMenu || (mouse.button === Qt.RightButton && icon.modelData.hasMenu)) {
            menu.anchor.item = icon;
            menu.menu = icon.modelData.menu;
            menu.open();
            return;
          }
          if (mouse.button === Qt.LeftButton) {
            icon.modelData.activate();
            return;
          }
          icon.modelData.secondaryActivate();
        }
      }
    }
  }

  QsMenuAnchor {
    id: menu
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
  }
}
