import Quickshell.Hyprland
import QtQuick

Repeater {
  id: root
  model: 9

  readonly property var kanjiNumerals: ["一", "二", "三", "四", "五", "六", "七", "八", "九"]

  Text {
    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
    text: kanjiNumerals[index]
    color: isActive ? "#f5e0dc" : (ws ? "#cdd6f4" : "#45475a")

    font.family: "Noto Sans CJK JP"
    font.pixelSize: 16
    font.bold: true

    MouseArea {
      anchors.fill: parent
      onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")
    }
  }
}
