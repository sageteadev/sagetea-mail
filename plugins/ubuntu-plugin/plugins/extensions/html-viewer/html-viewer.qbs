import qbs

Project {
    name: "HTML Viewer"

    Product {
        name: "Viewer Plugin"
        type: "sageteamail-plugin"

        Group {
            name: "Plugin Files"
            prefix: path + "/"
            files: [
                "*.dekko-plugin",
                "*.qml"
            ]
            qbs.install: true
            qbs.installDir: project.pluginDir + "/html-viewer"
        }
    }
}
