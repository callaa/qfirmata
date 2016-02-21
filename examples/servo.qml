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
		}

		ServoPin {
			pin: 9
			value: dial.value
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
			text: "Servo"
		}
		Dial {
			id: dial
			minimumValue: 0
			maximumValue: 180
			value: 90
		}
	}
}

