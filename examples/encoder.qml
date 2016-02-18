import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4

import Firmata 1.0

Window {
	width: 400
	height: 100

	Firmata {
		id: firmata
		backend: SerialFirmata {
			device: "/dev/ttyACM0"
		}

		EncoderPins {
			id: encoder
			pin: 2
			pin2: 3
		}
	}

	GridLayout {
		columns: 3
		anchors.fill: parent
		anchors.margins: 8
		rowSpacing: 10
		columnSpacing: 10

		Label {
			text: "Status:"
		}
		PortSelector {
			firmata: firmata
			Layout.columnSpan: 2
		}

		Label {
			text: "Encoder value:"
		}
		Label {
			text: encoder.value
		}

		Button {
			text: "Reset"
			onClicked: encoder.reset()
			enabled: firmata.ready
		}
	}
}

