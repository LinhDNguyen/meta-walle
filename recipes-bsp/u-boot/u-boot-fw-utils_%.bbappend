FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " file://fw_env.config "

do_install_append() {
	install -m 0644 ${S}/../fw_env.config ${D}${sysconfdir}/fw_env.config
}