import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4

import Firmata 1.0

Window {
	width: 400
	height: 200

	Firmata {
		id: firmata
		backend: SerialFirmata {
			//device: "/dev/ttyACM0"
		}
		samplingInterval: 100

		DigitalPin {
			id: led13
			output: true
			pin: 13
		}

		DigitalPin {
			id: button
			pullup: true
			pin: 2
		}

		AnalogPin {
			id: potentiometer
			channel: 0
			pin: 14
		}

		PwmPin {
			id: pwm
			pin: 9
		}

	}

	GridLayout {
		columns: 2
		anchors.fill: parent
		anchors.margins: 8
		rowSpacing: 10
		columnSpacing: 10

		Label {
			text: "Port:"
		}
		PortSelector {
			firmata: firmata
		}

		Label {
			text: "Digital 13 (LED)"
		}
		Switch {
			onClicked: led13.value = checked
			enabled: firmata.ready
		}

		Label { 
			text: "Digital 9 (PWM)"
		}
		Slider {
			orientation: Qt.Horizontal
			enabled: firmata.ready
			onValueChanged: pwm.value = value
		}

		Label {
			text: "Digital 2 (in)"
		}
		StatusIndicator {
			active: button.value
		}

		Label {
			text: "Analog 0 (in)"
		}
		Gauge {
			orientation: Qt.Horizontal
			value: potentiometer.value * 100
		}
	}
}

