DESCRIPTION = "Default configuration for WallE network"
SECTION = "walle/apps"
LICENSE = "CLOSED"
PR = "r0"

SRC_URI = "file://80-wlan0-dhcp.network \
			"

S = "${WORKDIR}"

FILES_${PN} = " \
    ${sysconfdir}/systemd/network/*.network \
"

do_install() {
	# Wlan0 network
	install -d ${D}${sysconfdir}/systemd/network

	install -m 0644 ${S}/80-wlan0-dhcp.network ${D}${sysconfdir}/systemd/network/80-wlan0.network
}