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
    height: 600
    title: qsTr("Gamepad LSL")
    color: "#363330"

    Settings {
            property alias x: applicationWindow1.x
            property alias y: applicationWindow1.y
            property alias width: applicationWindow1.width
            property alias height: applicationWindow1.height
        }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            Action { text: qsTr("&Load config...") }
            Action { text: qsTr("Save config &as...") }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            x: 5
            width: 790
            height: 195
            Layout.margins: 0
            Layout.rightMargin: 5
            Layout.leftMargin: 5
            Layout.minimumHeight: 195
            Layout.fillWidth: true

            Label {
                color: "#ffffff"
                text: qsTr("Select Device:")
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
            }

            ListView {
                id: gamepad_list
                Layout.fillHeight: false
                Layout.fillWidth: true
                model: gamepadModel
                delegate: Component {
                    Item {
                        width: parent.width
                        Text { text: 'Id:' + id + ' Name:' + name; color: 'white'; font.pointSize: 20 }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: gamepad_list.currentIndex = index
                        }
                    }
                }
                highlight: Rectangle {color: 'black'}
                focus: true
                onCurrentItemChanged: gamepad.deviceId = gamepadModel.get(gamepad_list.currentIndex).id
            }

            Button {
                id: linkbutton
                text: qsTr("Link")
                onClicked: lsl_manager.linkStream(gamepad.deviceId,
                                                  textedit_streamname_sampled.text, textedit_streamtype_sampled.text, spinBox_rate_x100.value / 100,
                                                  textedit_streamname_event.text, textedit_streamtype_event.text)
                function onStreamStatusChanged(is_linked) {
                    linkbutton.text = is_linked ? "Unlink" : "Link"
                }
                Component.onCompleted: {
                    lsl_manager.streamStatusChange.connect(onStreamStatusChanged)
                }
            }
        }

        RowLayout {
            x: 5
            width: 790
            Layout.margins: 0
            Layout.rightMargin: 5
            Layout.leftMargin: 5
            Layout.minimumHeight: 195
            Layout.fillHeight: false
            Layout.fillWidth: true

            Label {
                color: "#ffffff"
                text: qsTr("Stream Name:")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
            }
            TextEdit {
                id: textedit_streamname_sampled
                height: 40
                color: "#ffffff"
                text: qsTr("Gamepad")
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12
            }

            ToolSeparator {
                id: toolSeparator0
            }

            Label {
                color: "#ffffff"
                text: qsTr("Stream Type:")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
            }
            TextEdit {
                id: textedit_streamtype_sampled
                height: 40
                color: "#ffffff"
                text: qsTr("HID")
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 12
            }

            ToolSeparator {
                id: toolSeparator1
            }

            Label {
                color: "#ffffff"
                text: qsTr("Sampled Rate:")
                verticalAlignment: Text.AlignVCenter
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

        RowLayout {
            x: 5
            width: 790
            Layout.rightMargin: 5
            Layout.leftMargin: 5
            Layout.minimumHeight: 195
            Layout.fillHeight: false
            Layout.fillWidth: true
            Label {
                color: "#ffffff"
                text: qsTr("Event Stream Name:")
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
            }
            TextEdit {
                id: textedit_streamname_event
                color: "#ffffff"
                text: qsTr("Gamepad Events")
                Layout.fillWidth: true
                font.pixelSize: 12
            }

            ToolSeparator {
                id: toolSeparator2
            }

            Label {
                color: "#ffffff"
                text: qsTr("Event Stream Type:")
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
            }
            TextEdit {
                id: textedit_streamtype_event
                color: "#ffffff"
                text: qsTr("Markers")
                Layout.fillHeight: false
                Layout.fillWidth: true
                font.pixelSize: 12
            }

        }
    }

    Item {
        id: background
        opacity: 0.5
        anchors.fill: parent

    }

    Connections {
        target: GamepadManager
        function onGamepadConnected(deviceId) {
            gamepadModel.append({"id": deviceId, "name": gamepad.name});
        }
    }

    Gamepad {
        id: gamepad
        deviceId: GamepadManager.connectedGamepads.length > 0 ? GamepadManager.connectedGamepads[0] : -1
    }

    ListModel {
        id: gamepadModel
    }



}
