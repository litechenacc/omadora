import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
  id: root
  width: 640
  height: 480
  color: "#1a1b26"

  property string currentUser: userModel.lastUser
  property bool loginFailed: false
  property int sessionIndex: {
    for (var i = 0; i < sessionModel.rowCount(); i++) {
      var name = (sessionModel.data(sessionModel.index(i, 0), Qt.DisplayRole) || "").toString()
      if (name.indexOf("uwsm") !== -1)
        return i
    }
    return sessionModel.lastIndex
  }

  Connections {
    target: sddm
    function onLoginFailed() {
      root.loginFailed = true
      password.text = ""
      password.focus = true
    }
    function onLoginSucceeded() {
      root.loginFailed = false
    }
  }

  // Omadora: high-resolution greeter background; preserve the original dark
  // palette with a veil so the logo and password prompt remain legible.
  Image {
    anchors.fill: parent
    source: "background.jpg"
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
  }

  Rectangle {
    anchors.fill: parent
    color: "#1a1b26"
    opacity: 0.28
  }

  Column {
    anchors.centerIn: parent
    spacing: 40

    Row {
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 15

      Item {
        width: 258
        height: 36

        // Layered low-opacity outlines form a soft white halo without relying
        // on a graphics-effects module in the SDDM greeter.
        Rectangle {
          x: -6; y: -6
          width: parent.width + 12; height: parent.height + 12
          radius: 10; color: "transparent"
          border.width: 2; border.color: "#ffffff"; opacity: 0.05
        }
        Rectangle {
          x: -3; y: -3
          width: parent.width + 6; height: parent.height + 6
          radius: 7; color: "transparent"
          border.width: 2; border.color: "#ffffff"; opacity: 0.12
        }
        Rectangle {
          x: -1; y: -1
          width: parent.width + 2; height: parent.height + 2
          radius: 6; color: "transparent"
          border.width: 2; border.color: "#ffffff"; opacity: 0.20
        }

        Rectangle {
          id: entry
          anchors.fill: parent
          radius: 5
          color: root.loginFailed ? "#5a2736" : "#171923"
          opacity: root.loginFailed ? 0.68 : 0.52
          border.width: 1
          border.color: root.loginFailed ? "#ffd5df" : "#ffffff"
        }

        Row {
          anchors.left: parent.left
          anchors.leftMargin: 16
          anchors.verticalCenter: parent.verticalCenter
          spacing: 4
          Repeater {
            model: Math.min(password.text.length, 21)
            Text {
              text: "•"
              color: "#ffffff"
              font.family: "JetBrainsMono Nerd Font"
              font.pixelSize: 18
            }
          }
        }

        TextInput {
          id: password
          anchors.fill: parent
          anchors.leftMargin: 16
          anchors.rightMargin: 16
          verticalAlignment: TextInput.AlignVCenter
          echoMode: TextInput.Password
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 18
          passwordCharacter: "\u2022"
          color: "transparent"
          selectionColor: "transparent"
          selectedTextColor: "transparent"
          cursorDelegate: Item {}
          focus: true
          onTextChanged: root.loginFailed = false
          Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
              sddm.login(root.currentUser, password.text, root.sessionIndex)
              event.accepted = true
            }
          }
        }
      }

    }

  }

  Component.onCompleted: password.forceActiveFocus()
}
