import qbs

Project {
    id: quickflux

    name: "QuickFlux Project"

    // e.g qbs profile:<profile> build ... project.staticLib:true
    property bool staticLib: false
    // Install location of dynamic library relative to qbs.installRoot
    property string installDir: "lib/QuickFlux" // i.e qbs.installRoot + "/lib"

    Product {
        name: "QuickFlux"
        targetName: "quickflux"
        type: quickflux.staticLib ? "staticlibrary" : "dynamiclibrary"

        Depends { name: "cpp" }
        Depends { name: "Qt.core" }
        Depends { name: "Qt.quick" }
        Depends { name: "Qt.qml" }

        cpp.optimization: qbs.buildVariant === "debug" ? "none" : "fast"
        cpp.debugInformation: qbs.buildVariant === "debug"
        
        cpp.includePaths: ["./quickflux/src", "./quickflux/priv/src"]
        cpp.cxxLanguageVersion: "c++11";
        cpp.cxxStandardLibrary: "libstdc++";
        cpp.cxxFlags: "-DQUICK_FLUX_DISABLE_AUTO_QML_REGISTER=1";

        // Make it easy to depend on this product
        // consumers will just have to use
        // a Depends { name: "QuickFlux" }
        // and not have to worry about this products
        // depends and includes
        Export {
            Depends { name: "cpp" }
            Depends { name: "Qt.core" }
            Depends { name: "Qt.quick" }
            Depends { name: "Qt.qml" }
            cpp.includePaths: ["./quickflux/src", "./quickflux/priv/src"]
            cpp.cxxLanguageVersion: "c++11";
            cpp.cxxStandardLibrary: "libstdc++";
        }

        Group {
            name: "Public Headers"
            prefix: "quickflux/src/"
            files: [
                "qfactioncreator.h",
                "qfapplistener.h",
                "qfdispatcher.h",
                "qfkeytable.h",
                "qfobject.h",
                "qfappdispatcher.h",
                "qfappscriptgroup.h",
                "qffilter.h",
                "qfmiddleware.h",
                "qfstore.h",
                "qfapplistenergroup.h",
                "qfappscript.h",
                "qfhydrate.h",
                "qfmiddlewarelist.h",
                "QuickFlux"
            ]
        }

        Group {
            name: "Public Sources"
            prefix: "quickflux/src/"
            files: [
                "qfactioncreator.cpp",
                "qfappscriptdispatcherwrapper.cpp",
                "qfhydrate.cpp",
                "qfobject.cpp",
                "qfappdispatcher.cpp",
                "qfappscriptgroup.cpp",
                "qfkeytable.cpp",
                "qfqmltypes.cpp",
                "qfapplistener.cpp",
                "qfappscriptrunnable.cpp",
                "qflistener.cpp",
                "qfstore.cpp",
                "qfapplistenergroup.cpp",
                "qfdispatcher.cpp",
                "qfmiddleware.cpp",
                "qfappscript.cpp",
                "qffilter.cpp",
                "qfmiddlewarelist.cpp"
            ]
        }

        Group {
            name: "Private Headers"
            prefix: "quickflux/src/priv/"
            files: [
                "qfappscriptdispatcherwrapper.h",
                "qfhook.h",
                "qfmiddlewareshook.h",
                "quickfluxfunctions.h",
                "qfappscriptrunnable.h",
                "qflistener.h",
                "qfsignalproxy.h"
            ]
        }

        Group {
            name: "Private Sources"
            prefix: "quickflux/src/priv/"
            files: [
                "qfhook.cpp",
                "qfmiddlewareshook.cpp",
                "qfsignalproxy.cpp",
                "quickfluxfunctions.cpp"
            ]
        }

        // For the dynamic library. Apps can pick up
        // the plugin on the QML2_IMPORT_PATH
        Group {
            name: "QuickFlux Plugin"
            condition: !quickflux.staticLib
            files: [
                "quickflux_plugin.cpp",
                "quickflux_plugin.h"
            ]
        }

        Group {
            condition: !quickflux.staticLib
            name: "Other Files"
            files: [
                "qmldir"
            ]
            fileTags: ["quickflux-resources"]
            qbs.install: true
            qbs.installDir: quickflux.installDir
        }

        Group {
            condition: !quickflux.staticLib
            qbs.install: true
            qbs.installDir: quickflux.installDir
            fileTagsFilter: product.type
        }
    }
}
