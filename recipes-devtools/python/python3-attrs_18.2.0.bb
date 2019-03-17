DESCRIPTION = "Classes Without Boilerplate"
HOMEPAGE = "http://www.attrs.org/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI[sha256sum] = "10cbf6e27dbce8c30807caf056c8eb50917e0eaafe86347671b57254006c3e69"

inherit pypi setuptools3

RDEPENDS_${PN} += " \
    ${PYTHON_PN}-cryptography \
"
