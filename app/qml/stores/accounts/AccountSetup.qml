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
import "../../actions/wizard"
import "../../actions/logging"
import "../../views/utils/QtCoreAPI.js" as QtCoreAPI

AppListener {
    id: accountSetup

    // We emit these signals for the DSM.SignalTransition's
    signal createAccount()
    signal goBack()
    signal goNext()
    signal userDetailsSet()
    // new account accessor for the setupwizard
    property NewAccount account: newAccount.createObject(accountSetup)

    // Properties regarding new account type
    readonly property alias isPreset: d.isPresetAccount
    readonly property alias isImap: d.isImapAccount
    readonly property alias isPop3: d.isPopAccount
    readonly property alias needsValidation: d.shouldValidate
    readonly property alias accountDescripion: d.accountDescripion
    readonly property alias hasProvider: d.hasProvider

    // New account object
    // This is a subclass of Account that allows editing of
    // an invalid account before comitting to the QMailStore
    Component {
        id: newAccount
        NewAccount {
        }
    }

    AutoDiscover {
        id: autoDiscover
        onSuccess: {
            Log.logStatus("AccountSetup::AutoDiscover", "Lookup succeeded!")
            console.log("SUCCESS!")
            d.emailProvider = _serverConf
//            // Check there is a server config for the selected account type
            WizardActions.checkProviderForAccountType()
        }
        onFailed: {
            Log.logWarning("AccountSetup::AutoDiscover", "Lookup failed!")
            WizardActions.noServerDetailsFound()
        }
    }
    // TODO: logging
    AccountValidator {
        id: validator
        onSuccess: {
            WizardActions.wizardResetAccount()
            accountSetup.goNext()
        }
        onValidationFailed: {
            WizardActions.requestManualInput()
        }
    }

    Filter {
        type: WizardKeys.setNewAccountType
        onDispatched: {
            d.accountDescripion = message.description
            var type = message.type
            switch (message.type) {
            case AccountConfig.IMAP:
                d.isImapAccount = true;
                break;
            case AccountConfig.POP3:
                d.isPopAccount = true;
                break;
            case AccountConfig.SMTP:
                type = AccountConfig.IMAP
                break;
            }
            account.setSourceType(type)
        }
    }
    Filter {
        type: WizardKeys.setUserDetails
        onDispatched: {
            var details = message.details
            // Name is username for imap/pop
            account.incoming.name = details.email
            account.incoming.email = details.email
            account.incoming.password = details.password
            account.outgoing.name = details.name
            account.outgoing.email = details.email
            account.outgoing.username = details.email
            account.outgoing.password = details.password
            Log.logInfo("AccountSetup::setUserDetails: ", "name: %1, email: %2".arg(details.name).arg(details.email))
            accountSetup.userDetailsSet()
        }
    }

    Filter {
        type: WizardKeys.validateUser
        onDispatched: {
            var user = message.user
            var valid = true
            var invalidField = new Array();
            if (user.name.isEmpty()) {
                valid = false
                invalidField.push("name")
            }
            if (!EmailValidator.validate(user.email)) {
                valid = false
                invalidField.push("email")
            }
            if (!valid) {
                //we want to signal this first as the user may want an empty password field
                WizardActions.userDetailsInvalid(invalidField)
            } else if (!d.allowEmptyPassword && user.password.isEmpty()) {
            // if the password is empty and the user hasn't confirmed it then
            // We have to prompt for them to allow it.
                WizardActions.noPasswordSet()
            } else {
                WizardActions.userDetailsValid()
            }
        }
    }

    Filter {
        type: WizardKeys.setNoPasswordAllowed
        onDispatched: {
            d.allowEmptyPassword = true
        }
    }

    Filter {
        type: WizardKeys.wizardStepBack
        onDispatched: {
            // We don't actually want to do anything here
            // as we need to be sure the wizardStepBack listener on the StackView
            // pops the page before emitting goBack, otherwise
            // we end up with a push instead of pop
        }
    }
    Filter {
        type: WizardKeys.wizardStepForward
        onDispatched: {
            accountSetup.goNext()
        }
    }

    Filter {
        type: WizardKeys.wizardSetAccountPreset
        onDispatched: {
            var cfg = message.config
            if (cfg.type !== Provider.PRESET) {
                Log.logError("AccountSetup::wizardSetPreset", "Passed config not of type Provider.PRESET. Aborting...")
                return
            }
            Log.logInfo("AccountSetup::wizardSetPreset", "ImapHost: %1, Port: %2".arg(cfg.imapHost).arg(cfg.imapPort))
            account.incoming.server = cfg.imapHost
            account.incoming.port = cfg.imapPort
            account.incoming.encryption = d.getPresetEncryptionMethod(cfg.imapStartTLS, cfg.imapUseSSL)
            account.incoming.saslMechanism = AccountConfig.LOGIN
            account.outgoing.server = cfg.smtpHost
            account.outgoing.port = cfg.smtpPort
            account.outgoing.encryption = d.getPresetEncryptionMethod(cfg.smtpStartTLS, cfg.smtpUseSSL)
            account.outgoing.saslMechanism = AccountConfig.LOGIN
            d.isPresetAccount = true
        }
    }

    Filter {
        type: WizardKeys.lookForServerDetails
        onDispatched: {
            if (EmailValidator.validate(account.incoming.email)) {
                Log.logInfo("AccountSetup::lookForServerDetails", "Starting autodiscover......")
                autoDiscover.lookUp(account.incoming.email)
            } else {
                // We can't work here without an email address
                // so as to not bother anyone just dispatch that we couldn't find anything
                WizardActions.noServerDetailsFound()
                Log.logWarning("AccountSetup::lookForServerDetails", "Invalid email address. Signalled no details were found!")
            }
        }
    }

    Filter {
        type: WizardKeys.checkProviderForAccountType
        onDispatched: {
            if (d.isPopAccount && d.emailProvider.hasImapConfiguration() && d.emailProvider.hasPopConfiguration()) {
                Log.logInfo("AccountSetup::checkProviderForAccountType", "Asking if user would prefer to use imap")
                WizardActions.askAboutImapInstead()
                return;
            }
            if (d.isPopAccount && d.emailProvider.hasPopConfiguration()) {
                Log.logInfo("AccountSetup::checkProviderForAccountType", "Pop configuration found. Needs validating")
                d.shouldValidate = true
            }
            if (d.isImapAccount && d.emailProvider.hasImapConfiguration()) {
                Log.logInfo("AccountSetup::checkProviderForAccountType", "Imap configuration found. Needs validating")
                d.shouldValidate = true
            }
            accountSetup.goNext()
        }
    }

    Filter {
        type: WizardKeys.runAccountValidation
        onDispatched: {
            account.save()
            if (d.isImapAccount) {
                var imap = account.incoming
                imap.idleEnabled = true
                imap.appendPushFolder("INBOX")
                imap.checkInterval = 5
                account.save()
                console.log("IDLE enabled", imap.idleEnabled)
                console.log("Push Folders: ", imap.pushFolders)
            }
            // Delay this starting to allow time for the
            // the messageserver tobe notified of the new account
            delayValidate.start()
        }
    }

    Timer {
        id: delayValidate
        interval: 500 // probably overkill :-)
        repeat: false
        onTriggered: validator.validateAccount(account)
    }

    Filter {
        type: WizardKeys.validateConfigToUse
        onDispatched: {
            Log.logStatus("AccountSetup::validateConfigToUse", "Determining which config to use")
            // TODO: iterate over configs to find the one that works
            // FOr now were just using the 1st config and request manual input if that fails
            if (d.isPopAccount && d.emailProvider.hasPopConfiguration()) {
                var pop = d.emailProvider.getFirstPopConfig()
                account.incoming.server = pop.hostname
                account.incoming.port = pop.port
                account.incoming.encryption = d.getEncryptionMethodFromConfig(pop.socket)
                account.incoming.saslMechanism = d.getSaslFromConfig(pop.mechanism)
            }
            if (d.isImapAccount && d.emailProvider.hasImapConfiguration()) {
                var imap = d.emailProvider.getFirstImapConfig()
                account.incoming.server = imap.hostname
                account.incoming.port = imap.port
                account.incoming.encryption = d.getEncryptionMethodFromConfig(imap.socket)
                account.incoming.saslMechanism = d.getSaslFromConfig(imap.mechanism)
            }
            if (!d.emailProvider.hasSmtpConfiguration()) {
                WizardActions.requestManualInput()
            } else {
                var smtp = d.emailProvider.getFirstSmtpConfig()
                account.outgoing.server = smtp.hostname
                account.outgoing.port = smtp.port
                account.outgoing.encryption = d.getEncryptionMethodFromConfig(smtp.socket)
                account.outgoing.saslMechanism = d.getSaslFromConfig(smtp.mechanism)
            }
            WizardActions.validateIfAccountHasEnoughCredentials()
        }
    }

    Filter {
        type: WizardKeys.validateCredentials
        onDispatched: {
            if (d.isPresetAccount) {
                Log.logInfo("AccountSetup::validateCredentials", "Is preset account validating now.")
                WizardActions.runAccountValidation()
            } else if (d.hasProvider) {
                Log.logInfo("AccountSetup::validateCredentials", "Has provider, determining valid config to use")
                WizardActions.validateConfigToUse()
            } else {
                Log.logInfo("AccountSetup::validateCredentials", "Ok... checking if we have enough info to validate")
                WizardActions.validateIfAccountHasEnoughCredentials()
            }
        }
    }

    Filter {
        type: WizardKeys.validateIfAccountHasEnoughCredentials
        onDispatched: {
            if (d.accountIsSavable()) {
                WizardActions.runAccountValidation()
            } else {
                WizardActions.requestManualInput()
            }
        }
    }

    Filter {
        type: WizardKeys.useImapInstead
        onDispatched: {
            Log.logInfo("AccountSetup::useImapInstead", "Switching to imap setup")
            d.isPopAccount = false
            d.isImapAccount = true
            // TODO: Reset the NewAccount to create an ImapAccountConfiguration
            accountSetup.goNext()
        }
    }

    Filter {
        type: WizardKeys.stickWithPop
        onDispatched: accountSetup.goNext()
    }

    Filter {
        type: WizardKeys.wizardResetAccount
        onDispatched: {
            // TODO: reset account
            Log.logError("AccountSetup::resetAccount", "FIXME: implement account reset")
            d.isPresetAccount = false
            d.isImapAccount = false
            d.isPopAccount = false
            d.accountDescripion = ""
            d.allowEmptyPassword = false
            d.emailProvider = undefined
            d.shouldValidate = false
            account = newAccount.createObject(accountSetup)
        }
    }

    // We don't expose any utility functions or properties, as developers
    // should dispatch actions via the actions api's.
    QtObject {
        id: d
        property bool isImapAccount: false
        property bool isPopAccount: false
        property bool isPresetAccount: false
        property string accountDescripion: ""
        property bool allowEmptyPassword: false
        property var emailProvider: undefined
        property bool shouldValidate: false
        property bool hasProvider: emailProvider !== undefined

        function getPresetEncryptionMethod(useStartTls, useSsl) {
            if (useSsl && useStartTls) {
                return AccountConfig.SSL;
            } else if (useStartTls) {
                return AccountConfig.STARTTLS;
            } else {
                return AccountConfig.NONE;
            }
        }

        function getEncryptionMethodFromConfig(socket) {
            switch(socket) {
            case ServerConfig.SSL:
                return AccountConfig.SSL
            case ServerConfig.STARTTLS:
                return AccountConfig.STARTTLS
            case ServerConfig.PLAIN:
                return AccountConfig.NONE
            }
        }

        function getSaslFromConfig(sasl) {
            switch(sasl) {
            case ServerConfig.CRAM_MD5:
                return AccountConfig.CRAM_MD5
            case ServerConfig.LOGIN:
                return AccountConfig.LOGIN
            case ServerConfig.NTLM:
            case ServerConfig.GSSAPI:
            case ServerConfig.CLIENT_IP:
                return AccountConfig.PLAIN
            case ServerConfig.INVALID:
                return AccountConfig.NONE
            }
        }

        function serverUsable(server) {
            if ((server.server !== "") &&
                    (server.port !== 0) &&
                    (server.name !== "") &&
                    (server.email !== "")) {
                return true;
            } else {
                return false;
            }

        }

        function accountIsSavable() {
            if (!serverUsable(account.incoming)) {
                return false
            }
            return serverUsable(account.outgoing)
        }
    }
}


