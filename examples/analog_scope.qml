import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1

import Firmata 1.0

Window {
	width: 600
	height: 400

	Firmata {
		id: firmata
		samplingInterval: 10
		backend: SerialFirmata { }

		AnalogPin {
			channel: 0
			pin: 14
			onSampled: { scope.addSample(value); }
		}
	}


	ColumnLayout {
		anchors.fill: parent

		PortSelector {
			firmata: firmata
		}

		Scope {
			id: scope
			Layout.fillWidth: true
			Layout.fillHeight: true
			bufferSize: 400
		}
	}
}

