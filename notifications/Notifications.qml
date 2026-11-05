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

          delegate: NotificationCard {
            id: listCard
            cardImage: image
            cardAppIcon: appIcon
            cardSummary: summary
            cardBody: body
            cardAppName: appName
            cardTime: time
            cardBorder: Theme.lavender
            cardBg: Theme.crust
            notificationWidth: historyList.width

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
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    ColumnLayout {
      id: column
      width: parent.width
      spacing: 14

      Repeater {
        model: server.trackedNotifications

        delegate: NotificationCard {
          id: singleNotification
          required property var modelData

          notificationWidth: column.width
          cardImage: modelData.image
          cardAppIcon: modelData.appIcon
          cardSummary: modelData.summary
          cardBody: modelData.body
          cardAppName: modelData.appName
          cardTime: Qt.formatDateTime(new Date(), "HH:mm")
          cardBg: Theme.base
          cardBorder: modelData.urgency === NotificationUrgency.Critical ? Theme.red : Theme.lavender

          Timer {
            running: singleNotification.modelData.urgency !== NotificationUrgency.Critical
            interval: 5000
            onTriggered: singleNotification.modelData.dismiss()
          }

          MouseArea {
            anchors.fill: parent
            onClicked: singleNotification.modelData.dismiss()
          }
        }
      }
    }
  }
}
