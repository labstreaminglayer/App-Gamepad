![CI Status](https://github.com/labstreaminglayer/App-Gamepad/workflows/C/C++%20CI/badge.svg)

# Gamepad App for LabStreamingLayer

[Please download from the release page](https://github.com/labstreaminglayer/App-Gamepad/releases).

![Image of GamepadLSL](https://github.com/labstreaminglayer/App-Gamepad/blob/master/GamepadLSL-screenshot.PNG?raw=true)

## Description

This application creates 2 labstreaminglayer streams:
1. analog stick positions and trigger depths at a regular (user-specified) rate;
2. irregular button events (see details below).

This application is intended for use with Gamepads. Joysticks with multiple axes, with rotation, etc., are only supported using the [GameController App](https://github.com/labstreaminglayer/App-GameController) (old, Windows only).

### Streams

There are 2 streams. The stream names and types can be edited by the GUI. We use the default names below.

The "Gamepad" stream has 6 `double` channels with a continuous sampling rate (default: 60 Hz).
The channels are: LeftX, LeftY, RightX, RightY, L2, R2. The first 2 are for the X- and Y- positions of the left analog stick, the next 2 for the right analog stick, and finally the final 2 are for the two analog trigger buttons. Values range from -1.0 to +1.0 .
The sampling interval is determined in software, not with a hardware clock, so there might be some jitter between the true sampling time and the expected time based on the sampling rate.

The "Gamepad Events" stream has 2 `int` channels with irregularly-intervaled samples. The first channel is the button ID, and the second channel is a boolean to indicate whether a button is being pressed (1) or released (0). The channel mapping on the first channel is as follows: `{0:A, 1:B, 2:X, 3:Y, 4:Down, 5:Left, 6:Right, 7:Up, 8:L1, 9:R1, 10:Start, 11:L3, 12:R3, 13:Select, 14:Guide}`.

### Settings / Configuration

After the first run, a GamepadLSL.cfg file will be created in the same directory as the executable file. You can edit this file to update settings such as window layout, stream names, and sampling rate.

## Build

First check if a precompiled build is already available [on the release page](https://github.com/labstreaminglayer/App-Gamepad/releases).

### Dependencies

There's nothing platform-specific here, so it should build in Windows/Mac/Linux.

1. cmake >= 3.15
1. Qt
    * version 5.15 used for development typically installed with Qt Maintenance tool.
    * Ubuntu, if not using Qt maintenance tool, must be on 20.04 or later, and use `sudo apt install -y qtbase5-dev qtmultimedia5-dev qtdeclarative5-dev libqt5gamepad5-dev`.
    * Qt6 not supported.
1. An IDE. QtCreator or Visual Studio both tested to work.

Then follow the general [LSL Application build instructions](https://labstreaminglayer.readthedocs.io/dev/app_build.html).

## License

The source and the application components are provided under the MIT license,
but the Qt components are licensed under LGPL.
