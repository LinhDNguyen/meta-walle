FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_install_append () {
	install -d ${D}${sysconfdir}/wpa_supplicant
	install -m 600 ${WORKDIR}/wpa_supplicant.conf-sane ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant_wlan0.conf
}