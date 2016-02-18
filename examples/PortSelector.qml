import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import Firmata 1.0

RowLayout {
	property Firmata firmata
	ComboBox {
		model: SerialPortList
		textRole: "name"
		onCurrentIndexChanged: selectDevice()
		Component.onCompleted: selectDevice()

		function selectDevice() {
			firmata.backend.device = currentText;
		}
	}

	Label {
		text: firmata.statusText
	}
}

