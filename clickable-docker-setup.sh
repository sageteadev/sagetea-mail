#!/bin/bash

# path after -v has to be the dir where dekko sources are
# run the adapted docker command and inside docker execute this script
#docker run -v ~/swdevel/git/dekko:/root/dekko -it clickable/ubuntu-sdk:16.04-armhf bash

apt update
apt install qtpim5-dev:armhf qttools5-dev-tools libconnectivity-qt1-dev:armhf libaccounts-qt5-dev:armhf qtdeclarative5-private-dev:armhf qml-module-qtquick-privatewidgets:armhf qtbase5-private-dev:armhf qtbase5-dev:armhf libqt5svg5-dev:armhf libsignon-qt5-dev:armhf libsasl2-dev:armhf signon-plugin-sasl-dev:armhf signon-plugin-oauth2-dev:armhf libsnappy-dev:armhf python3-dev python3-pip git zlib1g-dev qbs qt5-qmake-bin:armhf qemu-user-static

cd /root/dekko

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

click build $BUILD_DIR/**/install-root
