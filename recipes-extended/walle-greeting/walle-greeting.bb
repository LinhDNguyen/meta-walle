SUMMARY = "WallE greeting speaking at bootup"
DESCRIPTION = "Script to say greeting after boot"
LICENSE = "CLOSED"
PR = "r0"

RDEPENDS_${PN} = "bash espeak"

SRC_URI =  " \
    file://walle-greeting.sh \
    file://walle-greeting.service \
"

do_compile () {
}

do_install () {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/*.sh ${D}/${bindir}

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/walle-greeting.service ${D}${systemd_unitdir}/system
}

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "walle-greeting.service"

inherit allarch systemd
