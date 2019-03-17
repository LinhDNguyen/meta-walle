SUMMARY = "Python AST that abstracts the underlying Python version"
HOMEPAGE = "https://github.com/serge-sans-paille/gast/"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD;md5=3775480a712fc46a69647678acb234cb"

inherit pypi setuptools3

SRC_URI[sha256sum] = "fe939df4583692f0512161ec1c880e0a10e71e6a232da045ab8edd3756fbadf0"

RDEPENDS_${PN} = "\
"
