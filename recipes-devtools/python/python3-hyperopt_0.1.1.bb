DESCRIPTION = "Read and write HDF5 files from Python"
HOMEPAGE = "http://www.h5py.org/"
SECTION = "devel/python"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD;md5=3775480a712fc46a69647678acb234cb"

RDEPENDS_${PN} = " \
"

inherit setuptools3 pypi

SRC_URI[sha256sum] = "9d41ca62daf36d6b6515ab8765e4c8c4388ee18e2a665701fef2b41563821002"

BBCLASSEXTEND = "native nativesdk"
