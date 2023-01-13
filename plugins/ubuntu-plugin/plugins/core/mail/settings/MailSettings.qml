import QtQuick 2.4
import Ubuntu.Components 1.3
import SageteaMail.Mail.API 1.0
import PlugMan 1.0
import SageteaMail.Ubuntu.Components 1.0

DekkoPage {
    id: sp

    pageHeader {
        title: qsTr("Mail Settings")
        backAction: Action {
            iconName: "back"
            onTriggered: ViewActions.popStageArea(ViewKeys.settingsStack1)
        }
    }

    ActionRegistry {
        id: registry
        location: "SageteaMail::Settings::MailAction"
        defaultActions: [
            Action {
                iconName: "account"
                text: qsTr("Accounts")
                onTriggered: ViewActions.pushToStageArea(
                                 ViewKeys.settingsStack1,
                                 Qt.resolvedUrl("./ManageAccountsPage.qml"),
                                 {}
                             )
            },

            Action {
                iconName: "contact-group"
                text: qsTr("Identities")
                onTriggered: ViewActions.pushToStageArea(
                                 ViewKeys.settingsStack1,
                                 Qt.resolvedUrl("./IdentitiesListPage.qml"),
                                 {}
                             )
            },

            Action {
                iconName: "video-display-symbolic"
                text: qsTr("Display")
                onTriggered: SettingsActions.openSettingsGroup(
                                 Qt.resolvedUrl("./DisplaySettingsPage.qml")
                             )
            },
            Action {
                iconName: "private-browsing"
                text: qsTr("Privacy")
                onTriggered: SettingsActions.openSettingsGroup(
                                 Qt.resolvedUrl("./PrivacySettingsPage.qml")
                             )
            },
            Action {
                iconName: "preferences-desktop-logins-items-symbolic"
                text: qsTr("Contributors")
                onTriggered: SettingsActions.openSettingsGroup(
                                 Qt.resolvedUrl("../models/ContributorsModel.qml")
                             )
            },
            
        ]
    }

    PageFlickable {
        margins: 0
        spacing: 0

        Repeater {
            id: settingsRepeater
            model: registry.actions
            delegate: ListItem {
                id: li
                property Action action: modelData
                height: layout.height + divider.height
                ListItemLayout {
                    id: layout
                    title.text: li.action.text
                    Icon {
                        height: units.gu(3)
                        width: height
                        name: li.action.iconName ? li.action.iconName : ""
                        source: li.action.iconSource ? li.action.iconSource : ""
                        SlotsLayout.position: SlotsLayout.Leading
                    }

                    ProgressionSlot {}
                }
                onClicked: li.action.trigger()
            }
        }
    }
}
