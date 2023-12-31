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
import Lomiri.Components.Popups 1.3
import PlugMan 1.0

import SageteaMail.Mail.API 1.0
import SageteaMail.Mail.Settings 1.0
import SageteaMail.Mail.Stores.Views 1.0
import SageteaMail.Mail.Stores.Composer 1.0
import SageteaMail.Mail.Workers 1.0

import SageteaMail.Lomiri.Components 1.0
import SageteaMail.Lomiri.Dialogs 1.0
import SageteaMail.Lomiri.Helpers 1.0

import "./workers"

ViewState {
    id: sageteamail

    anchors.fill: parent
    onStateChanged: {
        var ignore = ComposerStore.listenerId
        ignore = PolicyManager.objectName
        ViewStore.formFactor = state
        Log.logStatus("ViewState::stateChanged", state)
    }

    Item {
        id: dekkoContainer
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            // anchor to the top of KeyboardRectangle
            // this ensures pages are always above the OSK
            // Basically the same as anchorToKeyboard
            bottom: kbdRect.top
        }
    }

    ItemRegistry {
        id: itemRegistry
        asynchronous: false
        location: "SageteaMail::Stage::Main"
        target: dekkoContainer
        loadMode: ItemRegistry.LoadFirstEnabled
    }

    DialogWorker {
        name: PopupKeys.popupMainWindow
        dlgTarget: dekkoContainer
        noticePopup: Component {
            NoticePopup{}
        }
        confirmationPopup: Component {
            ConfirmationDialog{}
        }
    }

    ToastWorker {
        name: ViewKeys.toastMainWindow
        target: dekkoContainer
        toastSource: Qt.resolvedUrl("./views/toasts/SimpleToast.qml")
    }

    Loader {
        id: workerLoader
        asynchronous: true
        sourceComponent: ListenerRegistry {
            defaultListeners: [
                AccountsWorker {},
                MailboxWorker {
                    mailboxPickerUrl: itemRegistry.findFirstEnabled("SageteaMail::Mail::FolderPicker")
                },
                SettingsWorker {
                    mailboxPickerUrl: itemRegistry.findFirstEnabled("SageteaMail::Mail::FolderPicker")
                },
                UriWorker {},
                ErrorsWorker {}
            ]
        }
    }

    // Workers we need straight away
    QtObject {
        id: d
        property MailWorker mailWorker: MailWorker {}
        property ComposerWorker composeWorker: ComposerWorker {}
        property ContentWorker contentWorker: ContentWorker {}
        property Logger logger: Logger {
            devLoggingEnabled: devModeEnabled
        }
    }

    KeyboardRectangle {
        id: kbdRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    Connections {
        target: UriHandler
        onOpened: {
            Log.logInfo("UriListener::UriHandler::onOpened", "We got uris to handle: " + uris)
            ViewActions.openUris(uris)
        }
    }

}

