do_install_append() {
	echo "Linh: move systemd service to ${systemd_unitdir}"
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${D}${systemd_user_unitdir}/pulseaudio.socket ${D}${systemd_unitdir}/system/
	install -m 0644 ${D}${systemd_user_unitdir}/pulseaudio.service ${D}${systemd_unitdir}/system/

	sed -i "s|ExecStart=/usr/bin/pulseaudio --daemonize=no|ExecStart=/usr/bin/pulseaudio --daemonize=no --system|g"            ${D}${systemd_unitdir}/system/pulseaudio.service
}

FILES_${PN}-server += " ${systemd_unitdir}/*"

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "pulseaudio.service"