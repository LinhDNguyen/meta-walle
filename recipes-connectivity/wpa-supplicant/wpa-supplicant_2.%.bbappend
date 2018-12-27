FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_install_append () {
	install -d ${D}${sysconfdir}/wpa_supplicant
	install -m 600 ${WORKDIR}/wpa_supplicant.conf-sane ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-wlan0.conf
	rm -f ${D}/${systemd_unitdir}/system/wpa_supplicant.service
	rm -f ${D}/${systemd_unitdir}/system/wpa_supplicant-nl80211@.service
	rm -f ${D}/${systemd_unitdir}/system/wpa_supplicant-wired@.service
}

SYSTEMD_SERVICE_${PN} = "wpa_supplicant@wlan0.service"
SYSTEMD_AUTO_ENABLE = "enable"
FILES_${PN} += "${systemd_system_unitdir}/wpa_supplicant@.service"