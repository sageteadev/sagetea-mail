QBS_BIN=qbs
DIR_PREFIX=/lib/arm-linux-gnueabihf
BIN_DIR=$DIR_PREFIX/bin
LIB_DIR=$DIR_PREFIX
DATA_DIR=/usr/share/dekko
QML_DIR=$LIB_DIR
PROJECT=/home/ubuntu/Projects/dekko
BUILD_DIR=$PROJECT/.build-armhf
PY_LIBS=$PROJECT/pylibs

apt install qbs qtpim5-dev:armhf qttools5-dev-tools libconnectivity-qt1-dev:armhf libaccounts-qt5-dev:armhf qtdeclarative5-private-dev:armhf qtscript5-private-dev:armhf qml-module-qtquick-privatewidgets:armhf qtbase5-private-dev:armhf qtbase5-dev:armhf libqt5svg5-dev:armhf libsignon-qt5-dev:armhf libsasl2-dev:armhf signon-plugin-sasl-dev:armhf signon-plugin-oauth2-dev:armhf libsnappy-dev:armhf qemu-user-static python3-dev python3-pip git zlib1g-dev -y

export QT_SELECT=qt5

qbs ssetup-toolchains /usr/bin/arm-linux-gnueabihf-gcc gcc-armhf
qbs setup-qt /usr/lib/arm-linux-gnueabihf/qt5/bin/qmake dekkoqt5-armhf
qbs config profiles.dekkoqt5-armhf.baseProfile gcc-armhf
qbs config profiles.dekkoqt5-armhf.Qt.core.binPath /usr/lib/x86_64-linux-gnu/qt5/bin

qbs build -d ${PWD}/.build \
    -f . \
    --clean-install-root \
    project.click:true \
    project.pyotherside:true \
    project.binDir:$BIN_DIR \
    project.libDir:$LIB_DIR \
    project.qmlDir:$QML_DIR \
    project.dataDir:$DATA_DIR \
    profile:dekkoqt5-armhf