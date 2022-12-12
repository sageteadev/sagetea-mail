import qbs

Project {
    name: "Rich Text Editor"

    DynamicLibrary {
        name: "Editor"

        files: [
            "*.js",
            "*.qml"
        ]
        Group {
            name: "Examples"
            files: [
                "example/*.qml"
            ]
        }

        Group {
            name: "QML Sources"
            files: [
                "src/*.qml",
                "src/qmldir"
            ]
            fileTags: ["editor"]
        }
        Group {
            name: "JS Sources"
            files: [
                "src/js/*.js"
            ]
            fileTags: ["editor"]
        }
        Group {
            name: "Templates"
            files: [
                "src/templates/*.html"
            ]
            fileTags: ["editor"]
        }

        Group {
            fileTagsFilter: "editor"
            qbs.install: true
            qbs.installDir: project.qmlDir + "/SageteaMail/Editor"
            qbs.installSourceBase: path + "/src"
        }
    }
}
