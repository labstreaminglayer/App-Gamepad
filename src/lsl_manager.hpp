#ifndef LSL_MANAGER_HPP
#define LSL_MANAGER_HPP

#include <QObject>
#include <atomic>
#include <memory>
#include <thread>

class LSLManager : public QObject
{
    Q_OBJECT

public:
    explicit LSLManager(QObject *parent = 0);
    ~LSLManager();

public slots:
    void linkStream(int gamepad_id,
                    QString stream_name_sampled, QString stream_type_sampled, double sample_rate,
                    QString stream_name_events, QString stream_type_events);

signals:
    void streamStatusChange(bool newStatus);

private:
    std::unique_ptr<std::thread> streamer{nullptr};
    std::atomic<bool> shutdown{false};  // flag indicating whether the streaming thread should quit
};

#endif // LSL_MANAGER_HPP
