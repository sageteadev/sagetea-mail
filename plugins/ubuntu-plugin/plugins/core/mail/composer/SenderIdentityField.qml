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
import SageteaMail.Mail.Accounts 1.0
import SageteaMail.Components 1.0
import SageteaMail.Mail.API 1.0
import SageteaMail.Mail.Stores.Composer 1.0
import SageteaMail.Lomiri.Constants 1.0
import SageteaMail.Lomiri.Components 1.0

FocusScope {
    id: root
    width: parent.width
    height: state === "collapsed" ? from.height : from.height + col.height
    clip: true

    Item {
        id: from
        height: units.gu(4)
        width: parent.width
        StretchRow {
            anchors {
                leftMargin: Style.smallSpacing
                fill: parent
                rightMargin: units.gu(1.75)
            }
            spacing: Style.defaultSpacing

            Label {
                id: type
                anchors {
                    left: parent.left
                    top: parent.top
                    leftMargin: Style.smallSpacing
                    topMargin: Style.smallSpacing
                }
                text: qsTr("From:")
            }

            Stretcher {

                LomiriShape {
                    id: delegate
                    aspect: LomiriShape.Flat
                    color: Qt.rgba(0, 0, 0, 0.05)
                    radius: "small"
                    height: units.gu(3)
                    width: inner_avatar.width + label.width + units.gu(1.5)
                    implicitHeight: height
                    implicitWidth: width
                    visible: ComposerStore.hasValidIdentity
                    anchors {
                        left: parent.left
                        top: parent.top
                        topMargin: units.gu(0.5)
                    }

                    Avatar {
                        id: inner_avatar
                        width: height
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            margins: units.dp(1)
                        }
                        name: ComposerStore.identity.name
                        initials: ComposerStore.identity.initials
                        email: ComposerStore.identity.email
                        fontSize: "x-small"
                        validContact: true
                    }

                    Label {
                        id: label
                        anchors {
                            left: inner_avatar.right
                            leftMargin: units.gu(0.5)
                            verticalCenter: parent.verticalCenter
                        }
                        text: ComposerStore.identity.name
                    }
                }
            }
            Icon {
                height: units.gu(2.25)
                width: height
                anchors {
                    top: parent.top
                    topMargin: Style.smallSpacing
                }
                name: root.state === "collapsed" ? "down" : "up"
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: root.state === "collapsed" ? root.state = "expanded" : root.state = "collapsed"
        }
    }

    Column {
        id: col
        anchors {
            left: parent.left
            right: parent.right
            top: from.bottom
        }

        Repeater {
            model: ComposerStore.identitiesModel
            delegate: ListItem {
                id: d
                property var wrapper: model.qtObject
                height: layout.height
                anchors {
                    left: parent ? parent.left : undefined
                    right: parent ? parent.right : undefined
                }
                Rectangle {
                    anchors.fill: parent
                    visible: ComposerStore.identityIndex === model.index
                    color: Qt.rgba(0, 0, 0, 0.05)
                }
                ListItemLayout {
                    id: layout
                    height: units.gu(5.5)
                    title.text: d.wrapper ? d.wrapper.identity.name : ""
                    subtitle.text: d.wrapper ? d.wrapper.identity.email : ""

                    Avatar {
                        height: units.gu(4.5)
                        width: height
                        name: d.wrapper ? d.wrapper.identity.name : ""
                        initials: d.wrapper ? d.wrapper.identity.initials : ""
                        email: d.wrapper ? d.wrapper.identity.email: ""
                        fontSize: "medium"
                        validContact: true
                        SlotsLayout.position: SlotsLayout.Leading
                    }
                }
                onClicked: {
                    root.state = "collapsed"
                    ComposerActions.setIdentity(model.index)
                }
            }
        }
    }
    state: "collapsed"
    states: [
        State {
            name: "collapsed"
        },
        State {
            name: "expanded"
        }
    ]
    Behavior on height {
        LomiriNumberAnimation{}
    }

    Line {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}

