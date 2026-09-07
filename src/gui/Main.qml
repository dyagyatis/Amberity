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
    title: "Amberity Player ⚡ [165 Hz • KVM Native]"
    color: "#121318"

    // Главный макет: Игровой холст (слева) + Сайдбар (справа)
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ==========================================
        // 1. ЦЕНТРАЛЬНАЯ ОБЛАСТЬ: ЭКРАН ИГРЫ (CANVAS)
        // ==========================================
        Item {
            id: gameViewport
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                id: canvasBg
                anchors.fill: parent
                color: "#16171D"

                // Индикатор состояния / Заставка
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12
                    visible: !vmManager.isRunning

                    Text {
                        text: "⚡ AMBERITY"
                        font.bold: true
                        font.pixelSize: 36
                        color: "#D69F47"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Native Linux Android Gaming Player • QEMU-KVM Engine"
                        font.pixelSize: 14
                        color: "#8E92A0"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Button {
                        text: "▶ Запустить движок"
                        Layout.alignment: Qt.AlignHCenter
                        highlighted: true
                        onClicked: vmManager.startVm()
                    }
                }

                // Визуализация работы игры
                Rectangle {
                    anchors.fill: parent
                    color: "#181A22"
                    visible: vmManager.isRunning

                    Text {
                        anchors.centerIn: parent
                        text: "Android Gaming Surface (" + inputMapper.stretchMode + ")\nVulkan Venus • 165 Hz Active"
                        font.pixelSize: 18
                        color: "#2C3040"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // ОВЕРЛЕЙ 1: Кастомный прицел (Crosshair Overlay)
                Item {
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    visible: vmManager.isRunning && inputMapper.crosshairEnabled

                    Rectangle {
                        anchors.centerIn: parent
                        width: 4; height: 4; radius: 2
                        color: "#D69F47"
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: 16; height: 1.5
                        color: "#D69F47"
                    }
                    Rectangle {
                        anchors.centerIn: parent
                        width: 1.5; height: 16
                        color: "#D69F47"
                    }
                }

                // ОВЕРЛЕЙ 2: Мониторинг железа (Hardware HUD)
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 12
                    height: 26
                    width: hudText.implicitWidth + 16
                    radius: 4
                    color: "#A0121318"
                    visible: vmManager.isRunning

                    Text {
                        id: hudText
                        anchors.centerIn: parent
                        text: "⚡ " + vmManager.fps + " FPS  |  GPU: " + vmManager.gpuTemp.toFixed(1) + "°C  |  VRAM: " + vmManager.vramUsage.toFixed(1) + " GB"
                        font.pixelSize: 11
                        font.bold: true
                        color: "#D69F47"
                    }
                }

                // ОБЛАСТЬ DRAG & DROP: Перетаскивание APK
                DropArea {
                    anchors.fill: parent
                    onEntered: (drag) => {
                        if (drag.hasUrls) drag.acceptProposedAction()
                    }
                    onDropped: (drop) => {
                        for (var i = 0; i < drop.urls.length; i++) {
                            var url = drop.urls[i].toString()
                            if (url.endsWith(".apk") || url.endsWith(".xapk")) {
                                vmManager.installApk(url)
                            }
                        }
                    }
                }
            }
        }

        // ==========================================
        // 2. БОКОВОЙ САЙДБАР (В СТИЛЕ BLUESTACKS 5)
        // ==========================================
        Rectangle {
            id: sidebar
            Layout.preferredWidth: 54
            Layout.fillHeight: true
            color: "#1A1C23"
            border.color: "#282B37"
            border.width: 1

            ColumnLayout {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                spacing: 6

                SidebarButton {
                    iconText: vmManager.isRunning ? "⏹" : "▶"
                    tooltipText: vmManager.isRunning ? "Остановить движок" : "Запустить движок"
                    isActive: vmManager.isRunning
                    onClicked: {
                        if (vmManager.isRunning) vmManager.stopVm();
                        else vmManager.startVm();
                    }
                }

                SidebarButton {
                    iconText: "🎯"
                    tooltipText: "Режим стрельбы / Прицел (F1)"
                    isActive: inputMapper.isAiming
                    onClicked: inputMapper.toggleAimMode()
                }

                SidebarButton {
                    iconText: "⌨"
                    tooltipText: "Редактор кнопок управления"
                    onClicked: toast.show("Редактор кеймаппинга активен")
                }

                SidebarButton {
                    iconText: "📸"
                    tooltipText: "Скриншот в буфер обмена (F12)"
                    onClicked: toast.show("Скриншот скопирован в буфер обмена!")
                }

                SidebarButton {
                    iconText: "⛶"
                    tooltipText: "Полноэкранный режим (F11)"
                    onClicked: {
                        if (window.visibility === Window.FullScreen)
                            window.showNormal();
                        else
                            window.showFullScreen();
                    }
                }

                SidebarButton {
                    iconText: "🔄"
                    tooltipText: "Поворот экрана (16:9 / 9:16)"
                    onClicked: {
                        var w = window.width;
                        window.width = window.height;
                        window.height = w;
                    }
                }

                Item { Layout.fillHeight: true } // Распорка

                SidebarButton {
                    iconText: "⚙"
                    tooltipText: "Настройки Amberity"
                    isActive: settingsModal.visible
                    onClicked: settingsModal.visible = !settingsModal.visible
                }
            }
        }
    }

    // ==========================================
    // 3. МОДАЛЬНОЕ ОКНО НАСТРОЕК
    // ==========================================
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

    // ==========================================
    // 4. ВСПЛЫВАЮЩИЕ УВЕДОМЛЕНИЯ (TOAST)
    // ==========================================
    Rectangle {
        id: toast
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 24
        height: 38
        width: toastText.implicitWidth + 28
        radius: 19
        color: "#222530"
        border.color: "#D69F47"
        border.width: 1
        opacity: 0.0
        visible: opacity > 0.0

        Behavior on opacity { NumberAnimation { duration: 200 } }

        function show(msg) {
            toastText.text = msg;
            toast.opacity = 1.0;
            toastTimer.restart();
        }

        Text {
            id: toastText
            anchors.centerIn: parent
            color: "#D69F47"
            font.bold: true
            font.pixelSize: 13
        }

        Timer {
            id: toastTimer
            interval: 2500
            onTriggered: toast.opacity = 0.0
        }
    }

    Connections {
        target: vmManager
        function onLogMessage(message) {
            console.log("[Amberity Engine]", message);
        }
        function onApkInstallProgress(progress, status) {
            toast.show(status);
        }
    }
}
