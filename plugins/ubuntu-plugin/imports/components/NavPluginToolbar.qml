import QtQuick 2.4
import Ubuntu.Components 1.3
import Dekko.Mail.Stores.Views 1.0

Panel {
    id: panel
    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }
    height: units.gu(6)

    InverseMouseArea {
        visible: panel.opened
        anchors.fill: parent
        onClicked: {
            if (panel.opened) {
                panel.close()
            }
        }
    }

    NavPluginModel {
        id: navModel
    }

    Rectangle {
        color: UbuntuColors.inkstone
        anchors.fill: parent
        // two properties used by the toolbar delegate:
        property bool opened: panel.opened
        property bool animating: panel.animating

        Line {
            id: line
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
            }
        }

        Row {
            anchors.fill: parent
            Repeater {
                model: navModel.plugins
                delegate: AbstractButton {
                    id: btn

                    readonly property bool isSelected: ViewStore.selectedNavIndex === index

                    action: modelData
                    height: panel.height
                    width: panel.width / 4
                    implicitHeight: height
                    visible: action.visible

                    onClicked: ViewStore.selectedNavIndex = index

                    Rectangle {
                        anchors.fill: parent
                        visible: btn.pressed
                        color: UbuntuColors.slate
                    }

                    Rectangle {
                        color: UbuntuColors.blue
                        width: units.dp(2)
                        anchors {
                            left: parent.left
                            top: parent.top
                            right: parent.right
                        }
                        visible: btn.isSelected
                    }

                    Icon {
                        name: action.iconName
                        color: btn.isSelected ? UbuntuColors.blue : UbuntuColors.silk
                        height: units.gu(3.4)
                        width: height
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

    QtObject {
        id: internal

        function peek() {
            panel.open()
            closeTimer.start()
        }

        property Timer closeTimer: Timer {
            repeat: false
            interval: 1000
            onTriggered: panel.close()
        }
    }
    Component.onCompleted: internal.peek()
}
