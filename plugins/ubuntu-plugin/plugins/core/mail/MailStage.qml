/* Copyright (C) 2016 - 2017 Dan Chapman <dpniel@ubuntu.com>

   This file is part of Dekko email client for Ubuntu devices

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License or (at your option) version 3

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.4
import Lomiri.Components 1.3
import SageteaMail.Mail 1.0
import SageteaMail.Mail.API 1.0
import SageteaMail.Components 1.0
import SageteaMail.Mail.Settings 1.0
import SageteaMail.Mail.Stores.Views 1.0
import SageteaMail.Mail.Stores.Mail 1.0
import SageteaMail.Lomiri.Constants 1.0
import SageteaMail.Lomiri.Stage 1.0
import QuickFlux 1.0
import MazDB 1.0
import SageteaMail.Lomiri.Components 1.0
import "./views"

BaseStage {
    id: ms

    MazDBSettings {
        category: "ui-property-cache"
        property alias mailstagePanel1Size: p1.size
        property alias mailstagePanel2Size: p2.size
        property alias mailstagePanel3Size: p3.size
    }
    
    // We use a stretch row here rather than RowLayout
    // Just because we can use the implicit size hints to stretch the correct
    // panel. Yes we could use Layout.fillWidth but in the future there maybe
    // more columns added to this (through plugins) and we may want to share remaining width evenly between two
    // or more colums. Which StretchRow handles nicely
    StretchRow {
        spacing: 0
        anchors.fill: parent

        // Should only be visible on large FF
        // Access is done via the navigation drawer
        // for smaller FF's
        PanelContainer {
            id: p1
            visible: sageteamail.isLargeFF
            resizable: !sageteamail.isSmallFF
            minSize: units.gu(20)
            maxSize: units.gu(50)
            height: parent.height
            activeEdge: Item.Right
            StageArea {
                id: navMenuStage
                stageID: ViewKeys.navigationStack
                anchors.fill: parent
                baseUrl: Qt.resolvedUrl("./views/NavSideBar.qml")
            }
        }

        PanelContainer {
            id: p2
            // This is where we could no longer
            // work with AdaptivePageLayout
            // Our center column is actually our main page
            // when on small form factor devices, and having to
            // pop/push and rejig evenrything was just awful
            // Plus i prefer our api.
            // So we set this main page to fill screen width when
            // on small FF. This sets the implicit width to -1
            // and restores it on going back to larger FF's
            stretchOnSmallFF: true
            resizable: !sageteamail.isSmallFF
            minSize: units.gu(40)
            maxSize: units.gu(60)
            size: units.gu(40)
            height: parent.height
            activeEdge: Item.Right
            clip: true

            StageArea {
                id: msgListStage
                stageID: ViewKeys.messageListStack
                anchors.fill: parent
                baseUrl: Qt.resolvedUrl("./views/MessageListView.qml")
                function rewind() {
                    var needsDelay = false
                    if (stackCount > 1) {
                        needsDelay = true
                        while (stackCount !== 1) {
                            pop()
                        }
                    }
                    if (needsDelay) {
                        delaySignalRewind.start()
                    } else {
                        MessageActions.stackRewound()
                    }
                }

            }

            NavigationDrawer {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                enabled: !sageteamail.isLargeFF
                visible: enabled
                animate: true
                width: Style.defaultPanelWidth
                state: "fixed"
                NavSideBar {
                    anchors.fill: parent
                    panelMode: true
                }
            }
        }
        // Take rest of space when visible
        Stretcher {
            visible: !sageteamail.isSmallFF
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            StageArea {
                id: msgViewStage
                stageID: ViewKeys.messageViewStack
                anchors.fill: parent
                immediatePush: false
                baseUrl: Qt.resolvedUrl("./views/NothingSelectedPage.qml")
                delegate: DekkoAnimation.customStackViewDelegate1
                AppListener {
                    filter: MessageKeys.openFolder
                    onDispatched: {
                        if (msgViewStage.stackCount > 1) {
                            msgViewStage.pop()
                        }
                    }
                }
            }
        }

        PanelContainer {
            id: p3
            visible: sageteamail.isLargeFF && pluginStage.stackCount
            minSize: units.gu(20)
            maxSize: units.gu(40)
            size: units.gu(30)
            height: parent.height
            activeEdge: Item.Left

            StageArea {
                id: pluginStage
                stageID: "pluginStack"
                anchors.fill: parent
            }
        }
    }

    Timer {
        id: delaySignalRewind
        interval: 300
        repeat: false
        onTriggered: MessageActions.stackRewound()
    }

    AppListener {

        Filter {
            type: MessageKeys.openMessage
            onDispatched: {
                if (MailStore.currentMessageId === message.msgId) {
                    Log.logInfo("MailStage::openMessage", "Message %1 already open".arg(message.msgId))
                    return
                }

                MessageActions.setCurrentMessage(message.msgId)

                var style = Qt.resolvedUrl("./messageview/DefaultMessagePage.qml")
                if (sageteamail.isSmallFF) {
                    // leftStage push msgview
                    ViewActions.pushToStageArea(ViewKeys.messageListStack, style, {msgId: message.msgId})
                } else {
                    if (msgViewStage.stackCount > 1) {
                        ViewActions.replaceTopStageAreaItem(ViewKeys.messageViewStack, style, {msgId: message.msgId})
                    } else {
                        ViewActions.pushToStageArea(ViewKeys.messageViewStack, style, {msgId: message.msgId})
                    }
                }
            }
        }

        Filter {
            type: MessageKeys.rewindMessageListStack
            onDispatched: {
                // Listen for a new folder opening and pop the stack
                // until we get to the msglist. MailStore is also listening on this and will take
                // care of actually opening the folder.
                Log.logInfo("MailStage::openFolder", "Checking stack count")
                msgListStage.rewind()
            }
        }

        Filter {
            type: MessageKeys.openAccountFolder
            onDispatched: {
                ViewActions.closeNavDrawer()
                if (sageteamail.isLargeFF) {
                    ViewActions.pushToStageArea(ViewKeys.navigationStack,
                                                Qt.resolvedUrl("./views/FolderListView.qml"),
                                                {
                                                    pageTitle: message.accountName,
                                                    accountId: message.accountId
                                                })
                } else {
                    ViewActions.pushToStageArea(ViewKeys.messageListStack,
                                                Qt.resolvedUrl("./views/FolderListView.qml"),
                                                {
                                                    pageTitle: message.accountName,
                                                    accountId: message.accountId
                                                })
                }
            }
        }
    }
}
