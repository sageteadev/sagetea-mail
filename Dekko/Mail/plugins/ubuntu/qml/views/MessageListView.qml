/* Copyright (C) 2016 Dan Chapman <dpniel@ubuntu.com>

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
import Ubuntu.Components 1.3
import Dekko.Mail.Accounts 1.0
import Dekko.Mail 1.0
import Dekko.Mail.API 1.0
import Dekko.Mail.Stores.Mail 1.0
import Dekko.Components 1.0
import Dekko.Mail.Settings 1.0
import QuickFlux 1.0
import PlugMan 1.0
import MazDB 1.0
import "./components"
import "./delegates"
import "./models"
import "../constants"
import "./composer"

DekkoPage {
    id: msgListPage

    property alias mboxSearch: loader_mboxSearch.item

    pageHeader {
        title: MailStore.folderTitle
        enableSearching: true
        composeButtonEnabled: !dekko.isLargeFF
        backAction: dekko.isSmallFF || MailStore.isInSelectionMode ? drawerAction : null
        filterSections: isSearchMode ? MailStore.searchFilters : MailStore.defaultFilters
        multiSelectActionList: multiSelectRegistry.actions
    }

    onSelectedIndexChanged: {
        if (isSearchMode) {
            if (selectedIndex === 0) {
                mboxSearch.location = MailboxSearch.Local
            } else {
                mboxSearch.location = MailboxSearch.Remote
            }
            return;
        }
        var filter = MessageList.All;
        switch (selectedIndex) {
        case 0: // All
            filter = MessageList.All;
            break;
        case 1: // Unread
            filter = MessageList.Unread;
            break;
        case 2: // Starred
            filter = MessageList.Important;
            break;
        case 3: // Replied
            filter = MessageList.Replied;
            break;
        case 4: // Forwarded
            filter = MessageList.Forwarded;
            break;
        case 5: // Attachments
            filter = MessageList.Attachments;
            break;
        case 6: // Calendar
            filter = MessageList.Calendar;
            break;
        }
        MessageActions.setMessageListFilter(filter)
    }

    onMultiSelectCanceled: MessageActions.endMultiSelection()
    onIsSearchModeChanged: MessageActions.resetMessageList()
    onSearchActivated: mboxSearch.search(searchString)
    onSearchCanceled: {
        pageHeader.searchInProgress = false;
        mboxSearch.cancelSearch()
    }

    bottomEdgeConfig: BottomEdgeComposer {
        hintVisible: true
        iconSource: Paths.actionIconUrl(Icons.MailUnreadIcon)
        activationKey: ViewKeys.replyToOpenMessage
        canActionTrigger: dekko.isSmallFF
        enabled: dekko.isSmallFF
        flickable: listView
        listenerEnabled: enabled
    }

    MazDBSettings {
        category: "ui-property-cache"
        property alias msgListFilterIndex: msgListPage.selectedIndex
    }

    // Plugins can add bulk message actions by registering Action for this location
    ActionRegistry {
        id: multiSelectRegistry
        location: MailStore.listenerId ? "Dekko::Mail::MultiSelectAction" : ""
        defaultActions: [
            Action {
                iconSource: !MailStore.msgList.canSelectAll ? Paths.actionIconUrl(Paths.NoneSelectedIcon) :
                                                              Paths.actionIconUrl(Paths.SelectIcon)
                text: MailStore.msgList.canSelectAll ? qsTr("Unselect all") : qsTr("Select all")
                onTriggered: {
                    if (MailStore.msgList.canSelectAll) {
                        MessageActions.selectAllMessages()
                    } else {
                        MessageActions.unselectAllMessages()
                    }
                }
            },
            Action {
                iconSource: MailStore.msgList.canMarkSelectionImportant ? Paths.actionIconUrl(Paths.StarredIcon) :
                                                                Paths.actionIconUrl(Paths.UnStarredIcon)
                text: MailStore.msgList.canMarkSelectionImportant ? qsTr("Star") : qsTr("Remove star")
                onTriggered: MessageActions.markSelectedMessagesImportant()
            },
            Action {
                text: MailStore.msgList.canMarkSelectionRead ? qsTr("Mark as un-read") : qsTr("Mark as read")
                iconSource: !MailStore.msgList.canMarkSelectionRead ? Paths.actionIconUrl(Paths.MailUnreadIcon) :
                                                            Paths.actionIconUrl(Paths.MailReadIcon)
                onTriggered: MessageActions.markSelectedMessagesRead()
            },
            Action {
                iconSource: Paths.actionIconUrl(Paths.DeleteIcon)
                text: qsTr("Delete")
                onTriggered: MessageActions.deleteSelectedMessages()
            }
        ]
    }

    Action {
        id: drawerAction
        iconName: "navigation-menu"
        onTriggered: ViewActions.toggleNavDrawer()
    }

    Loader {
        id: loader_mboxSearch
        asynchronous: true
        sourceComponent: Component {
            id: component_mboxSearch
            MailboxSearch {
                messageKey: MailStore.msgListKey
                location: MailboxSearch.Local
                limit: 50
                sortBy: MailboxSearch.TimeStamp
                sortOrder: Qt.DescendingOrder
                onStatusChanged: {
                    if (status === SearchService.InProgress) {
                        pageHeader.searchInProgress = true
                    } else {
                        pageHeader.searchInProgress = false
                    }
                }
            }
        }
    }


    PageContent {
        id: cont

        ListItem {
            id: undoNotification
            expansion.height: units.gu(6)
            expansion.expanded: MailStore.hasUndoableActions
            divider.visible: MailStore.hasUndoableActions
            height: 0
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
            }
            color: UbuntuColors.porcelain

            Label {
                anchors {
                    left: parent.left
                    leftMargin: Style.defaultSpacing
                    verticalCenter: parent.verticalCenter
                }
                visible: MailStore.hasUndoableActions
                text: MailStore.undoableActionDescription
            }

            Button {
                height: Style.largeSpacing
                width: Style.largeSpacing * 2
                anchors {
                    right: parent.right
                    rightMargin: Style.defaultSpacing
                    verticalCenter: parent.verticalCenter
                }
                color: UbuntuColors.green
                action: Action {
                    text: "Undo"
                    onTriggered: MessageActions.undoRecentActions()
                }
            }
        }

        ScrollView {
            anchors {
                left: parent.left
                top: undoNotification.bottom
                right: parent.right
                bottom: parent.bottom
            }

            ListView {
                id: listView
                property int selectionIndex: 0

                anchors.fill: parent
                clip: true
                currentIndex: MailStore ? MailStore.currentSelectedIndex : -1
                //                onCurrentIndexChanged: {
                //                    console.log("CurrentIndexChanged: ", currentIndex)
                //                    if (currentIndex === -1) {
                //                        return;
                //                    }
                //                    var msgId = -1
                //                    if (isSearchMode) {
                //                        msgId = mboxSearch.results.get(currentIndex).messageId
                //                    } else {
                //                        msgId = MailStore.msgListModel.get(currentIndex).messageId
                //                    }
                //                    MessageActions.openMessage(msgId)
                //                }

                add: DekkoAnimation.listViewAddTransition
                addDisplaced: DekkoAnimation.listViewAddDisplacedTransition
                remove: DekkoAnimation.listViewRemoveTransition
                removeDisplaced: DekkoAnimation.listViewRemoveDisplacedTransition

                highlight: !dekko.isSmallFF ? Style.highlightBar : null
                highlightFollowsCurrentItem: true
                highlightMoveDuration: 200
                cacheBuffer: units.gu(35)
                model: isSearchMode ? mboxSearch.results : MailStore.msgListModel
                delegate: MessageListDelegate{
                    id: msgListDelegate
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    // This prevents making excessive calls to data()
                    // We just take the actual MinimalMessage object
                    // in one go and reuse it throughout.
                    msg: model.qtObject

                    leftSideAction: Action {
                        iconName: "delete"
                        onTriggered: {
                            MessageActions.deleteMessage(msgListDelegate.msg.messageId)
                        }
                    }

                    rightSideActions: [flagAction, readAction, contextAction]

                    onItemClicked: {

                        if (MailStore.isInSelectionMode) {
                            if (msg.checked) {
                                MessageActions.setMessageCheck(model.index, Qt.Unchecked)
                            } else {
                                MessageActions.setMessageCheck(model.index, Qt.Checked)
                            }
                            return;
                        }

                        if (msg.isDraft) {
                            ComposerActions.openDraft(msg.messageId)
                            return;
                        }

                        if (mouse.button === Qt.RightButton) {
                            rightClickActions.trigger()
                            return;
                        }

                        MessageActions.openMessage(msg.messageId)
                        MailStore.currentSelectedIndex = model.index
                    }
                    onItemPressAndHold: {
                        // TODO: get multiselect working on search results.
                        if (isSearchMode) {
                            return;
                        }
                        if (!MailStore.isInSelectionMode) {
                            listView.selectionIndex = model.index
                            MessageActions.startMultiSelection()
                            MessageActions.setMessageCheck(model.index, Qt.Checked)
                            msgListPage.startMultiSelect()
                        }
                    }
                }
                // canLoadMore will always be false when the list is empty so there
                // isn't any need to add a binding on count/totalCount as that signal
                // emits *very* often and really bogs down the UI. canPossiblyLoadMore will
                // only get emitted after all the insertions/removals have completed for a query.
                footer: (!isSearchMode && MailStore.canLoadMore) ? footerComponent : null

                Component {
                    id: footerComponent
                    ListItem {
                        Label {
                            anchors.centerIn: parent
                            text: qsTr("Load more messages ...")
                        }
                        onClicked: MessageActions.showMoreMessages()
                    }
                }
            }
        }
    }

    Binding {
        target: listView;
        property: "currentIndex";
        value: MailStore.currentSelectedIndex
        when: MailStore
    }

    AppListener {
        Filter {
            type: MessageKeys.resetMessageList
            onDispatched: {
                listView.currentIndex = -1
                listView.positionViewAtBeginning()
                selectedIndex = 0
            }
        }
    }
}
