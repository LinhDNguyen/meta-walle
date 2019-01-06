DESCRIPTION = "WallE screen utilities"
SECTION = "walle/apps"
LICENSE = "CLOSED"
PR = "r0"

RDEPENDS_${PN} = "bash"

SRC_URI = "file://screen-on.sh \
	file://screen-off.sh \
"

S = "${WORKDIR}"

FILES_${PN} = " \
    ${bindir}/* \
"

do_install() {
	echo "Install screen utils"
	install -d ${D}${bindir}

	install -m 0755 ${S}/screen-on.sh ${D}${bindir}/
	install -m 0755 ${S}/screen-off.sh ${D}${bindir}/
}