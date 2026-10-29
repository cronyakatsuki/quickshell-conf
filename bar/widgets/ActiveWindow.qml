import Quickshell.Wayland
import QtQuick
import qs.services

Text {
  id: title
  text: {
    const toplevel = ToplevelManager.activeToplevel;
    return toplevel ? toplevel.title : "";
  }

  color: Theme.lavender
  font.family: Theme.fontText
  font.pixelSize: Theme.fontSize
  font.bold: true
}
