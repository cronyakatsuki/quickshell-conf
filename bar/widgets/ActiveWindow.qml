import Quickshell.Wayland
import QtQuick

Text {
  id: title
  text: {
    const toplevel = ToplevelManager.activeToplevel;
    return toplevel ? toplevel.title : "";
  }
  color: "#b4befe"
  font.family: "Monaspace Neon Frozen"
  font.pixelSize: 16
  font.bold: true
}
