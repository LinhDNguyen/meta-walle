SUMMARY = "Example of how to build an external Linux kernel module"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "wiringpi"

PR = "r0"
PV = "1.0"

SRCREV = "f0c047f4b22683f604dde788a438e4cab5549641"
SRC_URI = " \
    git://github.com/nvl1109/RaspberryPi_KeDei_35_lcd_v63.git;branch=master \
    "

S = "${WORKDIR}/git"

FILES_${PN} += "${datadir}/kedei_nice.bmp"

do_compile() {
         ${CC} -o kedei_lcd_v63_pi_wiringpi kedei_lcd_v63_pi_wiringpi.c -lwiringPi ${LDFLAGS}
}

do_install() {
         install -d ${D}${bindir}
         install -m 0755 kedei_lcd_v63_pi_wiringpi ${D}${bindir}
         install -d ${D}${datadir}
         install -m 0664 nice.bmp ${D}${datadir}/kedei_nice.bmp
}