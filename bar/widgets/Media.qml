import QtQuick
import Quickshell.Services.Mpris

Item {
  id: root

  property real spacing: 4
  implicitWidth: icon.implicitWidth + value.implicitWidth + spacing
  implicitHeight: Math.max(icon.implicitHeight, value.implicitHeight)

  readonly property MprisPlayer player: {
    const playing = Mpris.players.values.find(p => p.isPlaying);
    return playing ?? Mpris.players.values[0] ?? null;
  }

  readonly property string title: player?.trackTitle ?? ""
  readonly property string artist: player?.trackArtists?.join(", ") ?? ""

  Text {
    id: icon
    text: ""
    visible: root?.title
    color: "#f5c2e7"
    font.family: "Symbols Nerd Font Mono"
    font.pixelSize: 16
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: value
    text: {
      const label = root.artist ? `${root.artist} - ${root.title}` : root.title;
      return label.length > 40 ? label.slice(0, 37) + "…" : label;
    }
    color: "#f5c2e7"
    font.family: "Monaspace Neon Frozen"
    font.pixelSize: 16
    font.bold: true
    anchors.left: icon.right
    anchors.leftMargin: root.spacing
    anchors.verticalCenter: parent.verticalCenter
  }

  MouseArea {
    id: buttonArea
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    readonly property bool canTogglePlaying: root.player?.canTogglePlaying ?? false
    onClicked: mouse => {
      if (mouse.button !== Qt.RightButton)
        return;
      if (canTogglePlaying)
        root.player?.togglePlaying();
    }
  }
}
