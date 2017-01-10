// QFirmata - a Firmata library for QML
//
// Copyright 2016 - Calle Laakkonen
// 
// QFirmata is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// QFirmata is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

#ifndef Q_FIRMATA_H
#define Q_FIRMATA_H

#include "backends/backend.h"
#include "pins/pin.h"

#include <QObject>
#include <QQmlListProperty>

//! A high level Firmata API for QML

//! Example use:
//! <pre><code>import Firmata 1.0
//!
//! Firmata {
//!     backend: SerialFirmata { device: "/dev/ttyUSB0" }
//!     initPins: false // custom firmware needs no configuration
//!     DigitalPin {
//!         pin: 2
//!         id: pin2
//!     }
//!     ... more pin configuration ...
//! }
//! </code></pre>
class Firmata : public QObject
{
	Q_OBJECT
	//! The device backend to use.
	//! Most commonly, \a SerialFirmata is used.
	Q_PROPERTY(FirmataBackend* backend READ backend WRITE setBackend NOTIFY backendChanged)

	//! Automatically configure pins.

	//! If set to true (the default), pin modes are automatically set. You should only
	//! set this to false if your device firmware has fixed pin modes.
	Q_PROPERTY(bool initPins READ isInitPins WRITE setInitPins NOTIFY initPinsChanged)

	//! Is the connection ready for use?

	//! This will be set to true (and readyChanged emitted) when the device
	//! connection becomes ready. When the device backend becomes available, QFirmata
	//! will automatically query the device for its supported protocol version.
	//! The connection is considered ready when the device replies.
	//! The signal ready() will be emitted when ready changes to true.
	Q_PROPERTY(bool ready READ isReady NOTIFY readyChanged)

	//! Status string
	Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)

	//! The sampling interval in milliseconds for analog inputs and I²C.
	Q_PROPERTY(int samplingInterval READ samplingInterval WRITE setSamplingInterval NOTIFY samplingIntervalChanged)

	//! Pin definitions
	Q_PROPERTY(QQmlListProperty<Pin> pins READ pins)
	Q_CLASSINFO("DefaultProperty", "pins")
public:
	Firmata(QObject *parent=nullptr);
	~Firmata();

	FirmataBackend *backend() const;
	void setBackend(FirmataBackend *backend);

	bool isReady() const;

	QString statusText() const;

	bool isInitPins() const;
	void setInitPins(bool);

	int samplingInterval() const;
	void setSamplingInterval(int si);

	QQmlListProperty<Pin> pins();

Q_SIGNALS:
	void backendChanged();
	void initPinsChanged(bool);
	void readyChanged(bool);
	void samplingIntervalChanged(int);
	void statusTextChanged();

	//! Device connection became ready to use
	void ready();

	//! Sysex string received
	void stringReceived(const QString&);

private Q_SLOTS:
	void onAnalogRead(uint8_t channel, uint16_t value);
	void onDigitalRead(uint8_t port, uint8_t value);
	void onDigitalPinRead(uint8_t pin, bool value);
	void onSysexRead(const QByteArray &data);
	void onBackendAvailable(bool ready);
	void onProtocolVersion(int major, int minor);

	void updateDigitalReport();

private:
	void doInitPins();

	void requestAnalogMappingIfNeeded();
	void sysexFirmwareName(const QByteArray &data);
	void sysexAnalogMapping(const QByteArray &data);
	void sysexString(const QByteArray &data);
	void sendSamplingInterval();

	static void pinAdd(QQmlListProperty<Pin> *list, Pin *p);
	static int pinCount(QQmlListProperty<Pin> *list);
	static Pin* pinAt(QQmlListProperty<Pin> *list, int i);
	static void pinClear(QQmlListProperty<Pin> *list);

	struct Private;
	Private *d;
};

#endif
