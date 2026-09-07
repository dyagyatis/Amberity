import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    width: 1280
    height: 720
    minimumWidth: 960
    minimumHeight: 540
    visible: true
    title: "Amberity Player"
    color: "#121318"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            id: gameViewport
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#16171D"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12
                    visible: !vmManager.isRunning

                    Text {
                        text: "AMBERITY"
                        font.bold: true
                        font.pixelSize: 32
                        color: "#D69F47"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "QEMU-KVM Android Runtime"
                        font.pixelSize: 13
                        color: "#8E92A0"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Button {
                        text: "Start Engine"
                        Layout.alignment: Qt.AlignHCenter
                        highlighted: true
                        onClicked: vmManager.startVm()
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#181A22"
                    visible: vmManager.isRunning

                    Text {
                        anchors.centerIn: parent
                        text: "Android Surface (" + inputMapper.stretchMode + ")\n165 Hz • VirtIO-GPU"
                        font.pixelSize: 16
                        color: "#2C3040"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Item {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    visible: vmManager.isRunning && inputMapper.crosshairEnabled

                    Rectangle {
                        anchors.centerIn: parent
                        width: 3; height: 3; radius: 1.5
                        color: "#D69F47"
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: 14; height: 1.5
                        color: "#D69F47"
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: 1.5; height: 14
                        color: "#D69F47"
                    }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 12
                    height: 24
                    width: hudText.implicitWidth + 16
                    radius: 3
                    color: "#B0121318"
                    visible: vmManager.isRunning

                    Text {
                        id: hudText
                        anchors.centerIn: parent
                        text: vmManager.fps + " FPS  |  GPU " + vmManager.gpuTemp.toFixed(0) + "°C  |  VRAM " + vmManager.vramUsage.toFixed(1) + " GB"
                        font.pixelSize: 11
                        font.bold: true
                        color: "#D69F47"
                    }
                }

                DropArea {
                    anchors.fill: parent
                    onEntered: (drag) => {
                        if (drag.hasUrls) drag.acceptProposedAction()
                    }
                    onDropped: (drop) => {
                        for (let i = 0; i < drop.urls.length; i++) {
                            const url = drop.urls[i].toString()
                            if (url.endsWith(".apk") || url.endsWith(".xapk")) {
                                vmManager.installApk(url)
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: sidebar
            Layout.preferredWidth: 50
            Layout.fillHeight: true
            color: "#1A1C23"
            border.color: "#282B37"
            border.width: 1

            ColumnLayout {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 8
                anchors.bottomMargin: 8
                spacing: 4

                SidebarButton {
                    iconText: vmManager.isRunning ? "⏹" : "▶"
                    tooltipText: vmManager.isRunning ? "Stop" : "Start"
                    isActive: vmManager.isRunning
                    onClicked: {
                        if (vmManager.isRunning) vmManager.stopVm();
                        else vmManager.startVm();
                    }
                }

                SidebarButton {
                    iconText: "⌖"
                    tooltipText: "Aim Mode (F1)"
                    isActive: inputMapper.isAiming
                    onClicked: inputMapper.toggleAimMode()
                }

                SidebarButton {
                    iconText: "⌨"
                    tooltipText: "Keymap Editor"
                    onClicked: toast.show("Keymapper enabled")
                }

                SidebarButton {
                    iconText: "📷"
                    tooltipText: "Screenshot (F12)"
                    onClicked: toast.show("Screenshot copied to clipboard")
                }

                SidebarButton {
                    iconText: "⛶"
                    tooltipText: "Fullscreen (F11)"
                    onClicked: {
                        if (window.visibility === Window.FullScreen)
                            window.showNormal();
                        else
                            window.showFullScreen();
                    }
                }

                SidebarButton {
                    iconText: "↻"
                    tooltipText: "Rotate"
                    onClicked: {
                        const w = window.width;
                        window.width = window.height;
                        window.height = w;
                    }
                }

                Item { Layout.fillHeight: true }

                SidebarButton {
                    iconText: "⚙"
                    tooltipText: "Settings"
                    isActive: settingsModal.visible
                    onClicked: settingsModal.visible = !settingsModal.visible
                }
            }
        }
    }

    Rectangle {
        id: modalDimmer
        anchors.fill: parent
        color: "#90000000"
        visible: settingsModal.visible

        MouseArea {
            anchors.fill: parent
            onClicked: settingsModal.visible = false
        }

        SettingsModal {
            id: settingsModal
            anchors.centerIn: parent
            visible: false
            onCloseRequested: settingsModal.visible = false
        }
    }

    Rectangle {
        id: toast
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 24
        height: 34
        width: toastText.implicitWidth + 24
        radius: 17
        color: "#222530"
        border.color: "#D69F47"
        border.width: 1
        opacity: 0.0
        visible: opacity > 0.0

        Behavior on opacity { NumberAnimation { duration: 150 } }

        function show(msg) {
            toastText.text = msg;
            toast.opacity = 1.0;
            toastTimer.restart();
        }

        Text {
            id: toastText
            anchors.centerIn: parent
            color: "#D69F47"
            font.pixelSize: 12
        }

        Timer {
            id: toastTimer
            interval: 2200
            onTriggered: toast.opacity = 0.0
        }
    }

    Connections {
        target: vmManager
        function onLogMessage(message) {
            console.log("[Amberity]", message);
        }
        function onApkInstallProgress(progress, status) {
            toast.show(status);
        }
    }
}
