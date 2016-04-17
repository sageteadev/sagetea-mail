import QtQuick 2.4
import Dekko.Settings 1.0

Item {
    id: mailView

    anchors.fill: parent

    GlobalSettings {
        id: globalSettings

        function messageViewStyle() {
            if (data.messageview.style === "default") {
                return "qrc:/qml/views/messageview/DefaultMessagePage.qml"
            } else if (data.messageview.style === "clean") {
                return "qrc:/qml/views/messageview/CleanMessagePage.qml"
            }
        }
    }

    function openMessage(msgId) {
        var style = globalSettings.messageViewStyle()
        if (dekko.viewState.isSmallFF) {
            // leftStage push msgview
            msgListStage.push(style, {msgId: msgId})
        } else {
            if (msgViewStage.stackCount > 1) {
                msgViewStage.replaceTopItem(style, {msgId: msgId})
            } else {
                msgViewStage.push(style, {msgId: msgId})
            }
        }
    }

    function openFolder(folderName, folderKey) {
        msgListStage.openFolder(folderName, folderKey)
    }

    function openAccountFolder(name, acId) {
        if (dekko.viewState.isLargeFF) {
            navMenuStage.push("qrc:/qml/views/FolderListView.qml", {pageTitle: name, accountId: acId})
        } else {
            msgListStage.push("qrc:/qml/views/FolderListView.qml", {pageTitle: name, accountId: acId})
        }
    }

    Item {
        id: container
        anchors.fill: parent

        property int defaultWidth: 0
        Item {
            id: menuColumn
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: dekko.viewState.isLargeFF ? units.gu(30) : 0
            StageArea {
                id: navMenuStage
                anchors.fill: parent
                baseUrl: "qrc:/qml/views/NavMenuPage.qml"
            }
        }

        StageAreaDivider {
            id: menuDivider
            leftSide: menuColumn
            leftSideContainer: container
            canDrag: false
        }

        Item {
            id: msgListColumn
            anchors {
                left: menuDivider.right
                top: parent.top
                bottom: parent.bottom
            }
            readonly property int defaultWidth: dekko.viewState.isLargeFF ? units.gu(43.5) : units.gu(40)
            width: (container.width > units.gu(90) && !dekko.viewState.isSmallFF) ? defaultWidth : parent.width
            StageArea {
                id: msgListStage

                function openFolder(title, key) {
                    // To open a folder we want to get back to the initial page
                    // i.e baseUrl below. So just pop off what's on top then apply the key
                    if (stackCount > 1) {
                        while (stackCount !== 1) {
                            pop()
                        }
                    }
                    currentItem.openFolder(title, key)
                }

                anchors.fill: parent
                baseUrl: "qrc:/qml/views/MessageListView.qml"
            }
        }

        StageAreaDivider {
            id: msgListDivider
            leftSide: msgListColumn
            leftSideContainer: container
            canDrag: false
        }

        Item {
            id: msgViewColumn
            anchors {
                left: msgListDivider.right
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            StageArea {
                id: msgViewStage
                anchors.fill: parent
                immediatePush: true
                baseUrl: "qrc:/qml/views/NothingSelectedPage.qml"
            }
        }
    }
}

