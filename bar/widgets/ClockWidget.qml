import QtQuick
import qs.services

Text {
  id: root
  text: Time.time
  color: Theme.lavender
  font.family: Theme.fontText
  font.pixelSize: Theme.fontSize
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
