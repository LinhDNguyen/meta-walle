SUMMARY = "Expand the rootfs to the full size of its partion"
DESCRIPTION = "Script to expand the rootfs to the full size of its partion, started as a systemd service which removes itself once finished"
LICENSE = "CLOSED"
PR = "r0"

DEPENDS = "e2fsprogs parted perl"
RDEPENDS_first-boot = "bash perl e2fsprogs-resize2fs"

SRC_URI =  " \
    file://firstboot.sh \
    file://firstboot.service \
"

do_compile () {
}

do_install () {
    install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/*.sh ${D}/${sbindir}

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/firstboot.service ${D}${systemd_unitdir}/system
}

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "firstboot.service"

inherit allarch systemd