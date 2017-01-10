TEMPLATE = lib
CONFIG += plugin c++11 debug
QT += qml serialport
DEFINES += QT_NO_SIGNALS_SLOTS_KEYWORDS

DESTDIR = imports/Firmata
TARGET  = qmlfirmataplugin

SOURCES += \
	plugin.cpp \
	src/firmata.cpp \
	src/backends/backend.cpp \
	src/backends/serialport.cpp \
	src/backends/serialinfo.cpp \
	src/pins/pin.cpp \
    src/pins/digitalpin.cpp \
    src/pins/pwmpin.cpp \
    src/pins/analogpin.cpp \
    src/pins/servo.cpp \
    src/pins/encoder.cpp \
    src/pins/i2c.cpp

HEADERS += \
	plugin.h \
	src/utils.h \
	src/firmata.h \
	src/backends/backend.h \
	src/backends/serialport.h \
	src/backends/serialinfo.h \
	src/pins/pin.h \
    src/pins/digitalpin.h \
    src/pins/pwmpin.h \
    src/pins/analogpin.h \
    src/pins/servo.h \
    src/pins/encoder.h \
    src/pins/i2c.h

pluginfiles.files += \
    imports/Firmata/qmldir

installPath = $$[QT_INSTALL_QML]/Firmata
pluginfiles.path = $$installPath
target.path = $$installPath

INSTALLS += target pluginfiles

