import QtQuick
import Quickshell
import Quickshell.Widgets

PopupWindow {
  id: popupRoot
  color: "#1e1e2e"

  anchor {
    item: buttonArea
    edges: Edges.Bottom
    gravity: Edges.Bottom
  }

  visible: false
  implicitWidth: 280
  implicitHeight: 320
}
