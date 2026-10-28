import Quickshell
import QtQuick.Layouts
import "widgets"

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      // anchor the bar to the top of the screen
      anchors {
        top: true
        left: true
        right: true
      }

      // set size to 30
      implicitHeight: 30

      // chage background bg
      color: "#181825"

      RowLayout {
        id: left
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 6
        spacing: 14
        Workspaces {}
        ActiveWindow {}
      }

      RowLayout {
        id: middle
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        spacing: 14
        Media {}
      }

      RowLayout {
        id: right
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 6
        spacing: 14
        CpuUsage {}
        CpuTemp {}
        MemoryUsage {}
        Gpu {}
        VolumeWidget {}
        Bluetooth {}
        ClockWidget {}
        SystemTrayWidget {}
      }
    }
  }
}
