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
    wiringpi \
    kedei-wiringpi \
"

IMAGE_CLASSES += "fwup-rpi"

do_rootfs_append() {
    print("~~~~LINH~~~~~~")
    print("~~TOPDIR: %s~~" % (d.getVar("TOPDIR")))
    import os
    print("~~CURDIR: %s~~" % (os.getcwd()))
    print("~~IMAGE_ROOTFS: %s~~" % (d.getVar("IMAGE_ROOTFS")))
    print("~~S: %s~~" % (d.getVar("S")))
}

do_image_complete_append() {
    print("~~~~Complete append~~~~~")
    print("~~TOPDIR: %s~~" % (d.getVar("TOPDIR")))
    import os
    print("~~CURDIR: %s~~" % (os.getcwd()))
    print("~~S: %s~~" % (d.getVar("S")))
    print("~~IMGDEPLOYDIR: %s~~" % (d.getVar("IMGDEPLOYDIR")))
    print("~~DEPLOY_DIR_IMAGE: %s~~" % (d.getVar("DEPLOY_DIR_IMAGE")))
}

export IMAGE_BASENAME = "linh-qt5-image"
