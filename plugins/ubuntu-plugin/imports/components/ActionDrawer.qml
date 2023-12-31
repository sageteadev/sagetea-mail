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
import QtQuick.Layouts 1.1
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3
import SageteaMail.Lomiri.Constants 1.0

Item {
    id: actionsDrawer

    anchors {
        top: parent.bottom
        right: parent.right
    }
    width: units.gu(22)
    height: actionsColumn.height
    clip: actionsColumn.y != 0
    visible: false

    actions: dekkoHeader.actions

    function close() {
        opened = false;
    }

    property bool opened: false
    property list<Action> actions

    onOpenedChanged: {
        if (opened)
            visible = true;
    }

    Rectangle {
        id: btmshadow
        anchors {
            left: parent.left
            right: parent.right
            top: parent.bottom
        }
        height: units.gu(0.6)
        gradient: Gradient {
            GradientStop { position: 1.0; color: "transparent" }
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.2) }
        }
    }
    HorizontalGradiant {
        id: sideShadow
        anchors {
            right: parent.left
            bottom: btmshadow.bottom
            bottomMargin: units.gu(0.3)
            top: parent.top
        }
        width: units.gu(0.6)
        rightToLeft: true
        gradient: Gradient {
            GradientStop { position: 1.0; color: "transparent" }
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.2) }
        }
    }

    InverseMouseArea {
        anchors.fill: parent
        onPressed: actionsDrawer.close();
        enabled: actionsDrawer.opened
    }

    Column {
        id: actionsColumn
        anchors {
            left: parent.left
            right: parent.right
        }
        y: actionsDrawer.opened ? 0 : -height
        Behavior on y { LomiriNumberAnimation {} }

        onYChanged: {
            if (y == -height)
                actionsDrawer.visible = false;
        }

        Repeater {
            model: actionsDrawer.actions.length > 0 ? actionsDrawer.actions : 0
            delegate: AbstractButton {
                id: actionButton
                objectName: "actionButton" + label.text
                anchors {
                    left: actionsColumn.left
                    right: actionsColumn.right
                }
                height: units.gu(6)
                enabled: action.enabled

                action: modelData
                onClicked: actionsDrawer.close()

                Rectangle {
                    anchors.fill: parent
                    color: actionButton.pressed ? Qt.darker(Suru.backgroundColor) : Suru.backgroundColor
                }

                Label {
                    id: label
                    anchors {
                        left: icon.right
                        leftMargin: Style.defaultSpacing
                        right: parent.right
                        rightMargin: Style.defaultSpacing
                        verticalCenter: parent.verticalCenter
                    }
                    text: model.text
                    fontSize: "medium"
                    elide: Text.ElideRight
                }

                Icon {
                    id: icon
                    anchors {
                        left: parent.left
                        leftMargin: Style.defaultSpacing
                        verticalCenter: parent.verticalCenter
                    }
                    width: height
                    height: label.paintedHeight
                    color: label.color
                    name: model.iconName
                }
            }
        }
    }
}
