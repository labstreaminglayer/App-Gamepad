/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Gamepad module
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtGamepad 1.12
import Qt.labs.settings 1.1

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 800
    height: 740
    title: qsTr("GamepadLSL")
    color: "#363330"

    Settings {
        id: appSettings
        category: "ApplicationWindow"
        fileName: applicationWindow1.title + ".cfg"
        property alias x: applicationWindow1.x
        property alias y: applicationWindow1.y
        property alias width: applicationWindow1.width
        property alias height: applicationWindow1.height
    }
    Settings {
        category: "SampledStream"
        fileName: applicationWindow1.title + ".cfg"
        property alias name: textedit_streamname_sampled.text
        property alias type: textedit_streamtype_sampled.text
        property alias stream_id: textedit_streamid_sampled.text
        property alias rate_x100: spinBox_rate_x100.value
    }
    Settings {
        category: "EventStream"
        fileName: applicationWindow1.title + ".cfg"
        property alias name: textedit_streamname_event.text
        property alias type: textedit_streamtype_event.text
        property alias stream_id: textedit_streamid_event.text
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8

        RowLayout {
            id: formRow
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

        ColumnLayout {
            id: sampledStreamCol
            spacing: 20
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.margins: 20
            Label {
                color: "#ffffff"
                text: qsTr("Continuous Stream")
                font.pointSize: 12
            }

            Row {
                id: row3
                Layout.fillWidth: true
                Label {
                    width: 50
                    color: "#ffffff"
                    text: qsTr("Name:")
                    rightPadding: 5
                    horizontalAlignment: Text.AlignRight
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 12
                }
                TextEdit {
                    id: textedit_streamname_sampled
                    color: "#ffffff"
                    text: qsTr("Gamepad")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14
                }
            }

            Row {
                id: row
                Layout.fillWidth: true
                Label {
                    width: 50
                    color: "#ffffff"
                    text: qsTr("Type:")
                    rightPadding: 5
                    horizontalAlignment: Text.AlignRight
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 12
                }
                TextEdit {
                    id: textedit_streamtype_sampled
                    color: "#ffffff"
                    text: qsTr("HID")
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                }
            }

            Row {
                id: row1
                Layout.fillWidth: true
                Label {
                    width: 50
                    text: qsTr("Id:")
                    rightPadding: 5
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#ffffff"
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignRight
                }

                TextEdit {
                    id: textedit_streamid_sampled
                    text: qsTr("gamepad_cont_0")
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#ffffff"
                    font.pixelSize: 14
                }
            }

            Row {
                Layout.fillWidth: true
                Label {
                    width: 50
                    color: "#ffffff"
                    text: qsTr("Rate:")
                    rightPadding: 5
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 12
                }
                SpinBox {
                    id: spinBox_rate_x100
                    editable: true
                    to: 1000 * 100
                    from: 1 * 100
                    value: 60 * 100
                    property int decimals: 2
                    property real realValue: value / 100
                    stepSize: 100

                    validator: DoubleValidator {
                        bottom: Math.min(spinBox_rate_x100.from, spinBox_rate_x100.to)
                        top:  Math.max(spinBox_rate_x100.from, spinBox_rate_x100.to)
                    }

                    textFromValue: function(value, locale) {
                        return Number(value / 100).toLocaleString(locale, 'f', spinBox_rate_x100.decimals)
                    }

                    valueFromText: function(text, locale) {
                        return Number.fromLocaleString(locale, text) * 100
                    }
                }
            }
        }

        ColumnLayout {
            id: eventStreamCol
            spacing: 20
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.margins: 20
            Label {
                color: "#ffffff"
                text: qsTr("Event Stream")
                font.pointSize: 12
            }
            Row {
                id: row4
                Layout.fillWidth: true
                Label {
                    width: 50
                    color: "#ffffff"
                    text: qsTr("Name:")
                    rightPadding: 5
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 12
                }
                TextEdit {
                    id: textedit_streamname_event
                    color: "#ffffff"
                    text: qsTr("Gamepad Events")
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.fillWidth: true
                    font.pixelSize: 14
                }
            }

            Row {
                id: row5
                Layout.fillWidth: true
                Label {
                    width: 50
                    color: "#ffffff"
                    text: qsTr("Type:")
                    rightPadding: 5
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 12
                }
                TextEdit {
                    id: textedit_streamtype_event
                    color: "#ffffff"
                    text: qsTr("Markers")
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.fillHeight: false
                    Layout.fillWidth: true
                    font.pixelSize: 14
                }
            }

            Row {
                id: row2
                Layout.fillWidth: true
                Label {
                    width: 50
                    text: qsTr("Id:")
                    rightPadding: 5
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#ffffff"
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignRight
                }
                TextEdit {
                    id: textedit_streamid_event
                    text: qsTr("gamepad_evt_0")
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#ffffff"
                    font.pixelSize: 14
                }
            }
        }

        ColumnLayout {
            id: deviceLinkCol
            spacing: 20
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
            Layout.margins: 20

            Label {
                color: "#ffffff"
                text: qsTr("Select Device:")
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
            }

            ComboBox {
                id: combobox_gamepads
                Layout.fillWidth: true
                model: gamepadModel
                displayText: "Id: " + currentText
                textRole: "id"
                delegate: ItemDelegate {
                    width: combobox_gamepads.width
                    contentItem: Text {text: 'Id:' + id + ' Name:' + name}
                }
                onCurrentIndexChanged: {
                    gamepad.setDeviceId(gamepadModel.get(combobox_gamepads.currentIndex).id)
                }
            }

            Button {
                id: linkbutton
                text: qsTr("Link")
                Layout.fillWidth: true
                onClicked: lsl_manager.linkStream(gamepad,
                                                  textedit_streamname_sampled.text, textedit_streamtype_sampled.text, textedit_streamid_sampled.text, spinBox_rate_x100.value / 100,
                                                  textedit_streamname_event.text, textedit_streamtype_event.text, textedit_streamid_event.text)
                function onStreamStatusChanged(is_linked) {
                    linkbutton.text = is_linked ? "Unlink" : "Link"
                    textedit_streamname_sampled.enabled = !is_linked
                    textedit_streamtype_sampled.enabled = !is_linked
                    textedit_streamid_sampled.enabled = !is_linked
                    textedit_streamname_event.enabled = !is_linked
                    textedit_streamtype_event.enabled = !is_linked
                    textedit_streamid_event.enabled = !is_linked
                    spinBox_rate_x100.enabled = !is_linked
                    combobox_gamepads.enabled = !is_linked
                }
                Component.onCompleted: {
                    lsl_manager.streamStatusChange.connect(onStreamStatusChanged)
                }
            }

        }
        }

        RowLayout {
            id: topRow
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                id: buttonL2Item
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.minimumHeight: 170
                Layout.fillWidth: true
                ButtonImage {
                    id: leftTrigger
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    source: "xboxControllerLeftTrigger.png"
                    active: gamepad.buttonL2 != 0
                }
                ProgressBar {
                    id: buttonL2Value
                    width: leftTrigger.width
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    value: gamepad.buttonL2
                }
            }

            Item {
                id: centerButtons
                height: guideButton.height
                width: guideButton.width + 16 + backButton.width + startButton.width
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                ButtonImage {
                    id: backButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: guideButton.left
                    anchors.rightMargin: 8
                    source: "xboxControllerBack.png"
                    active: gamepad.buttonSelect
                }
                ButtonImage {
                    id: guideButton
                    anchors.centerIn: parent
                    source: "xboxControllerButtonGuide.png"
                    active: gamepad.buttonGuide
                }
                ButtonImage {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: guideButton.right
                    anchors.leftMargin: 8
                    id: startButton
                    source: "xboxControllerStart.png"
                    active: gamepad.buttonStart
                }
            }

            ColumnLayout {
                id: buttonR2Item
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                Layout.minimumHeight: 170
                Layout.fillWidth: true
                ButtonImage {
                    id: rightTrigger
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    source: "xboxControllerRightTrigger.png"
                    active: gamepad.buttonR2 != 0
                }

                ProgressBar {
                    id: buttonR2Value
                    width: rightTrigger.width
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    value: gamepad.buttonR2
                }
            }
        }

        RowLayout {
            id: middleRow
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: 90
            Layout.fillHeight: true
            Layout.fillWidth: true
            ButtonImage {
                id: buttonL1
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                source: "xboxControllerLeftShoulder.png"
                active: gamepad.buttonL1
            }
            Item {
                id: spacer1
                Layout.fillWidth: true
            }

            ButtonImage {
                id: buttonR1
                source: "xboxControllerRightShoulder.png"
                active: gamepad.buttonR1
            }
        }

        RowLayout {
            id: bottomRow
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            DPad {
                id: dPad
                Layout.minimumHeight: 186
                Layout.minimumWidth: 186
                Layout.alignment: Qt.AlignLeft
                gamepad: gamepad
            }

            LeftThumbstick {
                id: leftThumbstick
                gamepad: gamepad
            }

            Item {
                id: spacer2
                Layout.fillWidth: true
            }

            RightThumbstick {
                id: rightThumbstick
                gamepad: gamepad
            }

            Item {
                width: 200
                height: 200
                Layout.minimumHeight: 200
                Layout.minimumWidth: 200
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.fillHeight: false
                Layout.fillWidth: false
                ButtonImage {
                    id: buttonA
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "xboxControllerButtonA.png";
                    active: gamepad.buttonA
                }
                ButtonImage {
                    id: buttonB
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: "xboxControllerButtonB.png";
                    active: gamepad.buttonB
                }
                ButtonImage {
                    id: buttonX
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: "xboxControllerButtonX.png";
                    active: gamepad.buttonX
                }
                ButtonImage {
                    id: buttonY
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "xboxControllerButtonY.png";
                    active: gamepad.buttonY
                }
            }
        }

    }

    Connections {
        target: GamepadManager
        function onGamepadConnected(newId) {
            // Convoluted attempt to get the name associated with the device. Still always blank for me :/
            var oldId = gamepad.deviceId
            gamepad.setDeviceId(newId)
            var newName = gamepad.name
            if (newName === "") {newName = "Unknown Name"}
            gamepad.setDeviceId(oldId)
            gamepadModel.append({"id": newId, "name": newName});
            if (gamepadModel.count === 1) {combobox_gamepads.currentIndex = 0}
        }
    }

    Gamepad {
        id: gamepad
        deviceId: GamepadManager.connectedGamepads.length > 0 ? GamepadManager.connectedGamepads[0] : -1
        // onDeviceIdChanged: console.debug("gamepad onDeviceIdChanged", gamepad.deviceId)
    }

    ListModel {
        id: gamepadModel
    }

}
