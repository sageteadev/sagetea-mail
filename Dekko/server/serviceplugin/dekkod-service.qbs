import qbs

DynamicLibrary {
    name: "Dekkod Service Plugin"
    targetName: "dekkod-service"
    builtByDefault: project.click
    Depends { name: "cpp" }
    Depends { name: "Qt.core" }
    Depends { name: "PlugMan" }
    Depends { name: "SnapStandardPaths" }
    cpp.cxxLanguageVersion: "c++11";
    cpp.cxxStandardLibrary: "libstdc++";
    cpp.defines: [
        "DEKKO_VERSION=\"" + project.version +"\""
    ]

    Group {
        name: "plugin"
        files: [
            "dekkodserviceplugin.cpp",
            "dekkodserviceplugin.h",
        ]
    }

    Group {
        qbs.install: project.click
        qbs.installDir: project.pluginDir
        fileTagsFilter: product.type
    }
}

