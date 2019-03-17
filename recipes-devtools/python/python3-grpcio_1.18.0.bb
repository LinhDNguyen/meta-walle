DESCRIPTION = "Google gRPC"
HOMEPAGE = "http://www.grpc.io/"
SECTION = "devel/python"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "${PYTHON_PN}-protobuf"

FILESEXTRAPATHS_prepend := "${THISDIR}/python-grpcio:"
#SRC_URI_append_class-target = " file://0001-setup.py-Do-not-mix-C-and-C-compiler-options.patch "

RDEPENDS_${PN} = "${PYTHON_PN}-protobuf \
                  ${PYTHON_PN}-setuptools \
                  ${PYTHON_PN}-six \
"

inherit setuptools3 pypi

SRC_URI[sha256sum] = "abe825aa49e6239d5edf4e222c44170d2c7f6f4b1fd5286b4756a62d8067e112"

CLEANBROKEN = "1"

BBCLASSEXTEND = "native nativesdk"
