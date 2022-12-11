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
import PlugMan 1.0
import Dekko.Contacts 1.0
import SageteaMail.Mail.API 1.0

// This component should be created using an async loader
// The containing workers should not be required immediately
// but be available shortly after app start.

// We will also load all plugins that registered as a "SageteaMail::Listener"
// TODO: !This seems to be unused!
ListenerRegistry {
    defaultListeners: [
        AccountsWorker {},
        MailboxWorker {},
        SettingsWorker {},
        UriWorker {},
        DialogWorker {},
        ErrorsWorker {},
        ToastWorker {},
        ContactsWorker{
            onPluginsReady: ViewActions.delayCall(ContactKeys.registerAddressBooks)
        }
    ]


}
