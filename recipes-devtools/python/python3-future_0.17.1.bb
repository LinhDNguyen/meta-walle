SUMMARY = "Compatibility layer between Python 2 and Python 3"
HOMEPAGE = "https://python-future.org/"
LICENSE = "MIT"
SRCNAME = "future"

LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=3c00b89de8dabf26a9b70748ccf4c477"

inherit pypi setuptools3

SRC_URI[sha256sum] = "67045236dcfd6816dc439556d009594abf643e5eb48992e36beac09c2ca659b8"

RDEPENDS_${PN} = "\
"
