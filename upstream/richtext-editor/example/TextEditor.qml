import QtQuick 2.4
import Ubuntu.Components 1.3
import "../src"

MainView {
    width: 500
    height: 500

    Page {
        title: "Text editor"

        Row {
            id: btnRow
            spacing: units.gu(0.5)
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: units.gu(4)

            EditorButton {
                height: parent.height
                active: editor.font.bold
                text: "B"
//                color: editor.font.bold ? UbuntuColors.blue : UbuntuColors.coolGrey
                font.weight: Font.DemiBold
                onClicked: editor.font.bold = !editor.font.bold
            }

            EditorButton {
                height: parent.height
                active: editor.font.italic
                text: "I"
                font.italic: true
                onClicked: editor.font.italic = !editor.font.italic
            }

            EditorButton {
                height: parent.height
                active: editor.font.underline
                text: "U"
                font.underline: true
                onClicked: editor.font.underline = !editor.font.underline
            }

            EditorButton {
                height: parent.height
                enabled: editor.canUndo
                iconName: "undo"
                onClicked: editor.undo()
            }

            EditorButton {
                height: parent.height
                enabled: editor.canRedo
                iconName: "redo"
                onClicked: editor.redo()
            }
        }

        Rectangle {
            color: UbuntuColors.silk
            anchors {
                left: parent.left
                right: parent.right
                bottom: btnRow.bottom
            }
            height: units.dp(1)
        }

        RichTextEditor {
            id: editor
            anchors {
                left: parent.left
                right: parent.right
                top: btnRow.bottom
                bottom: parent.bottom
            }
        }
    }
}
