FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_deploy_append() {
	echo "Enable I2S DAC in config.txt"
	 # Hifi DAC
	echo "# Hifi I2S DAC"                        >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
	echo "dtoverlay=hifiberry-dac"               >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
	echo "dtoverlay=i2s-mmap"                    >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
	echo "dtparam=i2s=on"                        >> ${DEPLOYDIR}/bcm2835-bootfiles/config.txt
}
