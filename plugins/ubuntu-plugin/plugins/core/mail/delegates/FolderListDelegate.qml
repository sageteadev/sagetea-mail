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
import SageteaMail.Mail 1.0
import SageteaMail.Components 1.0
import SageteaMail.Lomiri.Components 1.0

ListItemWithActions {

    property var folder
    property bool actionsEnabled: false


    function getIconForFolderType(f) {
        switch (f.type) {
        case Folder.StandardFolder:
            return Icons.InboxIcon
        case Folder.SpecialUseInboxFolder:
            return Icons.CombineInboxIcon
        case Folder.SpecialUseOutboxFolder:
            return Icons.InboxIcon
        case Folder.SpecialUseDraftsFolder:
            return Icons.DraftIcon
        case Folder.SpecialUseSentFolder:
            return Icons.SendIcon;
        case Folder.SpecialUseTrashFolder:
            return Icons.DeleteIcon
        case Folder.SpecialUseJunkFolder:
            return Icons.JunkIcon
        }
    }

    property list<Action> ctxtActions: [
        Action {
            id: favouriteFolder
            text: folder && folder.isFavourite ? qsTr("Un-favourite") : qsTr("Favourite")
            iconSource: folder && folder.isFavourite ? Paths.actionIconUrl(Paths.UnStarredIcon) :
                                                       Paths.actionIconUrl(Paths.StarredIcon)
            onTriggered: folder.isFavourite = !folder.isFavourite
        }
    ]


    rightSideActions: actionsEnabled ? ctxtActions : []

    height: layout.height
    anchors {
        left: parent.left
        right: parent.right
    }
    showDivider: false
    showActionHighlight: false

    ListItemLayout {
        id: layout
        height: units.gu(5)
        title.text: folder ? folder.name : ""
        CachedImage {
            id: attachmentImg
            height: units.gu(3)
            width: height
            name: getIconForFolderType(folder)
            color: LomiriColors.ash
            SlotsLayout.position: SlotsLayout.Leading
            CachedImage {
                id: favoriteIcon
                height: units.gu(1.75)
                width: height
                visible: folder.isFavourite
                anchors {
                    bottom: parent.top
                    bottomMargin: -units.gu(1.25)
                    leftMargin: -units.gu(1.25)
                    left: parent.right
                }
                color: "#f0e442"
                name: Icons.StarredIcon
            }
        }
        LomiriShape {
            id: shape
            visible: folder.unreadCount > 0
            aspect: LomiriShape.Flat
            color: Suru.secondaryBackgroundColor
            height: units.gu(2.2)
            width: countLable.width < height ? height : countLable.width + units.gu(1)
            Label {
                id: countLable
                anchors.margins: units.gu(0.5)
                anchors.centerIn: parent
                fontSize: "small"
                text: folder.unreadCount
            }
        }
        padding.leading: 1 * units.gu(folder.nestingDepth) + units.gu(2)
    }
}

