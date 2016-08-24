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
import QtQuick 2.4
import QuickFlux 1.0
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.1
import "../actions/composer"
import "../actions/content"
import "../actions/logging"
import "../actions/views"
import "../views/dialogs"
import "../stores"

/*!
*
* ContentWorker
*
* The ContentWorker is responsible for the import and export of content.
* Whether that's by ContentHub on unity8 or using the native platform pickers
*
* Users of the ContentActions API should not be concerned with the platform they
* are on as that is all handled here.
*
* @ingroup qml_worker
*/
AppListener {

    waitFor: [ViewStore.listenerId]
    property string pickerUrl: ""

    Connections {
        target: ContentHub
        onImportRequested: {
            Log.logStatus("[ContentHub::importRequested]", "import requested, running import...")
            ContentActions.importFromContentHub(transfer)
        }
        onShareRequested: {
            Log.logStatus("[ContentHub::shareRequested]", "share requested. importing share")
            ContentActions.importFromContentHub(transfer)
        }
        onExportRequested: {
            Log.logStatus("ContentHub::exportRequested",  "NotImplementedYet")
        }
    }

    AppScript {
        runWhen: ContentKeys.pickFile
        script: {
            // First open the file picker for the platform
            // This will either be the ContentHub picker
            // or Qt's own FileDialog for non unity8 platforms
            ContentActions.openFilePicker()
            // Listen on selected files and add them to the composer
            once(ContentKeys.filesSelected, function(message) {
                console.log("FILES: ", message.files)
                var files = message.files
                for (var i in message.files) {
                    console.log("File: ", message.files[i])
                    var file = message.files[i]
                    ComposerActions.addFileAttachment(file.toString().replace("file://", ""))
                }
            })
            // Drop all callbacks if the picker is closed with no selections
            once(ContentKeys.pickerClosed, exit.bind(this, 0))
        }
    }

    Filter {
        type: ContentKeys.openFilePicker
        onDispatched: {
            if (isRunningOnMir) {
                var chPicker = PopupUtils.open("qrc:/qml/views/dialogs/ContentPickerDialog.qml", dekko, {isExport: false})
                chPicker.filesImported.connect(function(files){
                    var imports = new Array()
                    for (var i in files) {
                        Log.logInfo("ContentManager::filesPicked", "File selected: %1".arg(files[i].url))
                        imports.push(files[i].url)
                    }
                    ContentActions.filesSelected(imports)
                })
            } else {
                var c = Qt.createComponent("qrc:/qml/views/dialogs/FilePickerDialog.qml")
                var filePicker = c.createObject(dekko)
                filePicker.accepted.connect(function(){
                    var files = new Array()
                    for (var i in filePicker.fileUrls) {
                        Log.logInfo("ContentManager::filesPicked", "File selected: %1".arg(filePicker.fileUrls[i]))
                        files.push(filePicker.fileUrls[i])
                    }
                    ContentActions.filesSelected(files)
                    filePicker.close()
                    filePicker.destroy()
                })
                filePicker.rejected.connect(function() {
                    Log.logInfo("ContentManager::filePickerRejected", "No attachments selected")
                    ContentActions.pickerClosed()
                })
            }
        }
    }

    Filter {
        type: ContentKeys.importFromContentHub
        onDispatched: {
            if (message.transfer.length === 0) {
                Log.logWarning("ContentManager::importFromContentHub", "Not items to transfer :-/")
                return
            }
            Log.logInfo("ContentManager::importFromContentHub", "Number of transferred items: " + message.transfer.items.length)
            // open the composer
            ViewActions.openComposer()
            for (var item in message.transfer.items) {
                var url = message.transfer.items[item].url
                Log.logInfo("ContentManager::importFromContentHub", "Item url: " + url)
                var text = message.transfer.items[item].text
                Log.logInfo("ContentManager::importFromContentHub", "Item text: " + text)
                switch (message.transfer.contentType) {
                case ContentType.Links:
                    Log.logInfo("ContentManager::importFromContentHub", "ContentType is Link: " + url.toString())
                    ComposerActions.appendTextToBody(url.toString())
                    break;
                case ContentType.Text:
                    Log.logInfo("ContentManager::importFromContentHub", "ContentType is Text: " + text)
                    ComposerActions.appendTextToBody(text)
                    break;
                default:
                    Log.logInfo("ContentManager::importFromContentHub", "ContentType is Other, most likely a file: " + url.toString())
                    ComposerActions.addFileAttachment(url.toString())
                    break;
                }
            }
        }
    }

    Filter {
        type: ContentKeys.exportFile
        onDispatched: {
            PopupUtils.open("qrc:/qml/views/dialogs/ContentPickerDialog.qml", dekko, {fileUrl: message.file})
        }
    }
}
