#include "lsl_manager.hpp"
#include <algorithm>    // std::max
#include <QGamepad>
// #include <QDebug>
#include <QtCore/QObject>
#include <lsl_cpp.h>


LSLManager::LSLManager(QObject *parent)
    : QObject(parent)
{}

LSLManager::~LSLManager()
{
    if (streamer)
        stop_streamer();
}


void streaming_thread_function(
        QGamepad* gamepad,
        std::string stream_name_sampled, std::string stream_type_sampled, std::string stream_id_sampled, double sample_rate,
        std::string stream_name_events, std::string stream_type_events, std::string stream_id_events,
        std::atomic<bool> &shutdown)
{
    // qDebug() << "gamepad " << gamepad->deviceId() << "isConnected(): " << gamepad->isConnected();

    // Stream for irregular button-change events: https://doc.qt.io/qt-5/qgamepad.html#signals
    lsl::stream_info evstream_info(stream_name_events, stream_type_events, 2, lsl::IRREGULAR_RATE, lsl::cf_int8, stream_id_events); // TODO: unique_id
    lsl::xml_element ev_chans = evstream_info.desc().append_child("channels");
    ev_chans.append_child("channel")
            .append_child_value("label", "ButtonID")
            .append_child_value("type", "{0:A, 1:B, 2:X, 3:Y, 4:Down, 5:Left, 6:Right, 7:Up, 8:L1, 9:R1, 10:Start, 11:L3, 12:R3, 13:Select, 14:Guide}");
    ev_chans.append_child("channel")
            .append_child_value("label", "State")
            .append_child_value("type", "pressed")
            .append_child_value("unit", "boolean");
    lsl::stream_outlet evstream_outlet(evstream_info);
    QObject::connect(gamepad, &QGamepad::buttonAChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 0, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
        // qDebug() << "A " << pressed;
    });
    QObject::connect(gamepad, &QGamepad::buttonBChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 1, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonXChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 2, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonYChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 3, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonDownChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 4, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonLeftChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 5, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonRightChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 6, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonUpChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 7, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonL1Changed, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 8, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonR1Changed, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 9, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonStartChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 10, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonL3Changed, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 11, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonR3Changed, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 12, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonSelectChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 13, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });
    QObject::connect(gamepad, &QGamepad::buttonGuideChanged, [&evstream_outlet](bool pressed){
        std::vector<char> ev_dat{ 14, (char)pressed };
        evstream_outlet.push_sample(ev_dat);
    });

    lsl::stream_info sampstream_info(stream_name_sampled, stream_type_sampled, 6, sample_rate, lsl::cf_double64, stream_id_sampled);
    lsl::xml_element channels = sampstream_info.desc().append_child("channels");
    channels.append_child("channel")
            .append_child_value("label", "LeftX")
            .append_child_value("type", "PositionX")
            .append_child_value("unit","normalized_signed");
    channels.append_child("channel")
            .append_child_value("label", "LeftY")
            .append_child_value("type", "PositionY")
            .append_child_value("unit","normalized_signed");
    channels.append_child("channel")
            .append_child_value("label", "RightX")
            .append_child_value("type", "PositionX")
            .append_child_value("unit","normalized_signed");
    channels.append_child("channel")
            .append_child_value("label", "RightY")
            .append_child_value("type", "PositionY")
            .append_child_value("unit","normalized_signed");
    channels.append_child("channel")
            .append_child_value("label", "L2")
            .append_child_value("type", "Depth")
            .append_child_value("unit","normalized_signed");
    channels.append_child("channel")
            .append_child_value("label", "R2")
            .append_child_value("type", "Depth")
            .append_child_value("unit","normalized_signed");
    sampstream_info.desc().append_child("acquisition")
            .append_child_value("model", stream_name_sampled);
    lsl::stream_outlet sampstream_outlet(sampstream_info);

    // Info for manual timing
    int64_t sample_id = 0;
    double sample_dur = 1 / sample_rate;
    double t_zero = lsl::local_clock();

    // Start the main sampling loop
    while (!shutdown) {
        double t_now = lsl::local_clock();
        double sample[6] = {gamepad->axisLeftX(), gamepad->axisLeftY(),
                            gamepad->axisRightX(), gamepad->axisRightY(),
                            gamepad->buttonL2(), gamepad->buttonR2()};
        sampstream_outlet.push_sample(sample, t_now);
        sample_id++;
        // Sleep until next update time
        double t_next = t_zero + sample_id * sample_dur;
        int64_t sleep_dur_micro = (int64_t)(std::max(t_next - t_now, 0.0) * 1000000);
        std::this_thread::sleep_for(std::chrono::microseconds(sleep_dur_micro));
    }
}


void LSLManager::stop_streamer()
{
    shutdown = true;
    streamer->join();
    streamer.reset();
    streamStatusChange(!shutdown);  // emit signal so GUI may update stream-status indicator(s)
}


void LSLManager::linkStream(QGamepad* gamepad,
                            QString stream_name_sampled, QString stream_type_sampled, QString stream_id_sampled, double sample_rate,
                            QString stream_name_events, QString stream_type_events, QString stream_id_events)
{
    if (streamer)
    {
        stop_streamer();
    }
    else {
        if (gamepad->isConnected())
        {
            // qDebug() << "Starting thread";
            streamer = std::make_unique<std::thread>(
                        &streaming_thread_function,
                        gamepad,
                        stream_name_sampled.toStdString(), stream_type_sampled.toStdString(), stream_id_sampled.toStdString(), sample_rate,
                        stream_name_events.toStdString(), stream_type_events.toStdString(), stream_id_events.toStdString(),
                        std::ref(shutdown));
            shutdown = false;
            streamStatusChange(!shutdown);  // emit signal so GUI may update stream-status indicator(s)
        }
    }

}
