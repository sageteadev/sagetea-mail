# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/ruben/SageTea/sagetea-mail/upstream/qmf/src/plugins/messageservices/qmfsettings/settings.ui'
#
# Created by: PyQt5 UI code generator 5.14.1
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_QtopiamailfileSettings(object):
    def setupUi(self, QtopiamailfileSettings):
        QtopiamailfileSettings.setObjectName("QtopiamailfileSettings")
        QtopiamailfileSettings.resize(135, 39)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Maximum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(QtopiamailfileSettings.sizePolicy().hasHeightForWidth())
        QtopiamailfileSettings.setSizePolicy(sizePolicy)
        self.formLayout = QtWidgets.QFormLayout(QtopiamailfileSettings)
        self.formLayout.setObjectName("formLayout")
        self.label = QtWidgets.QLabel(QtopiamailfileSettings)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.label.sizePolicy().hasHeightForWidth())
        self.label.setSizePolicy(sizePolicy)
        self.label.setObjectName("label")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.LabelRole, self.label)
        self.locationSelector = QtWidgets.QComboBox(QtopiamailfileSettings)
        self.locationSelector.setObjectName("locationSelector")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.FieldRole, self.locationSelector)

        self.retranslateUi(QtopiamailfileSettings)
        QtCore.QMetaObject.connectSlotsByName(QtopiamailfileSettings)

    def retranslateUi(self, QtopiamailfileSettings):
        _translate = QtCore.QCoreApplication.translate
        QtopiamailfileSettings.setWindowTitle(_translate("QtopiamailfileSettings", "Form"))
        self.label.setText(_translate("QtopiamailfileSettings", "Location"))
