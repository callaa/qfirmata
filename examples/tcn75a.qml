// I2C temperature sensor (TCN75A) reading example
import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4

import Firmata 1.0

Window {
	width: 100
	height: 400

	Firmata {
		id: firmata
		backend: SerialFirmata {
			device: "/dev/ttyACM0"
		}

		samplingInterval: 1000

		// On an Arduino UNO, the I2C pins are A4 (SDL) and A5 (SCL).
		// Connect 4.7k pull-up resistors to A4 and A5
		I2C {
			id: i2c
			onReply: {
				if(address == 0x48 && data.length==2) {
					var temp = data[0];
					if(temp & 0x80) {
						// negative temperature (twos complement)
						temp = -(((temp ^ 0xff)+1) & 0xff);
					}

					thermometer.value = temp;
				}
			}
		}

		onReady: {
			// Select temperature register and start reading
			i2c.write(0x48, [0]);
			i2c.autoRead(0x48, 2);
		}
	}

	Gauge {
		id: thermometer
		property color color
		anchors.fill: parent
		anchors.margins: 16

		color: firmata.ready ? "red" : "gray"

		orientation: Qt.Vertical
		formatValue: function(value) { return value.toFixed(1) }
		value: 0
		minimumValue: -15
		maximumValue: 80
		style: GaugeStyle {
			foreground: null
			valueBar: Rectangle {
				color: control.color
				implicitWidth: 16
				radius: 16/2

				Rectangle {
					x: parent.x+parent.width/2-16
					y: parent.y+parent.height-16
					width: 32
					height: 32
					radius: 16
					color: control.color
				}
			}
		}
	}
}

