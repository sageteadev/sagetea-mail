import QtQuick 2.4
import Ubuntu.Components 1.3
import Dekko.Mail.API 1.0
import Dekko.Components 1.0
import MazDB 1.0
import Dekko.Ubuntu.Components 1.0
import Dekko.Mail.Stores.Views 1.0

Rectangle {
    id: bar
    color: UbuntuColors.inkstone

    NavPluginModel {
        id: navPlugins
    }

    Line {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        color: UbuntuColors.slate
    }

    StretchColumn {
        anchors.fill: parent

        AbstractButton {
            id: drawerBtn
            height: units.gu(6)
            width: bar.width
            implicitHeight: height
            visible: !dekko.isLargeFF

            onClicked: ViewActions.toggleNavDrawer()

            Rectangle {
                anchors.fill: parent
                visible: drawerBtn.pressed
                color: UbuntuColors.slate
            }

            Icon {
                name: "navigation-menu"
                color: UbuntuColors.silk
                height: units.gu(3)
                width: height
                anchors.centerIn: parent
            }

        }

        Line {
            color: UbuntuColors.slate
            visible: !dekko.isLargeFF
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: units.gu(1)
                rightMargin: units.gu(1)
            }
        }

        Stretcher {
            clip: true
            Flickable {
                anchors.fill: parent
                contentHeight: col.height + units.gu(5)
                Column {
                    id: col
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                    }

                    Repeater {
                        model: navPlugins.plugins

                        delegate: AbstractButton {
                            id: btn

                            readonly property bool isSelected: ViewStore.selectedNavIndex === index

                            action: modelData
                            height: units.gu(7)
                            width: bar.width
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
                                    bottom: parent.bottom
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
        }

        Line {
            color: UbuntuColors.slate
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: units.gu(1)
                rightMargin: units.gu(1)
            }
        }

        AbstractButton {
            height: units.gu(7)
            width: bar.width
            implicitHeight: height

            Icon {
                name: "like"
                color: UbuntuColors.green
                height: units.gu(3.4)
                width: height
                anchors.centerIn: parent
            }
        }

        AbstractButton {
            id: settingsBtn
            height: units.gu(7)
            width: bar.width
            implicitHeight: height

            onClicked: ViewActions.openSettings()

            Rectangle {
                anchors.fill: parent
                visible: settingsBtn.pressed
                color: UbuntuColors.slate
            }

            Icon {
                name: "settings"
                color: UbuntuColors.silk
                height: units.gu(3.4)
                width: height
                anchors.centerIn: parent
            }
        }
    }
}
