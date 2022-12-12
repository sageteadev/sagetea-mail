/* Copyright (C) 2016 - 2018 Dan Chapman <dpniel@ubuntu.com>

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
import Ubuntu.Web 0.2
import com.canonical.Oxide 1.15 as Oxide

Item {
    id: editor

    /** Focused state of the editor */
    readonly property bool focused: p.focused

    /** type:string Template to load into the editor */
    property alias template: p.template

    /** Undo state of the document */
    readonly property bool canUndo: p.undoState ? p.undoState['canUndo'] : false

    /** Redo state of the document */
    readonly property bool canRedo: p.undoState ? p.undoState['canRedo'] : false

    /**
     * type:object Font properties of the document
     *
     *  A subset of the Font type is supported
     *
     * Available properties are
     *
     * - family:String
     * - bold:Boolean
     * - italic:Boolean
     * - underline:Boolean
     * - size:Int
     * - textColor:Color
     * - highlightColor:Color
     */
    property alias font: p.font

    /**
     * Document contents have changed
     */
    signal contentChanged()

    /**
     * Formatting path of the document changed
     *
     * This can be used to as an indication to update
     * formatting option states
     *
     * @param path Formatting path to the cursor position or selected text
     */
    signal pathChanged(string path)

    /**
     * User has selected text in the document
     * @param text Selected text
     */
    signal textSelected(string text)

    /**
     * Requested document is now ready
     *
     * Calls to `getDocument()` are asynchronous, on retrievel this signal is emitted with
     * the documents contents
     *
     * @param document Document contents
     */
    signal documentReady(string document)

    /**
     * Cursor position changed in document
     * @param rect DOMRect object of the cursor position
     */
    signal cursorPositionChanged(var rect)

    onPathChanged: {
        console.log("PathChange: ", path)
        p.checkProps()
    }
    onFocusChanged: if (!focus) focusEditor(false)

    /** Undo user action */
    function undo() {
        if (canUndo) {
            wv.callFuncNoReply('undo')
        }
    }

    /** Redo user action */
    function redo() {
        if (canRedo) {
            wv.callFuncNoReply('redo')
        }
    }

    /**
     * Focus editor
     *
     * @param type:bool Should the editor get focus
     */
    function focusEditor(shouldFocus) {
        if (shouldFocus) {
            wv.callFuncNoReply('focus')
        } else {
            wv.callFuncNoReply('blur')
        }
    }

    /**
     * Request the documents contents
     *
     * This is an asynchronous call and the fetched document
     * will be returned via the `documentReady` signal
     */
    function requestDocument() { p.getHTML(); }

    /**
     * Set the document contents
     *
     * @param type:string document contents as a HTML formatted string
     */
    function setDocument(doc) { wv.callFuncNoReply('setHTML', doc); }

    /** Move cursor to start of document */
    function moveCursorToStart() { wv.callFuncNoReply('moveCursorToStart'); }

    /** Move cursor to end of document */
    function moveCursorToEnd() { wv.callFuncNoReply('moveCursorToEnd'); }

    /**
     * Insert image into document
     *
     * Image is inserted at the cursors current location
     *
     * @param type:string Url to image source
     */
    function insertImage(src) {
        // TODO
    }

    /**
     * Insert a link into the document
     *
     * Link is inserted at the cursors curent position
     *
     * @param type:string Link url
     * @param type:object Attributes to apply to the resulting href, e.g {'target': '_blank' }
     */
    function insertLink(url, attrs) {
        wv.callFuncNoReply('makeLink', {
                            url: url,
                            attrs: attrs
                          });
    }

    /** Increase current quote level by 1 */
    function increaseQuoteLevel() { wv.callFuncNoReply('increaseQuoteLevel'); }

    /** Decrease current quote level by 1 */
    function decreaseQuoteLevel() { wv.callFuncNoReply('decreaseQuoteLevel'); }

    /** Create an unordered list */
    function makeUnorderedList() { wv.callFuncNoReply('makeUnorderedList'); }

    /** Create an ordered list */
    function makeOrderedList() { wv.callFuncNoReply('makeOrderedList'); }

    WebView {
        id: wv
        anchors.fill: parent
        url: p.template

        preferences {
            javascriptEnabled: false
            javascriptCanAccessClipboard: false
            allowUniversalAccessFromFileUrls: false
            allowScriptsToCloseWindows: false
            appCacheEnabled: false
            localStorageEnabled: false
            hyperlinkAuditingEnabled: false
        }

        context: WebContext {
            userScripts: [
                Oxide.UserScript {
                    context: 'oxide://squire'
                    emulateGreasemonkey: true
                    url: Qt.resolvedUrl('./js/squire-raw.js')
                }
            ]
        }

        messageHandlers: [
            Oxide.ScriptMessageHandler {
                msgId: 'focus'
                contexts:['oxide://squire']
                callback: function(msg, frame) {
                    p.focused = true
                }
            },
            Oxide.ScriptMessageHandler {
                msgId: 'blur'
                contexts:['oxide://squire']
                callback: function(msg, frame) {
                    p.focused = false
                }
            },
            Oxide.ScriptMessageHandler {
                msgId: 'input'
                contexts:['oxide://squire']
                callback: function(msg, frame) {
                    editor.contentChanged()
                }
            },
            Oxide.ScriptMessageHandler {
                msgId: 'pathChange'
                contexts:['oxide://squire']
                callback: function(msg, frame) {
                    editor.pathChanged(msg.payload.path)
                }
            },
            Oxide.ScriptMessageHandler {
                msgId: 'select'
                contexts:['oxide://squire']
                callback: function(msg, frame) {
                    p.getSelectedText()
                }
            },
            Oxide.ScriptMessageHandler {
                msgId: 'cursor'
                contexts:['oxide://squire']
                callback: function(msg, frame) {
                    p.getCursorPosition()
                }
            },
            Oxide.ScriptMessageHandler {
                msgId: 'undoStateChange'
                contexts:['oxide://squire']
                callback: function(msg, frame) {
                    p.undoState = msg.payload
                }
            }
        ]

        onLoadProgressChanged: {
            if (loadProgress === 100) {
                p.initialize()
            }
        }

        function callFunc(func, data) {
            if (!data) {
                data = {}
            }
            return wv.rootFrame.sendMessage('oxide://squire', func, data)
        }

        function callFuncNoReply(func, data) {
            callFunc(func, data)
        }
    }

    QtObject {
        id: p
        property string template: Qt.resolvedUrl("./templates/editor.html")
        property bool focused: false

        //document control
        property var undoState: null
        property QtObject font: QtObject {
//            property string family: "Ubuntu"
            property bool bold: false
            property bool italic: false
            property bool underline: false
            property int size: 13
            property color textColor: "black"
            property color highlightColor: "white"
            onBoldChanged: {
                bold ? p.addBold() : p.removeBold()
            }
            onItalicChanged: {
                italic ? p.addItalic() : p.removeItalic()
            }
            onUnderlineChanged: {
                underline ? p.addUnderline() : p.removeUnderline()
            }
        }
        property int textAlignment: undefined
        property string selectedText: ""

        onTextAlignmentChanged: {
            var alignment = 'left';
            switch (p.textAlignment) {
            case Text.AlignLeft:
                alignment = 'left' // align-left
                break;
            case Text.AlignHCenter:
                alignment = 'center' // align-center
                break;
            case Text.AlignRight:
                alignment = 'right' // align-right
                break;
            case Text.AlignJustify:
                alignment = 'justify' // align-justify
                break;
            }
            wv.callFuncNoReply('setTextAlignment', alignment)
        }

        function initialize() {
            textAlignment = Text.AlignLeft
        }

        function addBold() {
            wv.callFuncNoReply('bold')
        }

        function removeBold() {
            wv.callFuncNoReply('removeBold')
        }

        function addItalic() {
            wv.callFuncNoReply('italic')
        }
        function removeItalic() {
            wv.callFuncNoReply('removeItalic')
        }
        function addUnderline() {
            wv.callFuncNoReply('underline')
        }
        function removeUnderline() {
            wv.callFuncNoReply('removeUnderline')
        }

        function checkProps() {
            var props = ['B', 'U', 'I'];
            for (var i in props) {
                var result = wv.callFunc('hasFormat', props[i])
                result.onreply = function(response) { updateProp(response.prop, response.value); }
                result.onerror = function (code, response) {
                    console.warn("Failed to get format state: ", code, response)
                }
            }
        }

        function updateProp(prop, value) {
            console.log("Prop: ", prop);
            console.log("Value: ", value);
            switch(prop) {
            case 'B':
                font.bold = value
                break;
            case 'U':
                font.underline = value
                break;
            case 'I':
                font.italic = value
                break;
            }
        }

        function getSelectedText() {
            var result = wv.callFunc('getSelectedText')
            result.onreply = function (response) {
                selectedText = response
                editor.textSelected(selectedText)
            }
        }

        function getHTML() {
            var result = wv.callFunc('getHTML')
            result.onreply = function(response) {
                documentReady(response)
            }
            result.onerror = function(code, response) {
                console.warn("Failed to get document: ", code, response)
            }
        }

        function getCursorPosition() {
            var result = wv.callFunc('getCursorPosition')
            result.onreply = function(response) {
                cursorPositionChanged(response)
            }
            result.onerror = function(code, response) {
                console.warn("Failed to get cursor position", code, response)
            }
        }

    }

//    Timer {
//        repeat: true
//        interval: 5000
//        onTriggered: {
//            if (p.textAlignment === Text.AlignLeft)
//                p.textAlignment = Text.AlignJustify
//            else
//                p.textAlignment = Text.AlignLeft
//        }
//        Component.onCompleted: start()
//    }

}
