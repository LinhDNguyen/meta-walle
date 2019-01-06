DESCRIPTION = "Default configuration for WallE network"
SECTION = "walle/apps"
LICENSE = "CLOSED"
PR = "r0"

SRC_URI = "file://asound.conf \
			"

S = "${WORKDIR}"

FILES_${PN} = " \
    ${sysconfdir}/asound.conf \
"

do_install() {
	echo "Install asound.conf"
	# Install asound.conf file
	install -d ${D}${sysconfdir}

	install -m 0644 ${S}/asound.conf ${D}${sysconfdir}/asound.conf
}