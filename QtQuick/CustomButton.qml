import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    width: 25
    height: 25
    Text { text: "*"; color: "white"; font.pixelSize: 16; anchors.centerIn: parent}

    property int lives: Math.floor(Math.random() * 2) + 1
    property bool containsMouse: hovered

    background: Rectangle {
        color: "black"
    }

    onClicked: {
        lives--;
        if (lives <= 0) {
            destroy();
        }
    }
}
