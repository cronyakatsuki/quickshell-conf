import QtQuick
import qs.services

Text {
  id: root
  text: Time.time
  color: "#b4befe"
  font.family: "Monaspace Neon Frozen"
  font.pixelSize: 16
  font.bold: true

  property real underlineThickness: 2

  Rectangle {
    width: root.implicitWidth
    height: root.underlineThickness
    color: root.color
    anchors.horizontalCenter: parent.horizontalCenter
    y: root.height - height
  }
}
