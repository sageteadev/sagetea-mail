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
import SageteaMail.Mail.Settings 1.0
import SageteaMail.Lomiri.Components 1.0

PageFlickable {
    id: displaySettings

    SectionHeader {
        textMargin: 0
        text: qsTr("Message content")
    }

    LabeledSwitch {
        text: qsTr("Allow remote content")
        checked: PolicyManager.privacy.allowRemoteContent
        onCheckedChanged: {
            if (checked !== PolicyManager.privacy.allowRemoteContent) {
                PolicyManager.privacy.allowRemoteContent = checked
            }
        }
    }
}
