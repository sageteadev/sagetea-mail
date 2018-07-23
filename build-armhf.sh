#!/bin/bash

# to be executed from .build-armhf/release/install-root/
cd ../../..

qbs setup-toolchains /usr/bin/arm-linux-gnueabihf-gcc gcc-armhf
qbs setup-qt /usr/lib/arm-linux-gnueabihf/qt5/bin/qmake dekkoqt5-armhf
qbs config profiles.dekkoqt5-armhf.baseProfile gcc-armhf
qbs config profiles.dekkoqt5-armhf.Qt.core.binPath /usr/lib/x86_64-linux-gnu/qt5/bin

export DIR_PREFIX=/lib/arm-linux-gnueabihf
export BIN_DIR=$DIR_PREFIX/bin
export LIB_DIR=$DIR_PREFIX
export DATA_DIR=/usr/share/dekko
export QML_DIR=$LIB_DIR
export BUILD_DIR=$(pwd)/.build-armhf

qbs build -d $BUILD_DIR -f . --clean-install-root --show-progress release project.click:true project.pyotherside:false project.binDir:$BIN_DIR project.libDir:$LIB_DIR project.qmlDir:$QML_DIR project.dataDir:$DATA_DIR profile:dekkoqt5-armhf

