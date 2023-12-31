import QtQuick 2.4
import QtQuick.Window 2.1
import Lomiri.Components 1.3
import MazDB 1.0
import QtWebEngine 1.5 

Window {
    id: window
    visible: true
    minimumWidth: units.gu(30)
    minimumHeight: units.gu(30)
    width: units.gu(120)
    height: units.gu(80)
    flags: Qt.Window
    modality: Qt.NonModal

    title: qsTr("Sagetea Mail")

    MazDBSettings {
        category: "window-property-cache"
        property alias windowWidth: window.width
        property alias windowHeight: window.height
        property alias windowVisible: window.visible
        property alias windowX: window.x
        property alias windowY: window.y
    }

    Item {
        anchors.fill: parent
        Loader {
            asynchronous: false
            anchors.fill: parent
            source: Qt.resolvedUrl("./SageteaMail.qml")
        }
    }
}
