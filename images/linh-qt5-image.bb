SUMMARY = "A basic Qt5 qwidgets dev image"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

require console-image.bb

QT_DEV_TOOLS = " \
    qtbase-dev \
    qtbase-mkspecs \
    qtbase-plugins \
    qtbase-tools \
    qtserialport-dev \
    qtserialport-mkspecs \
"

QT_TOOLS = " \
    qtbase \
    qt5-env \
    qtserialport \
"

FONTS = " \
    fontconfig \
    fontconfig-utils \
    ttf-bitstream-vera \
"

TSLIB = " \
    tslib \
    tslib-conf \
    tslib-calibrate \
    tslib-tests \
"

IMAGE_INSTALL += " \
    ${FONTS} \
    ${QT_TOOLS} \
    qcolorcheck \
    ${TSLIB} \
    tspress \
    dhcp-client \
    e2fsprogs \
    fwup \
    u-boot-fw-utils \
    vim \
    wpa-supplicant \
    openssh \
    zeromq \
    freetype \
    python-scons \
    swig \
    dnsmasq \
    wiringpi \
    ppp \
    git \
    python-flask \
    python-flask-login \
    python-jinja2 \
    python-pyserial \
    python-pyzmq \
    rpi-gpio \
"

IMAGE_CLASSES += "fwup-rpi"

DISTRO_FEATURES += "wifi"

export IMAGE_BASENAME = "linh-qt5-image"
