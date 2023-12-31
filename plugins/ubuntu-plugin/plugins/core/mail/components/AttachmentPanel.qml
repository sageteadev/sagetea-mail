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
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3
import SageteaMail.Components 1.0
import SageteaMail.Mail.API 1.0
import SageteaMail.Mail.Stores.Composer 1.0
import SageteaMail.Lomiri.Constants 1.0
import SageteaMail.Lomiri.Components 1.0
import "../delegates"

Rectangle {
    id: attachmentPanel

    property var attachments
    property bool isReadOnly
    property int maxHeight
    property int attachmentDelegateHeight: units.gu(6)
    readonly property int expandedHeight: internalHeight > maxHeight ? maxHeight : internalHeight
    readonly property int internalHeight: header.height + attachmentList.contentHeight
    readonly property int collapsedHeight: attachmentPanel.visible ? header.height : 0
    readonly property bool expanded: state === "expanded"
    color: Suru.backgroundColor
    visible: attachments.count

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse.accepted = true
        onWheel: wheel.accepted = true
    }
    Line {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
    }

    ListItem {
        id: header
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: units.gu(6)
        onClicked: d.isExpanded = !d.isExpanded

        CachedImage {
            id: ai
            name: Icons.AttachmentIcon
            height: Style.defaultIconSize
            width: height
            anchors {
                left: parent.left
                leftMargin: Style.defaultSpacing
                verticalCenter: parent.verticalCenter
            }
        }

        Label {
            id: l
            anchors {
                left: ai.right
                leftMargin: Style.smallSpacing
                verticalCenter: parent.verticalCenter
            }
            text: qsTr("Attachments")
        }

        LomiriShape {
            id: shape
            anchors {
                left: l.right
                leftMargin: Style.smallSpacing
                verticalCenter: parent.verticalCenter
            }

            aspect: LomiriShape.Flat
            color: Suru.secondaryBackgroundColor
            height: units.gu(2.2)
            width: countLable.width < height ? height : countLable.width + Style.smallSpacing
            Label {
                id: countLable
                anchors.margins: units.gu(0.5)
                anchors.centerIn: parent
                fontSize: "small"
                text: attachments.count
            }
        }

        Icon {
            id: icon
            name: "up"
            anchors {
                right: parent.right
                rightMargin: Style.defaultSpacing
                verticalCenter: parent.verticalCenter
            }
            color: LomiriColors.ash
            rotation: attachmentPanel.expanded ? 180 : 0
            height: Style.defaultSpacing; width: height
            state: attachmentPanel.expanded ? "rotated" : "normal"
            states: [
                State {
                    name: "rotated"
                    PropertyChanges { target: icon; rotation: 180 }
                },
                State {
                    name: "normal"
                    PropertyChanges { target: icon; rotation: 0 }
                }
            ]
            transitions: Transition {
                RotationAnimation {
                    duration: LomiriAnimation.FastDuration
                    direction: icon.state === "normal"  ? RotationAnimation.Clockwise : RotationAnimation.Counterclockwise
                }
            }
        }
    }

    ScrollView {
        anchors {
            left: parent.left
            top: header.bottom
            right: parent.right
            bottom: parent.bottom
        }

        ListView {
            id: attachmentList
            anchors.fill: parent
            add: DekkoAnimation.listViewAddTransition
            addDisplaced: DekkoAnimation.listViewAddDisplacedTransition
            remove: DekkoAnimation.listViewRemoveTransition
            removeDisplaced: DekkoAnimation.listViewRemoveDisplacedTransition
            model: attachments ? attachments : 0
            delegate: AttachmentDelegate {
                height: attachmentDelegateHeight
                leftSideAction: isReadOnly ? 0 : ComposerStore.actions.deleteAttachment
            }
        }
    }

    QtObject {
        id: d
        property bool isExpanded: false
    }

    Behavior on height {
        LomiriNumberAnimation{}
    }

    state: d.isExpanded ? "expanded" : "collapsed"
    states: [
        State {
            name: "collapsed"
            PropertyChanges {
                target: attachmentPanel
                height: collapsedHeight
            }
        },
        State {
            name: "expanded"
            PropertyChanges {
                target: attachmentPanel
                height: expandedHeight
            }
        }
    ]
}

