A Firmata library for Qt
------------------------

QFirmata is a [QML] library that implements the [Firmata protocol]. With it, you can quickly build snazzy GUIs for controlling Arduinos and other devices with Firmata firmware.


## Installation

Build:

    qmake-qt5
    make

Install (as root):

    make install

You can try out the examples in `examples/` directory without running the installation step.

## Requirements

QFirmata supports Firmata protocol version 2.5.
The following features are needed from the device firmware:

 * "Set digital pin value command" is used, rather than "digital IO message" to set pin values. (Digital IO message is supported for digital inputs, though.)
 * The firmware should respond to protocol version request. The library considers the connection active when it receives the protocol version message.
 * The firmware must support "Analog Mapping Query" for automatic analog pin mapping to work.

The library has been tested to be compatible with:

 * OldStandardFirmata (tested with Arduino Duemilanove with ATmega168)
   * Only supports digital in, analog in and pwm out
   * Internal pullup mode is not supported
   * Changing the sampling interval changing is not supported
   * Copy "set digital pin value" command from StandardFirmata for digital out to work
   * Uses baudrate 115200 by default
 * StandardFirmata (tested with Arduino UNO)
   * Does not implement the Encoder pin mode
 * ConfigurableFirmata (tested with Arduino UNO)


## Usage

A very basic example:

    import QtQuick 2.0
    import QtQuick.Controls 1.3
    
    import Firmata 1.0
    
    Rectangle {
        Firmata {
            // Use serial USB device 0
            backend: SerialFirmata {
                device: "/dev/ttyUSB0"
            }
            // Configure pin #13 as a digital output pin
            // (On Arduino Uno and other boards, this pin has a built-in LED)
            // The value of the pin (on/off) is bound to the value of the switch widget
            DigitalPin {
                output: true
                pin: 13
                value: led_switch.checked
            }
        }
    
        // A switch UI widget
        Switch {
            id: led_switch
            anchors.centerIn: parent
        }
    }

This example can be found in the `examples/` directory. You can run it with the `qmlscene` wrapper program provided by Qt.

The main Firmata component supports the following properties:

 * `backend`: set device connection properties here
 * `initPins`: automatically configure pins. This is `true` by default. Set this to `false` if your device is running a custom firmware that doesn't support changing pin modes.
 * `samplingInterval`: analog and I²C sampling interval in milliseconds
 * `ready`: this read-only flag is set to `true` when the device connection is ready
 * `statusText`: the current status (error messages will be shown here)
 * `ready()`: this signal is emitted when the device connection becomes ready
 * `stringReceived(QString)` signal is emitted when a SysEx string is received from the device

## Backends

Only one backend is implemented at the moment:

    SerialFirmata {
        device: "serial port"
        baudrate: 57600
    }

A singleton model `SerialPortList` is provided for listing the available serial ports.

## Pins

Support for the following pin types is currently implemented:

### DigitalPin

Basic digital IO pin.

    DigitalPin {
        pin: pin#
        output: false // set to true to make this an output pin
        pullup: false // set to true to enable internal pullups in input mode
        value: true
    }

When `initPins` is `true`, QFirmata will automatically request change reports for input pins.

### AnalogPin

Analog input pin.

    AnalogPin {
        channel: channel#
        pin: pin#       // optional
        value: 1.0      // value in range 0.0--1.0 (clamped)
        rawValue: 1024  // original value
        scale: 1/1024   // rawValue to value scaling factor
    }

Note: Analog pins are identified by two numbers: the pin number and the channel number. You can leave the pin number out and QFirmata will query it automatically.

### PwmPin

PWM output pin.

    PwmPin {
        pin: pin#
        value: 1.0 // value in range 0.0--1.0
        scale: 255 // scaling factor for output value
    }

### ServoPin

A hobby servo output pin.

    ServoPin {
        pin: pin#
        angle: 90      // angle in range 0--180
        minPulse: 1000 // pulse length in microseconds for angle 0
        maxPulse: 2000 // pulse length in microseconds for angle 180
    }

### EncoderPins

Encoder input pins.

	EncoderPins {
		pin: 3
		pin2: 4   // encoders need two pins
		number: 0 // encoder number (defaults to 0. Set this if you have more than one)
		value: 0  // read-only field containing the position
	}

The encoder pin also emits a `delta(int)` signal when the position changes and provides the following functions you can call:

 * `reset()` -- reset the position to zero
 * `queryPosition()` -- manually refresh the position. (This is done automatically at the moment.)

### I2C

The I²C bus.

    I2C {
		delay: 0 // optional delay between read and write

        onReply: {
			console.log("i2c read", address, reg, data);
        }
    }

Note that since Firmata currently supports only one I2C bus, the pin number is not required.
The following functions are available on the I2C component:

 * `write(address, data)` -- send the data in the array to the given address
 * `read(address, count, reg, autoRestart)` -- read *count* bytes from the given address and register. The register and autoRestart parameters are optional.
 * `autoRead(address, count, reg, autoRestart)` -- like above, except the read is automatically repeated when inputs are sampled.
 * `stopAutoRead(address)` -- stop an autoread


[Firmata protocol]: https://github.com/firmata/protocol
[QML]: http://doc.qt.io/qt-5/qtqml-index.html

