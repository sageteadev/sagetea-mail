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
pragma Singleton
import QtQuick 2.4
import QuickFlux 1.0
import Dekko.Accounts 1.0
import Dekko.AutoConfig 1.0
import Dekko.Mail 1.0
import "../../actions/composer"
import "../../actions/logging"
import "../../actions/views"
import "../../actions/popups"
import "../accounts"
import "../../views/utils/QtCoreAPI.js" as QtCoreAPI

AppListener {

    readonly property bool showCC: d.ccVisible
    readonly property bool showBCC: d.bccVisible
    readonly property bool sendInProgress: d.sendInProgress
    readonly property bool hasValidIdentity: d.identitiesValid
    readonly property bool sidePanelOpen: builder.attachments.count || d.openContacts
    readonly property string currentSignature: identities.selectedAccount.outgoing.signature
    readonly property QtObject identity: priv_identity
    readonly property QtObject recipients: priv_recipients
    readonly property QtObject attachments: builder.attachments
    readonly property QtObject __builder: builder

    property ComposerStoreActions actions: ComposerStoreActions{}

    property alias identitiesModel: identities.accountsModel
    property alias identityIndex: identities.selectedIndex
    // bind the subject fields text document to messagebuilder
    property alias subjectDocument: builder.subject
    // bind the body fields text document to messagebuilder
    property alias bodyDocument: builder.body

    SenderIdentities {
        id: identities
        accountsModel: AccountStore.sendAccountsModel
    }

    MessageBuilder {
        id: builder
        identities: identities
    }

    SubmissionManager {
        id: submissionManager
        builder: builder
        onError: {
            switch(error) {
                case SubmissionManager.NoBuilder:
                Log.logError("ComposerStore::SubmissionManager::NoBuilder", "No message builder set. Cannot compose without one")
                break
                case SubmissionManager.InvalidMessage:
                Log.logError("ComposerStore::SubmissionManager::InvalidMessage", "Invalid message, missing 'To' recipients or Subject")
                break
                case SubmissionManager.NoIdentities:
                Log.logError("ComposerStore::SubmissionManager::NoIdentities", "No identities available for MessageBuilder. Cannot proceed...")
                break
            }
        }
        onMessageQueued: {
            Log.logInfo("ComposerStore::SubmissionManager::messageQueued", "Message queued resetting composer")
            ComposerActions.resetComposer()
            ViewActions.closeComposer()
            d.sendInProgress = false
        }
        onDraftSaved: {
            Log.logInfo("ComposerStore::SubmissionManager::draftSaved", "Draft message was saved");
            ViewActions.orderSimpleToast(qsTr("Draft saved."))
        }
    }

    QtObject {
        id: priv_identity
        readonly property string name: hasValidIdentity ? identities.selectedAccount.outgoing.name : ""
        readonly property string initials: hasValidIdentity ? identities.selectedAccount.outgoing.initials : ""
        readonly property string email: hasValidIdentity ? identities.selectedAccount.outgoing.email : ""
    }

    QtObject {
        id: priv_recipients
        property alias to: builder.to
        property alias cc: builder.cc
        property alias bcc: builder.bcc
    }

    QtObject {
        id: d
        property bool sendInProgress: false
        property bool ccVisible: false
        property bool bccVisible: false
        property bool identitiesValid: identities.selectedIndex >= 0
        property bool openContacts: false
        property Timer delayDiscard: Timer {
            interval: 10
            onTriggered: ComposerActions.discardMessage()
        }
        property Timer sendTimer: Timer {
            interval: 50
            onTriggered: submissionManager.send()
        }
    }

    Filter {
        type: ComposerKeys.validateAddress
        onDispatched: {
            if (EmailValidator.validate(message.address)) {
                ComposerActions.validAddress(message.type, message.address)
            } else {
                ComposerActions.invalidAddress(message.type, message.address)
            }
        }
    }

    Filter {
        type: ComposerKeys.addRecipientFromAddress
        onDispatched: {
            switch(message.type) {
                case RecipientType.To:
                builder.addRecipient(MessageBuilder.To, message.address)
                break;
                case RecipientType.Cc:
                builder.addRecipient(MessageBuilder.Cc, message.address)
                break;
                case RecipientType.Bcc:
                builder.addRecipient(MessageBuilder.Bcc, message.address)
                break;
            }
        }
    }

    Filter {
        type: ComposerKeys.addRecipientFromNameAddress
        onDispatched: {
            switch(message.type) {
                case RecipientType.To:
                builder.addRecipient(MessageBuilder.To, message.name, message.address)
                break;
                case RecipientType.Cc:
                builder.addRecipient(MessageBuilder.Cc, message.name, message.address)
                break;
                case RecipientType.Bcc:
                builder.addRecipient(MessageBuilder.Bcc, message.name, message.address)
                break;
            }
        }
    }

    Filter {
        type: ComposerKeys.removeRecipient
        onDispatched: {
            switch(message.type) {
                case RecipientType.To:
                builder.removeRecipient(MessageBuilder.To, message.index)
                break;
                case RecipientType.Cc:
                builder.removeRecipient(MessageBuilder.Cc, message.index)
                break;
                case RecipientType.Bcc:
                builder.removeRecipient(MessageBuilder.Bcc, message.index)
                break;
            }
        }
    }

    Filter {
        type: ComposerKeys.setIdentity
        onDispatched: {
            if (message.idx < 0 || message.idx > identities.accountsModel.count) {
                Log.logError("ComposerStore::setIdentity", "Trying to set unknown index: %1".arg(message.idx))
                return
            }
            if (message.idx === identities.selectedIndex) {
                Log.logInfo("ComposerStore::setIdentity", "Identity at index already set as selected account")
                return
            }
            Log.logStatus("ComposerStore::setIdentity", "Setting identity at index: %1".arg(message.idx))
            identities.setSelectedIndex(message.idx)
        }
    }

    Filter {
        type: ComposerKeys.discardMessageConfirmed
        onDispatched: {
            Log.logInfo("ComposerStore::discardMessage", "Discarding message")
            ComposerActions.resetComposer()
            submissionManager.discard()
            // We can just call close now as we don't need to wait on anything with resetComposer
            ViewActions.closeComposer()
        }
    }

    AppScript {
        readonly property string dlgId: "discard-confirmation-dialog"
        runWhen: ComposerKeys.discardMessage
        script: {
            if (builder.hasDraft) {
                PopupActions.showConfirmationDialog(dlgId, qsTr("Discard message"), qsTr("Are you sure you want to discard this message?"))
            } else {
                ComposerActions.discardMessageConfirmed()
                exit.bind(this,0)
                return;
            }

            once(PopupKeys.confirmationDialogConfirmed, function(message){
                if (message.id === dlgId) {
                    ComposerActions.discardMessageConfirmed()
                }
            })
            // If for some wild reason the composer get's reset while the confirmation
            // dialog is up just cancel all bindings.
            once(ComposerKeys.resetComposer, exit.bind(this, 0))
        }
    }

    Filter {
        type: ComposerKeys.resetComposer
        onDispatched: {
            Log.logStatus("ComposerStore::resetComposer", "Resetting composer ready for next message")
            d.ccVisible = false
            d.bccVisible = false
            identities.reset()
            submissionManager.reset()
        }
    }

    Filter {
        type: ComposerKeys.addCC
        onDispatched: {
            Log.logInfo("ComposerStore::addCC", "Displaying CC field")
            d.ccVisible = true
        }
    }

    Filter {
        type: ComposerKeys.addBCC
        onDispatched: {
            Log.logInfo("ComposerStore::addBCC", "Displaying BCC field")
            d.bccVisible = true
        }
    }

    Filter {
        type: ComposerKeys.sendMessage
        onDispatched: {
            Log.logInfo("ComposerStore::sendMessage", "Sending message...")
            d.sendInProgress = true
            d.sendTimer.start()
        }
    }

    Filter {
        type: ComposerKeys.respondToMessage
        onDispatched: {
            Log.logInfo("ComposerStore::replyToMessage", "Constructing reply message for msg: " + message.msgId)
            ViewActions.openMessageComposer()
            submissionManager.respondToMessage(message.type, message.msgId)
        }
    }

    Filter {
        type: ComposerKeys.forwardMessage
        onDispatched: {
            Log.logInfo("ComposerStore::forwardMessage", "Constructing message to forward")
            ViewActions.openMessageComposer()
            submissionManager.forwardMessage(message.type, message.msgId)
        }
    }

    Filter {
        type: ComposerKeys.saveDraft
        onDispatched: {
            Log.logInfo("ComposerStore::saveDraft", "Saving draft...")
            submissionManager.saveDraft(true)
            ViewActions.closeComposer()
            ComposerActions.resetComposer()
        }
    }

    Filter {
        type: ComposerKeys.addFileAttachment
        onDispatched: {
            if (message.url.isEmpty()) {
                Log.logWarning("ComposerStore::addFileAttachment", "Attachment url is empty")
                return;
            }
            Log.logInfo("ComposerStore::addFileAttachment", "Adding %1 to attachments".arg(message.url))
            builder.addFileAttachment(message.url)
        }
    }

    Filter {
        type: ComposerKeys.removeAttachment
        onDispatched: {
            Log.logInfo("ComposerStore::removeAttachment", "Removing attachment at index: %1".arg(message.index))
            builder.removeAttachment(message.index)
        }
    }

    Filter {
        type: ComposerKeys.addRecipientFromContacts
        onDispatched: {
            Log.logWarning("ComposerStore::addRecipientFromContacts", "Not implemented yet")
        }
    }

    Filter {
        type: ComposerKeys.appendTextToBody
        onDispatched: {
            builder.appendTextToBody(message.text)
        }
    }

    Filter {
        type: ComposerKeys.openDraft
        onDispatched: {
            Log.logInfo("ComposerStore::openDraft", "Constinuing draft message")
            ViewActions.openMessageComposer()
            submissionManager.reloadDraft(message.draftId)
        }
    }

    Filter {
        type: ComposerKeys.composeMailtoUri
        onDispatched: {
            builder.composeMailTo(message.mailto)
            // we need to delay this now as we may have actually only just been opened
            // and the various stores are still getting initialized as the UI is constructed
            delayOpenComposer.start()
        }
    }

    Timer {
        id: delayOpenComposer
        interval: 500 // this should be plenty long enough
        repeat: false
        onTriggered: ViewActions.openMessageComposer()
    }
}

