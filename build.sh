#!/bin/bash

set -e

if [ "$ARCH_TRIPLET" == "arm-linux-gnueabihf" ]; then
    ARCH=armhf
elif [ "$ARCH_TRIPLET" == "x86_64-linux-gnu" ]; then
    ARCH=amd64
else
    echo "unsupported target architecture $ARCH_TRIPLET"
    exit 1
fi

function install_python_deps
{
    PYTHON_DEPS="bs4 cssutils encutils html2text jinja2 markdown markupsafe pygments pynliner"
    PYTHON_DEPS_DIR=pylibs/lib/python3.5/site-packages/
    DEKKO_PYTHON_DIR=$CLICK_LD_LIBRARY_PATH/Dekko/Python/

    mkdir -p $DEKKO_PYTHON_DIR
    for dep in $PYTHON_DEPS; do
        cp -r $PYTHON_DEPS_DIR/$dep $DEKKO_PYTHON_DIR
    done
}

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $ROOT

if [ "$ARCH" == "amd64" ]; then
    qbs setup-toolchains /usr/bin/gcc gcc-$ARCH
else
    qbs setup-toolchains /usr/bin/${ARCH_TRIPLET}-gcc gcc-$ARCH
fi

qbs setup-qt /usr/lib/$ARCH_TRIPLET/qt5/bin/qmake dekkoqt5-$ARCH
qbs config profiles.dekkoqt5-$ARCH.baseProfile gcc-$ARCH
qbs config profiles.dekkoqt5-$ARCH.Qt.core.binPath /usr/lib/x86_64-linux-gnu/qt5/bin

export DIR_PREFIX=/lib/$ARCH_TRIPLET
export BIN_DIR=$DIR_PREFIX/bin
export LIB_DIR=$DIR_PREFIX
export DATA_DIR=/usr/share/dekko
export QML_DIR=$LIB_DIR

qbs build -d $BUILD_DIR -f . --clean-install-root --show-progress release project.click:true project.pyotherside:false project.binDir:$BIN_DIR project.libDir:$LIB_DIR project.qmlDir:$QML_DIR project.dataDir:$DATA_DIR profile:dekkoqt5-$ARCH

install_python_deps
