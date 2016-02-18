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

#include "plugin.h"

#include "src/firmata.h"

#include "src/pins/digitalpin.h"
#include "src/pins/pwmpin.h"
#include "src/pins/analogpin.h"
#include "src/pins/servo.h"
#include "src/pins/encoder.h"
#include "src/pins/i2c.h"

#include "src/backends/serialport.h"
#include "src/backends/serialinfo.h"

#include <qqml.h>

static QObject *serialportlist_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
	Q_UNUSED(engine);
	Q_UNUSED(scriptEngine);
	return new SerialPortList;
}

void QmlFirmataPlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("Firmata"));

    qmlRegisterType<Firmata>(uri, 1, 0, "Firmata");

	qmlRegisterUncreatableType<Pin>(uri, 1, 0, "Pin", "Use a concrete Pin class, such as DigitalPin or AnalogPin");
	qmlRegisterType<DigitalPin>(uri, 1, 0, "DigitalPin");
	qmlRegisterType<PwmPin>(uri, 1, 0, "PwmPin");
	qmlRegisterType<AnalogPin>(uri, 1, 0, "AnalogPin");
	qmlRegisterType<ServoPin>(uri, 1, 0, "ServoPin");
	qmlRegisterType<EncoderPins>(uri, 1, 0, "EncoderPins");
	qmlRegisterType<I2C>(uri, 1, 0, "I2C");

    qmlRegisterUncreatableType<FirmataBackend>(uri, 1, 0, "FirmataBackend", "Use a concrete backend class, such as SerialFirmata");
    qmlRegisterType<SerialFirmata>(uri, 1, 0, "SerialFirmata");
	qmlRegisterSingletonType<SerialPortList>(uri, 1, 0, "SerialPortList", serialportlist_provider);
}

