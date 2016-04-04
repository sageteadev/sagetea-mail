import QtQuick 2.4
import Ubuntu.Components 1.3
import Dekko.Mail 1.0
import Dekko.Components 1.0
import "../components"
import "../delegates"

DekkoPage {

    property string pageTitle: "Folders"
    property alias accountId: folderList.accountId

    pageHeader.title: pageTitle
    pageHeader.backAction: Action {
        iconName: "back"
        onTriggered: internalStack.pop()
    }
    extendHeader: !dekko.viewState.isSmallFF

    FolderList {
        id: folderList
    }

    ScrollView {
        anchors {
            left: parent.left
            right: parent.right
            top: pageHeader.bottom
            bottom: parent.bottom
        }
        ListView {
            anchors.fill: parent
            clip: true
            model: folderList.model
            delegate: FolderListDelegate {
                folder: model.qtObject
                onItemClicked: mailView.openFolder(folder.name, folder.messageKey)
            }
        }
    }
}
