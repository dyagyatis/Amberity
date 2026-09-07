#pragma once

#include <QObject>
#include <QProcess>
#include <QString>
#include <QStringList>

class VmManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY stateChanged)
    Q_PROPERTY(int fps READ fps NOTIFY fpsChanged)
    Q_PROPERTY(QString graphicsBackend READ graphicsBackend WRITE setGraphicsBackend NOTIFY graphicsBackendChanged)
    Q_PROPERTY(int refreshRate READ refreshRate WRITE setRefreshRate NOTIFY refreshRateChanged)
    Q_PROPERTY(bool rootEnabled READ rootEnabled WRITE setRootEnabled NOTIFY rootEnabledChanged)
    Q_PROPERTY(float gpuTemp READ gpuTemp NOTIFY hardwareStatsUpdated)
    Q_PROPERTY(float vramUsage READ vramUsage NOTIFY hardwareStatsUpdated)

public:
    explicit VmManager(QObject *parent = nullptr);
    ~VmManager() override;

    bool isRunning() const { return m_isRunning; }
    int fps() const { return m_fps; }
    QString graphicsBackend() const { return m_graphicsBackend; }
    int refreshRate() const { return m_refreshRate; }
    bool rootEnabled() const { return m_rootEnabled; }
    float gpuTemp() const { return m_gpuTemp; }
    float vramUsage() const { return m_vramUsage; }

    void setGraphicsBackend(const QString &backend);
    void setRefreshRate(int rate);
    void setRootEnabled(bool enabled);

public slots:
    void startVm();
    void stopVm();
    void restartVm();
    void installApk(const QString &path);
    void saveFastResumeSnapshot();
    void purgeVramCache();

signals:
    void stateChanged(bool running);
    void fpsChanged(int fps);
    void graphicsBackendChanged(const QString &backend);
    void refreshRateChanged(int rate);
    void rootEnabledChanged(bool enabled);
    void hardwareStatsUpdated();
    void apkInstallProgress(int progress, const QString &status);
    void logMessage(const QString &message);

private slots:
    void onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void onProcessReadyRead();

private:
    QStringList buildQemuArgs() const;

    QProcess *m_process;
    bool m_isRunning;
    int m_fps;
    QString m_graphicsBackend;
    int m_refreshRate;
    bool m_rootEnabled;
    float m_gpuTemp;
    float m_vramUsage;
};
