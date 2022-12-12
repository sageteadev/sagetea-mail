import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root
    implicitWidth: height
    property alias text: textField.text
    property alias iconName: icon.name
    property alias iconSource: icon.source
    property alias iconColor: icon.color
    // Set to true when format option is currently enabld
    property bool active: false
    property alias font: textField.font
    property alias textSize: textField.textSize

    signal clicked()

    opacity: enabled ? 1 : 0.5

    AbstractButton {
        activeFocusOnPress: false
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Rectangle {
        anchors.fill: parent
        color: UbuntuColors.porcelain
        visible: root.active
    }

    Icon {
        id: icon
        anchors { centerIn: parent }
        height: units.gu(2.5)
        width: height
        visible: source.toString().length > 0
    }

    Label {
        id: textField
        anchors { centerIn: parent }
    }
}
