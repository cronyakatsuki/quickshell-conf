import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
  id: card

  property real notificationWidth: 0
  property string cardImage: ""
  property string cardAppIcon: ""
  property string cardSummary: ""
  property string cardBody: ""
  property string cardAppName: ""
  property string cardTime: ""
  property string cardBg: ""
  property string cardBorder: ""

  width: notificationWidth
  implicitHeight: cardLayout.implicitHeight + 20
  height: implicitHeight
  radius: 8
  color: cardBg
  border.width: 2
  border.color: cardBorder

  RowLayout {
    id: cardLayout
    anchors.fill: parent
    anchors.margins: 10
    spacing: 10

    Image {
      Layout.preferredHeight: 36
      Layout.preferredWidth: 36
      Layout.alignment: Qt.AlignTop
      fillMode: Image.PreserveAspectFit
      visible: source.toString() !== ""
      source: card.cardImage || card.cardAppIcon || ""
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 2

      Text {
        Layout.fillWidth: true
        text: card.cardSummary
        color: Theme.peach
        font.family: Theme.fontText
        font.pixelSize: Theme.fontSize
        font.bold: true
        elide: Text.ElideRight
      }
      Text {
        Layout.fillWidth: true
        visible: text !== ""
        text: card.cardBody
        color: Theme.text
        font.family: Theme.fontText
        font.pixelSize: Theme.fontSize - 1
        font.bold: false
        wrapMode: Text.WordWrap
      }
      Text {
        Layout.fillWidth: true
        text: card.cardAppName
        color: Theme.surface2
        font.family: Theme.fontText
        font.pixelSize: Theme.fontSize - 1
        font.bold: false
        wrapMode: Text.WordWrap
      }
    }

    Text {
      Layout.alignment: Qt.AlignTop | Qt.AlignRight
      text: card.cardTime
      color: Theme.surface2
      font.family: Theme.fontText
      font.pixelSize: Theme.fontSize - 1
      font.bold: false
    }
  }
}
