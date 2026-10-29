import QtQuick
import Quickshell.Services.Mpris
import qs.services

Item {
  id: root

  implicitWidth: widget.implicitWidth
  implicitHeight: widget.implicitHeight

  readonly property MprisPlayer player: {
    const playing = Mpris.players.values.find(p => p.isPlaying);
    return playing ?? Mpris.players.values[0] ?? null;
  }

  readonly property string title: player?.trackTitle ?? ""
  readonly property string artist: player?.trackArtists?.join(", ") ?? ""

  Widget {
    id: widget
    glyph: root.title ? "" : ""
    label: {
      const label = root.artist ? `${root.artist} - ${root.title}` : root.title;
      return label.length > 40 ? label.slice(0, 37) + "…" : label;
    }
    accent: Theme.pink
    showUnderline: false
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
