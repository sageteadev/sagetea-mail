import QtQuick 2.4
import Lomiri.Components 1.3
import SageteaMail.Mail 1.0
import SageteaMail.Mail.Accounts 1.0
import SageteaMail.Mail.API 1.0
import SageteaMail.Mail.Settings 1.0
import SageteaMail.Mail.Stores.Accounts 1.0
import SageteaMail.Mail.Stores.Mail 1.0
import SageteaMail.Mail.Stores.Views 1.0
import SageteaMail.Components 1.0
import MazDB 1.0
import PlugMan 1.0
import SageteaMail.Lomiri.Components 1.0
import "../delegates"

StyledItem {
    width: parent.width
    height: parent.height

    property bool panelMode: false

    theme: ThemeSettings{
        name: "Lomiri.Components.Themes.SuruDark"
    }

    MazDBSettings {
        category: "ui-property-cache"
        property alias smartFoldersExpanded: smf.expanded
        property alias accountFoldersExpanded: acg.expanded
    }

    Rectangle {
        anchors.fill: parent
        color: LomiriColors.inkstone
    }

    ActionRegistry {
        id: headerRegistry
        location: "SageteaMail::Mail::NavHeadAction"
        defaultActions: [
            Action {
                iconName: "edit"
                onTriggered: ViewActions.openComposer()
                visible: sageteamail.isLargeFF
            },
            Action {
                iconName: "settings"
                visible: sageteamail.isSmallFF
                onTriggered: ViewActions.openSettings()
            }
        ]
    }

    StretchColumn {
        anchors {
            fill: parent
        }

        Item {
            width: parent.width
            height: units.gu(5)
            implicitHeight: height
            visible: !sageteamail.isMediumFF

            StretchRow {
                anchors {
                    leftMargin: units.gu(1)
                    fill: parent
                    rightMargin: units.gu(1)
                }

                HeaderButton {
                    height: units.gu(5.5)
                    width: units.gu(5)
                    implicitWidth: width
                    iconColor: LomiriColors.silk
                    iconSize: units.gu(2.5)
                    highlightColor: LomiriColors.slate
                    action: Action {
                        visible: sageteamail.isSmallFF
                        iconName: "navigation-menu"
                        onTriggered: ViewActions.toggleNavDrawer()
                    }
                }

                Stretcher {}

                Repeater {
                    model: headerRegistry.actions
                    delegate: HeaderButton {
                        height: units.gu(5.5)
                        width: units.gu(5)
                        implicitWidth: width
                        iconColor: LomiriColors.silk
                        iconSize: units.gu(2.5)
                        highlightColor: LomiriColors.slate
                        action: modelData
                    }
                }
            }
        }

        Stretcher {
            anchors {
                left: parent.left
                right: parent.right
            }

            ScrollView {
                anchors.fill: parent
                Flickable {
                    anchors.fill: parent
                    contentHeight: col.height

                    Column {
                        id: col
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }

                        Repeater {
                            id: inboxList
                            model: MailboxStore.standardFoldersModel
                            delegate: NavMenuStandardFolderDelegate {
                                id: folderDelegate
                                folder: qtObject
                                supportsDescendents: true
                                onClicked: {
                                    if (model.index === 0) {
                                        MessageActions.openFolder(folder.displayName, folder.descendentsKey)
                                    } else {
                                        MessageActions.openFolder(folder.displayName, folder.messageKey)
                                    }
                                }
                                onSubFolderClicked: MessageActions.openFolder(name, key)
                                Component.onCompleted: {
                                    if (model.index === 0 && !panelMode) {
                                        ViewActions.delayCallWithArgs(MessageKeys.openFolder, {
                                                                          folderName: folder.displayName,
                                                                          folderKey: folder.descendentsKey
                                                                      })
                                    }
                                }
                            }
                        }

                        NavigationGroup {
                            id: smf
                            title: qsTr("Smart folders")
                            model: MailboxStore.smartFoldersModel
//                            expansion.expanded: PolicyManager.views.smartFoldersExpanded
//                            onExpandClicked: PolicyManager.views.smartFoldersExpanded = !PolicyManager.views.smartFoldersExpanded
                            delegate: SmartFolderDelegate {
                                id: smartFolderDelegate
                                folder: qtObject
                                smartFolder: true
                                onClicked: MessageActions.openFolder(folder.displayName, folder.messageKey)
                            }
                        }

                        NavigationGroup {
                            id: acg
                            title: qsTr("Folders")
                            model: AccountStore.receiveAccountsModel
//                            expansion.expanded: PolicyManager.views.accountsExpanded
//                            onExpandClicked: PolicyManager.views.accountsExpanded = !PolicyManager.views.accountsExpanded
                            delegate: ListItem {
                                height: dLayout.height
                                divider.visible: false
                                onClicked: MessageActions.openAccountFolder(qtObject.name, qtObject.id)
                                Rectangle {
                                    anchors.fill: parent
                                    color: Qt.rgba(0, 0, 0, 0.05)
                                    visible: dLayout ? dLayout.title.text === ViewStore.selectedNavFolder : false
                                }
                                ListItemLayout {
                                    id: dLayout
                                    height: units.gu(6)
                                    title.text: qtObject.name
                                    Icon {
                                        height: units.gu(2.5)
                                        width: height
                                        name: "contact"
                                        SlotsLayout.position: SlotsLayout.Leading
                                    }
                                    ProgressionSlot{}
                                }
                            }
                        }

                            Label {
                                id: upgradeLabel
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width * 4 / 5
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                text: i18n.tr("You are runnig a free edition of SageTea Mail, consider upgrade to Pro Version")
                                font.bold: true
                        }

                            Button {
                                id: upgradeButton
                                width: parent.width * 4 / 5
                                color: LomiriColors.orange
                                text: i18n.tr("Upgrade to Pro")
                                font.bold: true
                                onClicked: Qt.openUrlExternally(link)
                        }
                    }
                }
            }
        }
    }
}
