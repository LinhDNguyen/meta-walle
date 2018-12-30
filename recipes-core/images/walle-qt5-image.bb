SUMMARY = "A basic Qt5 qwidgets dev image"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

require walle-console-image.bb

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
    u-boot-fw-utils \
    vim \
    freetype \
    dnsmasq \
    ${QT_DEV_TOOLS} \
"

DISTRO_FEATURES += "wifi wayland"

IMAGE_FEATURES += "splash hwcodecs"
inherit core-image distro_features_check

REQUIRED_DISTRO_FEATURES = "wayland"

export IMAGE_BASENAME = "walle-qt5-image"
