import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 600
    height: 460
    radius: 8
    color: "#1A1C24"
    border.color: "#2E3240"
    border.width: 1

    signal closeRequested()

    RowLayout {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 14

        Text {
            text: "Settings"
            font.bold: true
            font.pixelSize: 16
            color: "#D69F47"
        }

        Item { Layout.fillWidth: true }

        Button {
            text: "✕"
            flat: true
            contentItem: Text { text: "✕"; color: "#8E92A0"; font.pixelSize: 14 }
            background: Rectangle { color: "transparent" }
            onClicked: root.closeRequested()
        }
    }

    ScrollView {
        anchors.top: header.bottom
        anchors.bottom: footer.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 14
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 16

            Text { text: "DISPLAY & GRAPHICS"; color: "#D69F47"; font.bold: true; font.pixelSize: 11 }

            RowLayout {
                Text { text: "Graphics Backend:"; color: "#E0E0E0"; Layout.preferredWidth: 150 }
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
                Text { text: "Refresh Rate:"; color: "#E0E0E0"; Layout.preferredWidth: 150 }
                ComboBox {
                    model: ["165 Hz (Native)", "144 Hz", "120 Hz", "60 Hz"]
                    currentIndex: 0
                    Layout.fillWidth: true
                    onActivated: (index) => {
                        const rates = [165, 144, 120, 60];
                        vmManager.refreshRate = rates[index];
                    }
                }
            }

            RowLayout {
                Text { text: "Aspect Ratio:"; color: "#E0E0E0"; Layout.preferredWidth: 150 }
                ComboBox {
                    model: ["16:9 Standard", "4:3 Stretched (Wider Hitboxes)", "21:9 Ultrawide (FOV+)"]
                    currentIndex: 0
                    Layout.fillWidth: true
                    onActivated: (index) => {
                        const modes = ["16:9", "4:3", "21:9"];
                        inputMapper.stretchMode = modes[index];
                    }
                }
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#252834" }

            Text { text: "AIM & CONTROLS"; color: "#D69F47"; font.bold: true; font.pixelSize: 11 }

            RowLayout {
                Text { text: "Crosshair Overlay:"; color: "#E0E0E0"; Layout.preferredWidth: 150 }
                CheckBox {
                    text: "Enable centered crosshair"
                    checked: inputMapper.crosshairEnabled
                    onToggled: inputMapper.crosshairEnabled = checked
                }
            }

            RowLayout {
                Text { text: "X / Y Sensitivity:"; color: "#E0E0E0"; Layout.preferredWidth: 150 }
                Slider {
                    from: 0.2; to: 4.0; value: inputMapper.sensX
                    Layout.fillWidth: true
                    onMoved: inputMapper.sensX = value
                }
                Text { text: inputMapper.sensX.toFixed(2); color: "#D69F47"; Layout.preferredWidth: 35 }
            }

            Rectangle { height: 1; Layout.fillWidth: true; color: "#252834" }

            Text { text: "ENGINE & SYSTEM"; color: "#D69F47"; font.bold: true; font.pixelSize: 11 }

            RowLayout {
                Text { text: "Root Privileges:"; color: "#E0E0E0"; Layout.preferredWidth: 150 }
                CheckBox {
                    text: "Enable KernelSU root access"
                    checked: vmManager.rootEnabled
                    onToggled: vmManager.rootEnabled = checked
                }
            }

            RowLayout {
                spacing: 10
                Button {
                    text: "Purge VRAM Cache"
                    onClicked: vmManager.purgeVramCache()
                }
                Button {
                    text: "Save Fast-Resume State"
                    onClicked: vmManager.saveFastResumeSnapshot()
                }
            }
        }
    }

    Rectangle {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 48
        color: "#14151B"
        radius: 8

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12

            Text {
                text: "Amberity v0.1.0"
                color: "#5C6070"
                font.pixelSize: 11
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Done"
                highlighted: true
                onClicked: root.closeRequested()
            }
        }
    }
}
