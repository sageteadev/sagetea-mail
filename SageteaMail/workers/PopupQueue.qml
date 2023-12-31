/* Copyright (C) 2014-2016 Dan Chapman <dpniel@ubuntu.com>

   This file is part of Dekko email client for Ubuntu Devices/

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

// NOTE when queuing a popup make sure to add the parent and properties, even if the properties is empty {}
// USAGE: popupQueue.queue("PopupPath", root, {})
QtObject {
    id: popupQueue

    readonly property bool popupVisible: __popupOnScreen
    readonly property int queueSize: __popups.length

    property bool __popupOnScreen: false
    // List of queued popups
    property var __popups: []
    // List of properties to be attched to the popups
    property var __properties: []
    // List of popup parent's
    property var __parents: []

    property Timer __timer: Timer {
        id: timer
        interval: 20
        repeat: false
        onTriggered: {
            if (!__popups.length) {
                return;
            }
            console.log("Popup queue triggered")
            if (!__popupOnScreen && __popups.length) {
                __showNextPopup(__popups.shift(), __parents.shift(), __properties.shift());
            }
        }
    }

    function queue(popup, parent, properties) {
        __popups.push(popup)
        __parents.push(parent)
        __properties.push(properties)
        timer.start()
    }

    function __showNextPopup(popup, parent, properties) {
        var nextPopup = PopupUtils.open(popup, parent, properties)
        nextPopup.closing.connect(__popupOnScreenClosed)
        __popupOnScreen = true
    }

    function __popupOnScreenClosed() {
        __popupOnScreen = false
        // Trigger the next one
        timer.start()
    }
}
