import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 44
    height: 44

    property string iconText: "⚙"
    property string tooltipText: ""
    property bool isActive: false
    signal clicked()

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 8
        color: root.isActive ? "#2E2A20" : (mouseArea.containsMouse ? "#252834" : "transparent")
        border.color: root.isActive ? "#D69F47" : "transparent"
        border.width: 1

        Behavior on color { ColorAnimation { duration: 150 } }

        Text {
            anchors.centerIn: parent
            text: root.iconText
            font.pixelSize: 18
            color: root.isActive ? "#D69F47" : (mouseArea.containsMouse ? "#FFFFFF" : "#8E92A0")

            Behavior on color { ColorAnimation { duration: 150 } }
        }

        // Индикатор активного состояния слева
        Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 3
            height: 16
            radius: 1.5
            color: "#D69F47"
            visible: root.isActive
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    ToolTip.visible: mouseArea.containsMouse && root.tooltipText !== ""
    ToolTip.text: root.tooltipText
    ToolTip.delay: 400
}
