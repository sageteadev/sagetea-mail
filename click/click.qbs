import qbs

Product {
    name: "Click"
    type: "clickpackage"
    builtByDefault: project.click

    Group {
        name: "AppArmor"
        files: [
            "openstore/dekko2.apparmor",
            "openstore/dekkod.apparmor"
        ]
        fileTags: ["clickroot"]
    }

    Group {
        name: "Click Manifests"
        files: [
            "dekko2-content.json",
            "dekko2.url-dispatcher",
            "manifest.json",
        ]
        fileTags: ["clickroot"]
    }

    Group {
        name: "Launcher"
        files: [
            "dekkod-launch"
        ]
        fileTags: ["clickbin"]
    }

    Group {
        name: "Desktop Files"
        files: [
            "dekko2.desktop",
            "dekkod.desktop",
        ]
        fileTags: ["clickroot"]
    }

    Group {
        name: "Push Helper"
        files: [
            "dekkohelper-aa.json",
            "dekko-helper.json",
            "dekko-helper"
        ]
        fileTags: ["clickroot"]
    }

    Group {
        condition: project.click
        fileTagsFilter: "clickroot"
        qbs.install: product.type
        qbs.installDir: "/"
    }

    Group {
        condition: project.click
        fileTagsFilter: "clickbin"
        qbs.install: product.type
        qbs.installDir: project.binDir
    }
}
