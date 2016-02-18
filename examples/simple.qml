// A minimalistic QML Firmata example
// This creates a window with a single toggle switch that sets the state of
// digital output pin 13 (typically conneceted to a built-in LED in Arduinos)

import QtQuick 2.0
import QtQuick.Controls 1.3

import Firmata 1.0

Rectangle {
	Firmata {
		backend: SerialFirmata {
			device: "/dev/ttyACM0"
		}

		DigitalPin {
			output: true
			pin: 13
			value: led_switch.checked
		}
	}

	Switch {
		id: led_switch
		anchors.centerIn: parent
	}
}

