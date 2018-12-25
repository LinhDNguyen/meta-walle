SUMMARY = "Configurable embedded Linux firmware update creator and runner"
DESCRIPTION = ""
HOMEPAGE = "https://github.com/fhunleth/fwup"
SECTION = "devel"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"
DEPENDS = "libconfuse libarchive libsodium zlib pkgconfig-native"
RDEPENDS_fwup = "bash"

SRC_URI = " \
    git://github.com/fhunleth/fwup.git;protocol=https; \
    file://0001-Don-t-build-doc.patch \
    file://fwup.conf.orig \
    file://fwup_revert.conf.orig \
    "

PV = "1.2.7"
SRCREV = "3546a5880d938197f1e1d094fd3b709a115bdf71"

S = "${WORKDIR}/git"

CFLAGS_prepend = "-I${S} "

inherit autotools lib_package pkgconfig deploy
FILES_${PN} += "${datadir}/bash-completion/completions/fwup \
               ${bindir}/fwup \
"
PACKAGES = "${PN}-dev ${PN}-dbg ${PN}"
BBCLASSEXTEND = "native nativesdk"

do_configure_append () {
  ln -s ${S}/src/fwup.h2m ${WORKDIR}/build/src/fwup.h2m
}

do_install_append() {
    install -d ${D}${bindir}
    install ${WORKDIR}/build/src/fwup ${D}${bindir}
}

do_deploy() {
	echo "install -m 0644 ${WORKDIR}/fwup.conf.orig ${DEPLOYDIR}/"
	install -d ${DEPLOYDIR}
	install -m 0644 ${WORKDIR}/fwup.conf.orig ${DEPLOYDIR}/
  install -m 0644 ${WORKDIR}/fwup_revert.conf.orig ${DEPLOYDIR}/
}

addtask deploy after do_install