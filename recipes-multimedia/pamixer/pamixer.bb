SUMMARY = "PA mixer"
DESCRIPTION = ""
HOMEPAGE = "https://github.com/cdemoulins/pamixer"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

do_configure[depends] += "pulseaudio:do_populate_sysroot boost:do_populate_sysroot"
DEPENDS_${PN} = "pulseaudio-dev boost"
RDEPENDS_${PN} = "boost pulseaudio"

SRC_URI = " \
    git://github.com/cdemoulins/pamixer.git;protocol=https; \
    "

PV = "1.3.1"
SRCREV = "e125cab8ac7a8126c340236d3d3a89e3cbf9a420"

S = "${WORKDIR}/git"

do_install_append() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/pamixer ${D}${bindir}
}
