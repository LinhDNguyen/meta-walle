do_install_append() {
	echo "Linh: move systemd service to ${systemd_unitdir}"
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${D}${systemd_user_unitdir}/pulseaudio.socket ${D}${systemd_unitdir}/system/
	install -m 0644 ${D}${systemd_user_unitdir}/pulseaudio.service ${D}${systemd_unitdir}/system/

	sed -i "s|ExecStart=/usr/bin/pulseaudio --daemonize=no|ExecStart=/usr/bin/pulseaudio --daemonize=no --system|g"            ${D}${systemd_unitdir}/system/pulseaudio.service

	echo "Linh: update /etc/pulse/default.pa to remove noise at start of pulseaudio"
	if [ -e "${D}${sysconfdir}/pulse/default.pa" ]; then
		CONF_FILE=${D}${sysconfdir}/pulse/default.pa
		echo "File default.pa existed, add config";
		echo "load-module module-alsa-sink device=hw:1,0 sink_name=alsa_out tsched=0" >> ${CONF_FILE}
		echo "load-module module-ladspa-sink sink_name=ladspa_out master=alsa_out plugin=mbeq_1197 label=mbeq control=-15,-15,-10,-1,-5,-1,-1,0,0,0,0,0,0,0,0" >> ${CONF_FILE}
		echo "load-module module-hal-detect tsched=0" >> ${CONF_FILE}
	fi
	sed -i "s|load-module module-suspend-on-idle|#load-module module-suspend-on-idle|g"            ${D}${sysconfdir}/pulse/default.pa
	sed -i "s|load-module module-suspend-on-idle|#load-module module-suspend-on-idle|g"            ${D}${sysconfdir}/pulse/system.pa
}

FILES_${PN}-server += " ${systemd_unitdir}/*"

NATIVE_SYSTEMD_SUPPORT = "1"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "pulseaudio.service"