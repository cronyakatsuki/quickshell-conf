import Quickshell.Wayland
import QtQuick
import qs.services

Text {
  id: title
  text: {
    const toplevel = ToplevelManager.activeToplevel;
    if (toplevel) {
      return toplevel.title.length > 50 ? toplevel.title.slice(0, 47) + "…" : toplevel.title;
    } else {
      return "";
    }
  }

  color: Theme.lavender
  font.family: Theme.fontText
  font.pixelSize: Theme.fontSize
  font.bold: true
}
