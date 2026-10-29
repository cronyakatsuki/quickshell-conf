import QtQuick
import qs.services

Item {
  id: root
  property string glyph: ""
  property string label: ""
  property color accent: "#ff0000"
  property bool showUnderline: true
  property real spacing: 4

  implicitWidth: icon.implicitWidth + value.implicitWidth + (label !== "" ? spacing : 0)
  implicitHeight: Math.max(icon.implicitHeight, value.implicitHeight)

  Text {
    id: icon
    text: root.glyph
    color: root.accent
    visible: root.glyph !== ""
    font.family: Theme.fontIcons
    font.pixelSize: Theme.iconSize
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: value
    text: root.label
    color: root.accent
    font.family: Theme.fontText
    font.pixelSize: Theme.fontSize
    font.bold: true
    anchors.left: icon.right
    anchors.leftMargin: root.spacing
    anchors.verticalCenter: parent.verticalCenter
  }

  Rectangle {
    // underline: width = the whole shell, color = accent
    width: root.implicitWidth
    height: 2
    visible: root.showUnderline
    color: root.accent
    anchors.horizontalCenter: parent.horizontalCenter
    y: value.height - height
  }
}
