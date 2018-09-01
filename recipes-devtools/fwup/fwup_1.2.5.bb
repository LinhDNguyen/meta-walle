SUMMARY = "Configurable embedded Linux firmware update creator and runner"
DESCRIPTION = ""
HOMEPAGE = "https://github.com/fhunleth/fwup"
SECTION = "devel"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"
DEPENDS = "libconfuse libarchive libsodium zlib pkgconfig-native"

SRCREV = "ed404bb112eb6618ca156eafcb57ea120ec71779"
SRC_URI = " \
    git://github.com/nvl1109/fwup.git;branch=master \
    "

RDEPENDS_fwup = "bash"

inherit autotools lib_package pkgconfig
FILES_${PN} += "${datadir}/bash-completion/completions/fwup \
               ${bindir}/fwup \
"
PACKAGES = "${PN}-dev ${PN}-dbg ${PN}"
BBCLASSEXTEND =+ "native nativesdk"

S = "${WORKDIR}/git"

do_install_append() {
    install -d ${D}${bindir}
    install ${WORKDIR}/build/src/fwup ${D}${bindir}
}