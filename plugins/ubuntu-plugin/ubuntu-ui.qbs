import qbs

Project {
    name: "Ubuntu UI"
    property bool enabled: false

    references: [
        "plugins/default-plugins.qbs",
        "imports/stages/stages.qbs",
        "imports/constants/constants.qbs",
        "imports/components/components.qbs",
        "imports/utils/helpers.qbs",
        "imports/dialogs/dialogs.qbs"
    ]

    DynamicLibrary {
        name: "i18n"
        type: "dynamiclibrary"

        Depends { name: "cpp" }
        Depends { name: "Qt.core" }

        Group {
            name: "ts files"
            prefix: "i18n/"
            files: [
                "*.ts"
            ]
        }

        Group {
            qbs.install: true
            qbs.installDir: project.binDir + "/plugins/ui/i18n"
            fileTagsFilter: ["qm"]
        }
    }

    Product {
        name: "QML UI"
        condition: project.enabled

        Depends { name: "cpp" }
        Depends { name: "Qt.core" }

        Group {
            name: "QML components"
            files: [
                "qml/**/*.qml"
            ]
            fileTags: ["ui-plugin"]
        }

        Group {
            name: "JavaScript modules"
            files: [
                "qml/**/*.js"
            ]
            fileTags: ["ui-plugin"]
        }

        Group {
            name: "Plugin specs"
            files: [
                "qml/**/*.dekko-plugin"
            ]
            fileTags: ["ui-plugin"]
        }

        Group {
            condition: project.ui === "ubuntu"
            fileTagsFilter: "ui-plugin"
            qbs.install: project.ui === "ubuntu"
            qbs.installDir: project.binDir + "/plugins/ui/"
            qbs.installSourceBase: "qml"
        }
    }
}
