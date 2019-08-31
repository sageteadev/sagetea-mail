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
import Ubuntu.Components 1.3
import Dekko.Mail.API 1.0
import Dekko.Mail.Stores.Settings 1.0
import PlugMan 1.0
import Dekko.Ubuntu.Components 1.0

DekkoPage {
    pageHeader.title: qsTr("Notification Settings")
    pageHeader.backAction: Action {
        iconName: "back"
        onTriggered: {
            ViewActions.popStageArea(ViewKeys.settingsStack1)
        }
    }

    function isEnabled() {
        var val = getCustomSetting('enabled')
        if (val !== "") {
            return parseInt(val) > 0;
        }
        return false;
    }

    function getCustomSetting(key) {
        return SettingsStore.selectedAccount.customValue('dekko-notify', key);
    }

    function setCustomSetting(key, value) {
        SettingsStore.selectedAccount.setCustomValue('dekko-notify', key, value);
    }

    PageFlickable {
        LabeledSwitch {
            text: qsTr("Enabled")
            onCheckedChanged: {
                if (checked !== isEnabled()) {
                    setCustomSetting('enabled', checked ? '1' : '0');
                }
            }
            Component.onCompleted: {
                checked = isEnabled()
            }
        }
    }
}
