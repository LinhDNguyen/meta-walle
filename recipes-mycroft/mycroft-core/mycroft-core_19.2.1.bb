SUMMARY = "MyCroft.ai core install"
DESCRIPTION = ""
HOMEPAGE = "https://github.com/MycroftAI/mycroft-core"
SECTION = "devel"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=79aa497b11564d1d419ee889e7b498f6"

DEPENDS += " mimic"

RDEPENDS_${PN} += "\
    ${PYTHON_PN}-pygobject \
    libtool \
    libffi \
    bison \
    swig \
    glib-2.0 \
    portaudio-v19 \
    mpg123 \
    screen \
    flac \
    curl \
    jq \
    mimic \
    ${PYTHON_PN}-pep8 \
    ${PYTHON_PN}-petact \
    ${PYTHON_PN}-precise-runner \
"

SRC_URI = " \
    git://github.com/MycroftAI/mycroft-core.git;protocol=https; \
    "

SRCREV = "8228b49230b6a9b4e1a4e18e5e25281f533f0aaf"

S = "${WORKDIR}/git"

inherit setuptools3

BBCLASSEXTEND = "native nativesdk"

do_install_append() {
    install -d ${D}${bindir}
    install -d ${D}${sysconfdir}

    install -m 0755 ${S}/start-mycroft.sh ${D}${bindir}
    install -m 0755 ${S}/stop-mycroft.sh ${D}${bindir}
}