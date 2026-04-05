import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: mainWindow
    width: 800
    height: 600
    visible: true
    title: "WidgetMovement"

    property var buttons: []
    property var buttonComponent: null

    Component.onCompleted: {
        buttonComponent = Qt.createComponent("CustomButton.qml")
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: "white"
    }

    Timer {
        id: createTimer
        interval: 100 + Math.floor(Math.random() * 900)
        running: true
        repeat: true
        onTriggered: {
            var button = buttonComponent.createObject(mainWindow)

            var maxX = mainWindow.width - 25
            var randomX = Math.floor(Math.random() * maxX)
            button.x = randomX
            var maxY = 100 - 25
            button.y = Math.floor(Math.random() * maxY)

            buttons.push(button)

            var nextInterval = 100 + Math.floor(Math.random() * 900)
            createTimer.interval = nextInterval
        }
    }

    Timer {
        id: moveTimer
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            for (var i = buttons.length - 1; i >= 0; i--) {
                var button = buttons[i]
                if (!button || button.destroyed) {
                    buttons.splice(i, 1)
                    continue
                }

                var speed = Math.floor(Math.random() * 4) + 1
                if (button.containsMouse) {
                    button.y += 2 * speed
                }
                else {
                    button.y += speed
                }

                if (button.y + button.height >= mainWindow.height) {
                    button.destroy()
                    buttons.splice(i, 1)
                    mainWindow.title = "YOU LOOSE!"
                    backgroundRect.color = "red"
                }
            }
        }
    }

    Component.onDestruction: {
        for (var i = 0; i < buttons.length; i++) {
            if (buttons[i]) buttons[i].destroy()
        }
        buttons = []
    }
}
