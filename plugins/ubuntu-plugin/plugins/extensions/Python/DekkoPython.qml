import QtQuick 2.4
import io.thp.pyotherside 1.5

Python {
    id: python

    signal ready()

    property var importPaths: []

    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl("."))
        importModule('metadata')
        importModule('markdown')
        importModule('zipp')
        ready()
    }
}
