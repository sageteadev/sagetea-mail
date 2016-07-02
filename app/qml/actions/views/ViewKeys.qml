/* Copyright (C) 2016 Dan Chapman <dpniel@ubuntu.com>

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
pragma Singleton
import QtQuick 2.4
import QuickFlux 1.0

/*!
* @ingroup qml_actions
*/
KeyTable {

    // StageStack api
    property string stageStackReady
    property string pushStage
    property string popStage
    property string clearStageStack
    property string runSetupWizard

    // messagelistview
    property string openNavDrawer
    property string closeNavDrawer
    property string toggleNavDrawer
    property string expandNavPanel
    property string collapseNavPanel

    property string positionMessageListAtStart
    property string openMessageComposer
    property string closeMessageComposer
    property string replyToOpenMessage
    property string detachComposer
    property string attachComposer

    property string resetPanelWidths

    // StageArea api
    property string pushToStageArea
    property string replaceTopStageAreaItem
    property string popStageArea
    property string clearStageArea

    // Compose panel API
    property string openComposer
    property string setComposePanelSource
    property string closeComposer
    // These are not actions as such but keys for the stagearea's
    // They are used to determine which StackView we are pushing a page to
    // via pushToStage(stackID, ....)
    // NOTE: When creating a new StageArea add a key for it here
    property string navigationStack
    property string messageListStack
    property string messageViewStack

    property string orderSimpleToast
    property string orderSubtitledToast
    property string orderComplexToast

    property string setCurrentNavFolder
}
