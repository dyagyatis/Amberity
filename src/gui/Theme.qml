pragma Singleton
import QtQuick

QtObject {
    // Основная фирменная палитра Amberity
    readonly property color amberGold: "#D69F47"
    readonly property color amberHover: "#E6B15B"
    readonly property color amberDark: "#9E732E"
    readonly property color amberGlow: "#40D69F47"

    // Темные фоновые тона (Matte Graphite)
    readonly property color bgApp: "#121318"
    readonly property color bgCanvas: "#16171D"
    readonly property color bgSidebar: "#1A1C23"
    readonly property color bgCard: "#222530"
    readonly property color bgInput: "#2A2D3A"

    // Текстовые цвета
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#8E92A0"
    readonly property color textMuted: "#5C6070"

    // Границы и разделители
    readonly property color borderDark: "#282B37"
    readonly property color borderActive: "#D69F47"

    // Параметры интерфейса
    readonly property int sidebarWidth: 54
    readonly property int cornerRadius: 8
    readonly property int animationSpeed: 180
}
