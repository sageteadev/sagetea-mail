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
import SageteaMail.Components 1.0

PixelPerfectItem {
    id: tabBar
    property int currentIndex: 0
    property alias iconNameModel: rp.model
    height: units.gu(6)

    Row {
        id: actionRow
        width: parent.width
        height: parent.height

        Repeater {
            id: rp
            delegate: Rectangle {
                id: btn
                width: tabBar.width / 4
                height: parent.height
                AbstractButton {
                    anchors.fill: parent
                    onPressedChanged: pressed ? btn.color = LomiriColors.lightGrey : btn.color = "transparent"
                    onClicked: tabBar.currentIndex = model.index
                    Icon {
                        height: units.gu(2.5); width: height
                        name: modelData
                        anchors.centerIn: parent
                        color: tabBar.currentIndex === model.index ? LomiriColors.blue : LomiriColors.ash
                    }
                }
                Rectangle {
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        right: parent.right
                    }
                    height: units.dp(2)
                    color: tabBar.currentIndex === model.index ? LomiriColors.blue : LomiriColors.ash
                }
            }
        }
    }
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            top: tabBar.top
        }
        height: units.dp(1)
        color: LomiriColors.lightGrey
    }
}

