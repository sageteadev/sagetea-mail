# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/ruben/SageTea/sagetea-mail/upstream/qmf/src/plugins/messageservices/pop/popsettings.ui'
#
# Created by: PyQt5 UI code generator 5.14.1
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_PopSettings(object):
    def setupUi(self, PopSettings):
        PopSettings.setObjectName("PopSettings")
        PopSettings.resize(365, 256)
        self.verticalLayout = QtWidgets.QVBoxLayout(PopSettings)
        self.verticalLayout.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout.setObjectName("verticalLayout")
        self.scrollArea_2 = QtWidgets.QScrollArea(PopSettings)
        self.scrollArea_2.setFocusPolicy(QtCore.Qt.NoFocus)
        self.scrollArea_2.setFrameShape(QtWidgets.QFrame.NoFrame)
        self.scrollArea_2.setLineWidth(0)
        self.scrollArea_2.setHorizontalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.scrollArea_2.setWidgetResizable(True)
        self.scrollArea_2.setObjectName("scrollArea_2")
        self.scrollAreaWidgetContents_2 = QtWidgets.QWidget()
        self.scrollAreaWidgetContents_2.setGeometry(QtCore.QRect(0, -25, 348, 281))
        self.scrollAreaWidgetContents_2.setObjectName("scrollAreaWidgetContents_2")
        self.gridlayout = QtWidgets.QGridLayout(self.scrollAreaWidgetContents_2)
        self.gridlayout.setObjectName("gridlayout")
        self.usernameLabel = QtWidgets.QLabel(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.usernameLabel.sizePolicy().hasHeightForWidth())
        self.usernameLabel.setSizePolicy(sizePolicy)
        self.usernameLabel.setObjectName("usernameLabel")
        self.gridlayout.addWidget(self.usernameLabel, 0, 0, 1, 1)
        self.mailUserInput = QtWidgets.QLineEdit(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.mailUserInput.sizePolicy().hasHeightForWidth())
        self.mailUserInput.setSizePolicy(sizePolicy)
        self.mailUserInput.setObjectName("mailUserInput")
        self.gridlayout.addWidget(self.mailUserInput, 0, 1, 1, 1)
        self.passwordLabel = QtWidgets.QLabel(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.passwordLabel.sizePolicy().hasHeightForWidth())
        self.passwordLabel.setSizePolicy(sizePolicy)
        self.passwordLabel.setObjectName("passwordLabel")
        self.gridlayout.addWidget(self.passwordLabel, 1, 0, 1, 1)
        self.mailPasswInput = QtWidgets.QLineEdit(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.mailPasswInput.sizePolicy().hasHeightForWidth())
        self.mailPasswInput.setSizePolicy(sizePolicy)
        self.mailPasswInput.setEchoMode(QtWidgets.QLineEdit.Password)
        self.mailPasswInput.setObjectName("mailPasswInput")
        self.gridlayout.addWidget(self.mailPasswInput, 1, 1, 1, 1)
        self.serverLabel = QtWidgets.QLabel(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.serverLabel.sizePolicy().hasHeightForWidth())
        self.serverLabel.setSizePolicy(sizePolicy)
        self.serverLabel.setObjectName("serverLabel")
        self.gridlayout.addWidget(self.serverLabel, 2, 0, 1, 1)
        self.mailServerInput = QtWidgets.QLineEdit(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.mailServerInput.sizePolicy().hasHeightForWidth())
        self.mailServerInput.setSizePolicy(sizePolicy)
        self.mailServerInput.setObjectName("mailServerInput")
        self.gridlayout.addWidget(self.mailServerInput, 2, 1, 1, 1)
        self.portLabel = QtWidgets.QLabel(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.portLabel.sizePolicy().hasHeightForWidth())
        self.portLabel.setSizePolicy(sizePolicy)
        self.portLabel.setObjectName("portLabel")
        self.gridlayout.addWidget(self.portLabel, 3, 0, 1, 1)
        self.mailPortInput = QtWidgets.QLineEdit(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.mailPortInput.sizePolicy().hasHeightForWidth())
        self.mailPortInput.setSizePolicy(sizePolicy)
        self.mailPortInput.setObjectName("mailPortInput")
        self.gridlayout.addWidget(self.mailPortInput, 3, 1, 1, 1)
        self.lblEncryptionIncoming = QtWidgets.QLabel(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.lblEncryptionIncoming.sizePolicy().hasHeightForWidth())
        self.lblEncryptionIncoming.setSizePolicy(sizePolicy)
        self.lblEncryptionIncoming.setObjectName("lblEncryptionIncoming")
        self.gridlayout.addWidget(self.lblEncryptionIncoming, 4, 0, 1, 1)
        self.encryptionIncoming = QtWidgets.QComboBox(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.encryptionIncoming.sizePolicy().hasHeightForWidth())
        self.encryptionIncoming.setSizePolicy(sizePolicy)
        self.encryptionIncoming.setObjectName("encryptionIncoming")
        self.encryptionIncoming.addItem("")
        self.encryptionIncoming.addItem("")
        self.encryptionIncoming.addItem("")
        self.gridlayout.addWidget(self.encryptionIncoming, 4, 1, 1, 1)
        self.deleteCheckBox = QtWidgets.QCheckBox(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.deleteCheckBox.sizePolicy().hasHeightForWidth())
        self.deleteCheckBox.setSizePolicy(sizePolicy)
        self.deleteCheckBox.setChecked(True)
        self.deleteCheckBox.setObjectName("deleteCheckBox")
        self.gridlayout.addWidget(self.deleteCheckBox, 5, 0, 1, 2)
        self.thresholdCheckBox = QtWidgets.QCheckBox(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.thresholdCheckBox.sizePolicy().hasHeightForWidth())
        self.thresholdCheckBox.setSizePolicy(sizePolicy)
        self.thresholdCheckBox.setMinimumSize(QtCore.QSize(0, 0))
        self.thresholdCheckBox.setChecked(True)
        self.thresholdCheckBox.setObjectName("thresholdCheckBox")
        self.gridlayout.addWidget(self.thresholdCheckBox, 6, 0, 1, 1)
        self.intervalCheckBox = QtWidgets.QCheckBox(self.scrollAreaWidgetContents_2)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.intervalCheckBox.sizePolicy().hasHeightForWidth())
        self.intervalCheckBox.setSizePolicy(sizePolicy)
        self.intervalCheckBox.setMinimumSize(QtCore.QSize(0, 0))
        self.intervalCheckBox.setObjectName("intervalCheckBox")
        self.gridlayout.addWidget(self.intervalCheckBox, 7, 0, 1, 1)
        self.roamingCheckBox = QtWidgets.QCheckBox(self.scrollAreaWidgetContents_2)
        self.roamingCheckBox.setEnabled(False)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.roamingCheckBox.sizePolicy().hasHeightForWidth())
        self.roamingCheckBox.setSizePolicy(sizePolicy)
        self.roamingCheckBox.setMinimumSize(QtCore.QSize(0, 0))
        self.roamingCheckBox.setObjectName("roamingCheckBox")
        self.gridlayout.addWidget(self.roamingCheckBox, 8, 1, 1, 1)
        self.intervalPeriod = QtWidgets.QSpinBox(self.scrollAreaWidgetContents_2)
        self.intervalPeriod.setEnabled(False)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.intervalPeriod.sizePolicy().hasHeightForWidth())
        self.intervalPeriod.setSizePolicy(sizePolicy)
        self.intervalPeriod.setMinimum(10)
        self.intervalPeriod.setMaximum(1440)
        self.intervalPeriod.setSingleStep(10)
        self.intervalPeriod.setProperty("value", 60)
        self.intervalPeriod.setObjectName("intervalPeriod")
        self.gridlayout.addWidget(self.intervalPeriod, 7, 1, 1, 1)
        self.maxSize = QtWidgets.QSpinBox(self.scrollAreaWidgetContents_2)
        self.maxSize.setEnabled(True)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.maxSize.sizePolicy().hasHeightForWidth())
        self.maxSize.setSizePolicy(sizePolicy)
        self.maxSize.setMinimum(0)
        self.maxSize.setMaximum(5000)
        self.maxSize.setSingleStep(5)
        self.maxSize.setProperty("value", 100)
        self.maxSize.setObjectName("maxSize")
        self.gridlayout.addWidget(self.maxSize, 6, 1, 1, 1)
        self.scrollArea_2.setWidget(self.scrollAreaWidgetContents_2)
        self.verticalLayout.addWidget(self.scrollArea_2)
        self.usernameLabel.setBuddy(self.mailUserInput)
        self.passwordLabel.setBuddy(self.mailPasswInput)
        self.serverLabel.setBuddy(self.mailServerInput)
        self.portLabel.setBuddy(self.mailPortInput)
        self.lblEncryptionIncoming.setBuddy(self.encryptionIncoming)

        self.retranslateUi(PopSettings)
        QtCore.QMetaObject.connectSlotsByName(PopSettings)
        PopSettings.setTabOrder(self.mailUserInput, self.mailPasswInput)
        PopSettings.setTabOrder(self.mailPasswInput, self.mailServerInput)
        PopSettings.setTabOrder(self.mailServerInput, self.mailPortInput)
        PopSettings.setTabOrder(self.mailPortInput, self.encryptionIncoming)
        PopSettings.setTabOrder(self.encryptionIncoming, self.deleteCheckBox)
        PopSettings.setTabOrder(self.deleteCheckBox, self.thresholdCheckBox)
        PopSettings.setTabOrder(self.thresholdCheckBox, self.maxSize)
        PopSettings.setTabOrder(self.maxSize, self.intervalCheckBox)
        PopSettings.setTabOrder(self.intervalCheckBox, self.intervalPeriod)
        PopSettings.setTabOrder(self.intervalPeriod, self.roamingCheckBox)

    def retranslateUi(self, PopSettings):
        _translate = QtCore.QCoreApplication.translate
        PopSettings.setWindowTitle(_translate("PopSettings", "Form"))
        self.usernameLabel.setText(_translate("PopSettings", "Username"))
        self.passwordLabel.setText(_translate("PopSettings", "Password"))
        self.serverLabel.setText(_translate("PopSettings", "Server"))
        self.portLabel.setText(_translate("PopSettings", "Port"))
        self.lblEncryptionIncoming.setText(_translate("PopSettings", "Encryption"))
        self.encryptionIncoming.setItemText(0, _translate("PopSettings", "None"))
        self.encryptionIncoming.setItemText(1, _translate("PopSettings", "SSL"))
        self.encryptionIncoming.setItemText(2, _translate("PopSettings", "TLS"))
        self.deleteCheckBox.setText(_translate("PopSettings", "Remove deleted mail from server"))
        self.thresholdCheckBox.setText(_translate("PopSettings", "Skip larger"))
        self.intervalCheckBox.setText(_translate("PopSettings", "Interval"))
        self.roamingCheckBox.setText(_translate("PopSettings", "Disable when Roaming"))
        self.intervalPeriod.setSuffix(_translate("PopSettings", "min", "short for minutes"))
        self.maxSize.setSuffix(_translate("PopSettings", "K"))
