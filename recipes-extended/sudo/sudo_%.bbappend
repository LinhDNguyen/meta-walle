do_install_append() {
	# Update sudo group rule
	chmod 0666 ${D}${sysconfdir}/sudoers
	sed -i "s|# %wheel ALL=(ALL) NOPASSWD: ALL|%wheel ALL=(ALL) NOPASSWD: ALL|g"          ${D}${sysconfdir}/sudoers
	sed -i "s|# %sudo	ALL=(ALL) ALL|%sudo	ALL=(ALL) ALL|g"          ${D}${sysconfdir}/sudoers
	chmod 0440 ${D}${sysconfdir}/sudoers
}
