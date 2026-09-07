#pragma once

#include <QObject>
#include <QString>
#include <QJsonObject>
#include <QJsonArray>
#include <QPointF>

class InputMapper : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isAiming READ isAiming NOTIFY aimModeChanged)
    Q_PROPERTY(float sensX READ sensX WRITE setSensX NOTIFY sensitivityChanged)
    Q_PROPERTY(float sensY READ sensY WRITE setSensY NOTIFY sensitivityChanged)
    Q_PROPERTY(bool rawInput READ rawInput WRITE setRawInput NOTIFY rawInputChanged)
    Q_PROPERTY(bool crosshairEnabled READ crosshairEnabled WRITE setCrosshairEnabled NOTIFY crosshairChanged)
    Q_PROPERTY(QString stretchMode READ stretchMode WRITE setStretchMode NOTIFY stretchModeChanged)
    Q_PROPERTY(float digitalVibrance READ digitalVibrance WRITE setDigitalVibrance NOTIFY vibranceChanged)
    Q_PROPERTY(float casSharpening READ casSharpening WRITE setCasSharpening NOTIFY sharpeningChanged)

public:
    explicit InputMapper(QObject *parent = nullptr);

    bool isAiming() const { return m_isAiming; }
    float sensX() const { return m_sensX; }
    float sensY() const { return m_sensY; }
    bool rawInput() const { return m_rawInput; }
    bool crosshairEnabled() const { return m_crosshairEnabled; }
    QString stretchMode() const { return m_stretchMode; }
    float digitalVibrance() const { return m_digitalVibrance; }
    float casSharpening() const { return m_casSharpening; }

    void setSensX(float s);
    void setSensY(float s);
    void setRawInput(bool enabled);
    void setCrosshairEnabled(bool enabled);
    void setStretchMode(const QString &mode);
    void setDigitalVibrance(float v);
    void setCasSharpening(float s);

public slots:
    void toggleAimMode();
    void setAimMode(bool active);
    void loadProfile(const QString &gameName);
    void saveProfile(const QString &gameName);
    void handleMouseMove(float deltaX, float deltaY);
    void handleKeyPress(int key, bool isDown);

signals:
    void aimModeChanged(bool isAiming);
    void sensitivityChanged();
    void rawInputChanged(bool enabled);
    void crosshairChanged(bool enabled);
    void stretchModeChanged(const QString &mode);
    void vibranceChanged(float v);
    void sharpeningChanged(float s);
    void touchEventEmitted(float normalizedX, float normalizedY, int action);

private:
    bool m_isAiming;
    float m_sensX;
    float m_sensY;
    bool m_rawInput;
    bool m_crosshairEnabled;
    QString m_stretchMode;
    float m_digitalVibrance;
    float m_casSharpening;

    QPointF m_virtualAimCenter;
};
