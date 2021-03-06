QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17
#CONFIG(debug, debug | release):CONFIG += sanitizer sanitize_undefined sanitize_address

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

QMAKE_CXXFLAGS_RELEASE += -O3 -march=native -flto
QMAKE_LFLAGS_RELEASE += -O3 -march=native -flto

SOURCES += \
    avxmedian.cpp \
    cppmedian.cpp \
    filter.cpp \
    image.cpp \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    avxmedian.h \
    cppmedian.h \
    filter.h \
    image.h \
    kernel.h \
    mainwindow.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

QMAKE_EXTRA_COMPILERS  += nasm

NASM_SOURCES += kernel.asm

nasm.name = nasm ${QMAKE_FILE_IN}
nasm.input = NASM_SOURCES
nasm.variable_out = OBJECTS
nasm.commands = nasm -f win64 ${QMAKE_FILE_IN} -o ${QMAKE_FILE_OUT}
nasm.output = ${QMAKE_VAR_OBJECTS_DIR}${QMAKE_FILE_IN_BASE}$${first(QMAKE_EXT_OBJ)}
nasm.CONFIG += target_predeps

