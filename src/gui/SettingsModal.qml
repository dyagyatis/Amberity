import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 620
    height: 480
    radius: 12
    color: "#1A1C24"
    border.color: "#D69F47"
    border.width: 1

    signal closeRequested()

    // Заголовок
    RowLayout {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16

        Text {
            text: "⚙ Настройки Amberity"
            font.bold: true
            font.pixelSize: 18
            color: "#D69F47"
        }

        Item { Layout.fillWidth: true }

        Button {
            text: "✕"
            flat: true
            contentItem: Text { text: "✕"; color: "#8E92A0"; font.pixelSize: 16 }
            background: Rectangle { color: "transparent" }
            onClicked: root.closeRequested()
        }
    }

    // Содержимое
    ScrollView {
        anchors.top: header.bottom
        anchors.bottom: footer.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 18

            // Раздел 1: Графика и экран
            Text { text: "🎮 ГРАФИКА И МОНИТОР (165 HZ)"; color: "#D69F47"; font.bold: true; font.pixelSize: 13 }

            RowLayout {
                Text { text: "Графический API:"; color: "#FFFFFF"; Layout.preferredWidth: 160 }
                ComboBox {
                    model: ["Auto (Venus + VirGL)", "Vulkan (Venus Direct)", "OpenGL (VirGL)"]
                    currentIndex: 0
                    Layout.fillWidth: true
                    onActivated: (index) => {
                        if (index === 0) vmManager.graphicsBackend = "auto";
                        else if (index === 1) vmManager.graphicsBackend = "vulkan";
                        else vmManager.graphicsBackend = "opengl";
                    }
                }
            }

            RowLayout {
                Text { text: "Частота экрана:"; color: "#FFFFFF"; Layout.preferredWidth: 160 }
                ComboBox {
                    model: ["165 Hz (Native)", "144 Hz", "120 Hz", "60 Hz"]
                    currentIndex: 0
                    Layout.fillWidth: true
                    onActivated: (index) => {
                        var rates = [165, 144, 120, 60];
                        vmManager.refreshRate = rates[index];
                    }
                }
            }

            RowLayout {
                Text { text: "Соотношение сторон:"; color: "#FFFFFF"; Layout.preferredWidth: 160 }
                ComboBox {
                    model: ["16:9 Стандартный", "4:3 Растянутый (Широкие модели)", "21:9 Ультраширокий (FOV+)"]
                    currentIndex: 0
                    Layout.fillWidth: true
                    onActivated: (index) => {
                        var modes = ["16:9", "4:3", "21:9"];
                        inputMapper.stretchMode = modes[index];
                    }
                }
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#282B37" }

            // Раздел 2: Управление и шутеры
            Text { text: "🎯 ПРИЦЕЛИВАНИЕ И МЫШЬ"; color: "#D69F47"; font.bold: true; font.pixelSize: 13 }

            RowLayout {
                Text { text: "Кастомный прицел:"; color: "#FFFFFF"; Layout.preferredWidth: 160 }
                CheckBox {
                    text: "Включить поверх экрана"
                    checked: inputMapper.crosshairEnabled
                    onToggled: inputMapper.crosshairEnabled = checked
                }
            }

            RowLayout {
                Text { text: "Сенса X / Y:"; color: "#FFFFFF"; Layout.preferredWidth: 160 }
                Slider {
                    from: 0.2; to: 4.0; value: inputMapper.sensX
                    Layout.fillWidth: true
                    onMoved: inputMapper.sensX = value
                }
                Text { text: inputMapper.sensX.toFixed(2); color: "#D69F47"; Layout.preferredWidth: 40 }
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#282B37" }

            // Раздел 3: Твики и оптимизация
            Text { text: "⚡ ДВИЖОК И ПАМЯТЬ"; color: "#D69F47"; font.bold: true; font.pixelSize: 13 }

            RowLayout {
                Text { text: "Root-права (KernelSU):"; color: "#FFFFFF"; Layout.preferredWidth: 160 }
                CheckBox {
                    text: "Активировать Root в Android"
                    checked: vmManager.rootEnabled
                    onToggled: vmManager.rootEnabled = checked
                }
            }

            RowLayout {
                Button {
                    text: "🧹 Очистить кэш VRAM"
                    onClicked: vmManager.purgeVramCache()
                }
                Button {
                    text: "💾 Сохранить снимок Fast-Resume"
                    onClicked: vmManager.saveFastResumeSnapshot()
                }
            }
        }
    }

    // Футер
    Rectangle {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 52
        color: "#16171D"
        radius: 12

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12

            Text {
                text: "Amberity v0.1.0 • QEMU-KVM Native Engine"
                color: "#5C6070"
                font.pixelSize: 12
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Готово"
                highlighted: true
                onClicked: root.closeRequested()
            }
        }
    }
}
