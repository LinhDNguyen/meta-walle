SUMMARY = "WallE GUI program"
HOMEPAGE = "https://github.com/nvl1109/meta-walle"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "qtdeclarative"

PR = "r1"

SRC_URI = " \
	file://walle-gui.service \
	file://walle-gui.pro \
	file://resources.qrc \
	file://mainwidget.ui \
	file://mainwidget.h \
	file://mainwidget.cpp \
	file://main.cpp \
	file://images/walle-logo.jpg \
"

S = "${WORKDIR}"

require recipes-qt/qt5/qt5.inc

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/${PN} ${D}${bindir}

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/walle-gui.service ${D}${systemd_unitdir}/system
}

FILES_${PN} = "${bindir}"

RDEPENDS_${PN} = "qtdeclarative-qmlplugins"


NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "walle-gui.service"

inherit systemd