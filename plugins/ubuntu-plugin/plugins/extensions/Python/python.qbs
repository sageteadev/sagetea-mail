import qbs
import qbs.Process

Project {
    name: "Python"

        Group {
            files: [
                "DekkoPython.qml",
            ]
            name: "QML components"
            fileTags: ["py-comps"]
        }

        Group {
            files: [
                "qmldir",
            ]
            name: "QML directory"
            fileTags: ["py-comps"]
        }

        Group {
            fileTagsFilter: "py-comps"
            qbs.install: true
            qbs.installDir: project.qmlDir + "/SageteaMail/" + project.name
            qbs.installSourceBase: path
    }
}
