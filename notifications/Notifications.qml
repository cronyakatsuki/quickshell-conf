import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.services

Scope {
  id: root
  property bool centerOpen: false

  ListModel {
    id: history
  }

  NotificationServer {
    id: server
    actionsSupported: true
    bodySupported: true
    imageSupported: true

    onNotification: n => {
      n.tracked = true;
      history.insert(0, {
        summary: n.summary,
        body: n.body,
        appName: n.appName,
        urgency: n.urgency,
        image: n.image,
        appIcon: n.appIcon,
        time: Qt.formatDateTime(new Date(), "HH:mm")
      });
    }
  }

  IpcHandler {
    target: "notifications"
    function toggle(): void {
      root.centerOpen = !root.centerOpen;
    }
    function show(): void {
      root.centerOpen = true;
    }
    function hide(): void {
      root.centerOpen = false;
    }
  }

  // Notification Center
  PanelWindow {
    visible: root.centerOpen
    anchors {
      top: true
      right: true
    }
    margins {
      top: 12
      right: 12
    }

    implicitWidth: 380
    implicitHeight: centerCol.implicitHeight + 24
    // color: Theme.base
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    Rectangle {
      anchors.fill: parent
      radius: 10
      color: Theme.base
      border.width: 2
      border.color: Theme.lavender

      ColumnLayout {
        id: centerCol
        anchors.fill: parent
        anchors.margins: 12
        spacing: 14

        RowLayout {
          Layout.fillWidth: true
          Text {
            Layout.fillWidth: true
            text: "Notifications"
            color: Theme.text
            font.family: Theme.fontText
            font.bold: true
            font.pixelSize: Theme.fontSize + 2
          }

          Text {
            text: "Clear All"
            visible: history.count > 0
            color: Theme.red
            font.family: Theme.fontText
            font.pixelSize: Theme.fontSize - 1
            MouseArea {
              anchors.fill: parent
              onClicked: history.clear()
            }
          }
        }
        ListView {
          id: historyList
          model: history
          clip: true
          spacing: 10
          Layout.fillWidth: true
          Layout.preferredHeight: Math.min(Math.max(contentHeight, 1), 500)

          delegate: Rectangle {
            id: card
            required property string summary
            required property string body
            required property string appName
            required property string time
            required property string image
            required property string appIcon
            required property int index

            width: historyList.width
            height: cardLayout.implicitHeight + 20
            radius: 8
            color: Theme.crust
            border.width: 2
            border.color: Theme.lavender

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
                source: image || appIcon || ""
              }

              ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                  Layout.fillWidth: true
                  text: summary
                  color: Theme.peach
                  font.family: Theme.fontText
                  font.pixelSize: Theme.fontSize
                  font.bold: true
                  elide: Text.ElideRight
                }
                Text {
                  Layout.fillWidth: true
                  visible: text !== ""
                  text: body
                  color: Theme.text
                  font.family: Theme.fontText
                  font.pixelSize: Theme.fontSize - 1
                  font.bold: false
                  wrapMode: Text.WordWrap
                }
                Text {
                  Layout.fillWidth: true
                  text: appName
                  color: Theme.surface2
                  font.family: Theme.fontText
                  font.pixelSize: Theme.fontSize - 1
                  font.bold: false
                  wrapMode: Text.WordWrap
                }
              }

              Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                text: time
                color: Theme.surface2
                font.family: Theme.fontText
                font.pixelSize: Theme.fontSize - 1
                font.bold: false
              }
            }

            MouseArea {
              anchors.fill: parent
              onClicked: history.remove(index)
            }
          }
        }
      }
    }
  }

  // Single notification
  PanelWindow {
    anchors {
      top: true
      right: true
    }
    margins {
      top: 12
      right: 12
    }

    implicitWidth: 380
    implicitHeight: Math.max(1, column.implicitHeight)
    // color: Theme.base
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    ColumnLayout {
      id: column
      width: parent.width
      spacing: 14

      Repeater {
        model: server.trackedNotifications

        delegate: Rectangle {
          id: card
          required property var modelData

          Timer {
            running: card.modelData.urgency !== NotificationUrgency.Critical
            interval: 5000
            onTriggered: card.modelData.dismiss()
          }

          Layout.fillWidth: true
          Layout.preferredHeight: layout.implicitHeight + 20
          radius: 8
          color: Theme.base
          border.width: 2
          border.color: modelData.urgency === NotificationUrgency.Critical ? Theme.red : Theme.lavender

          RowLayout {
            id: layout
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Image {
              Layout.preferredHeight: 36
              Layout.preferredWidth: 36
              Layout.alignment: Qt.AlignTop
              fillMode: Image.PreserveAspectFit
              visible: source.toString() !== ""
              source: card.modelData.image || card.modelData.appIcon || ""
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 2

              Text {
                Layout.fillWidth: true
                text: card.modelData.summary
                color: Theme.peach
                font.family: Theme.fontText
                font.pixelSize: Theme.fontSize
                font.bold: true
                elide: Text.ElideRight
              }
              Text {
                Layout.fillWidth: true
                visible: text !== ""
                text: card.modelData.body
                color: Theme.text
                font.family: Theme.fontText
                font.pixelSize: Theme.fontSize - 1
                font.bold: false
                wrapMode: Text.WordWrap
              }
              Text {
                Layout.fillWidth: true
                text: card.modelData.appName
                color: Theme.surface2
                font.family: Theme.fontText
                font.pixelSize: Theme.fontSize - 1
                font.bold: false
                wrapMode: Text.WordWrap
              }
            }

            Text {
              Layout.fillWidth: true
              Layout.alignment: Qt.AlignTop
              text: Qt.formatDateTime(new Date(), "HH:mm")
              color: Theme.surface2
              font.family: Theme.fontText
              font.pixelSize: Theme.fontSize - 1
              font.bold: false
            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: card.modelData.dismiss()
          }
        }
      }
    }
  }
}
