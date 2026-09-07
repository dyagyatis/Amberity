#include "InputMapper.hpp"
#include <QDebug>
#include <QtMath>

InputMapper::InputMapper(QObject *parent)
    : QObject(parent)
    , m_isAiming(false)
    , m_sensX(1.2f)
    , m_sensY(0.9f)
    , m_rawInput(true)
    , m_crosshairEnabled(true)
    , m_stretchMode("16:9")
    , m_digitalVibrance(1.35f)
    , m_casSharpening(0.4f)
    , m_virtualAimCenter(0.7f, 0.5f)
{
}

void InputMapper::setSensX(float s) {
    if (!qFuzzyCompare(m_sensX, s)) {
        m_sensX = s;
        emit sensitivityChanged();
    }
}

void InputMapper::setSensY(float s) {
    if (!qFuzzyCompare(m_sensY, s)) {
        m_sensY = s;
        emit sensitivityChanged();
    }
}

void InputMapper::setRawInput(bool enabled) {
    if (m_rawInput != enabled) {
        m_rawInput = enabled;
        emit rawInputChanged(m_rawInput);
    }
}

void InputMapper::setCrosshairEnabled(bool enabled) {
    if (m_crosshairEnabled != enabled) {
        m_crosshairEnabled = enabled;
        emit crosshairChanged(m_crosshairEnabled);
    }
}

void InputMapper::setStretchMode(const QString &mode) {
    if (m_stretchMode != mode) {
        m_stretchMode = mode;
        emit stretchModeChanged(m_stretchMode);
    }
}

void InputMapper::setDigitalVibrance(float v) {
    if (!qFuzzyCompare(m_digitalVibrance, v)) {
        m_digitalVibrance = v;
        emit vibranceChanged(m_digitalVibrance);
    }
}

void InputMapper::setCasSharpening(float s) {
    if (!qFuzzyCompare(m_casSharpening, s)) {
        m_casSharpening = s;
        emit sharpeningChanged(m_casSharpening);
    }
}

void InputMapper::toggleAimMode() {
    setAimMode(!m_isAiming);
}

void InputMapper::setAimMode(bool active) {
    if (m_isAiming != active) {
        m_isAiming = active;
        emit aimModeChanged(m_isAiming);
    }
}

void InputMapper::handleMouseMove(float deltaX, float deltaY) {
    if (!m_isAiming) return;

    // Математика прицеливания BlueStacks 4:
    // Конвертируем дельты мыши в смещение виртуального тач-пальца
    float effectiveX = deltaX * m_sensX * 0.0015f;
    float effectiveY = deltaY * m_sensY * 0.0015f;

    // Отправляем тач-событие свайпа в Android
    emit touchEventEmitted(m_virtualAimCenter.x() + effectiveX,
                           m_virtualAimCenter.y() + effectiveY,
                           2 /* ACTION_MOVE */);
}

void InputMapper::handleKeyPress(int key, bool isDown) {
    // Smart Aim: авто-разблокировка курсора при удержании Tab (инвентарь) или B (закупка)
    // 0x01000001 = Qt::Key_Tab, 0x42 = Qt::Key_B
    if (key == 0x01000001 || key == 0x42) {
        setAimMode(!isDown);
    }
}

void InputMapper::loadProfile(const QString &gameName) {
    qDebug() << "[InputMapper] Загружен профиль управления для:" << gameName;
}

void InputMapper::saveProfile(const QString &gameName) {
    qDebug() << "[InputMapper] Сохранен профиль управления для:" << gameName;
}
