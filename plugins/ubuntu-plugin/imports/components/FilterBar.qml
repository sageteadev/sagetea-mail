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
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3
import SageteaMail.Components 1.0
import SageteaMail.Lomiri.Constants 1.0

Item {
    id: filterBar

    property var filterSections: []
    property alias selectedIndex: row.currentIndex
    height: units.gu(0)
    width: parent.width

    Behavior on height {
        LomiriNumberAnimation {duration: LomiriAnimation.SnapDuration}
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Suru.backgroundColor
    }

    ListView {
        id: row
        anchors {
            fill: parent
            leftMargin: Style.defaultSpacing
        }
        highlightFollowsCurrentItem: true
        clip: true
        snapMode: ListView.SnapToItem
        orientation: ListView.Horizontal
        layoutDirection: ListView.LeftToRight
        cacheBuffer: units.gu(500)
        currentIndex: 0
        model: filterSections
        delegate: AbstractButton {
            id: d
            width: label.implicitWidth + units.gu(3.5)
            height: parent.height
            Rectangle {
                anchors {
                    fill: parent
                }
                color: Suru.neutralColor
                visible: d.pressed
            }

            Label {
                id: label
                text: modelData
                color: row.currentIndex === model.index ? LomiriColors.blue : Suru.tertiaryForegroundColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: units.gu(0.2)
                fontSize: "small"
                renderType: Text.NativeRendering
            }
            Rectangle {
                color: row.currentIndex === model.index ? LomiriColors.blue : Suru.neutralColor
                height: units.dp(2)
                width: parent.width
                anchors.bottom: parent.bottom
            }
            onClicked: row.currentIndex = model.index
        }

    }
}
