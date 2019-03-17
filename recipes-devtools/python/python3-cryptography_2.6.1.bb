DESCRIPTION = "cryptography is a package which provides cryptographic recipes and primitives to Python developers."
HOMEPAGE = "https://github.com/pyca/cryptography"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI[sha256sum] = "26c821cbeb683facb966045e2064303029d572a87ee69ca5a1bf54bf55f93ca6"

inherit pypi setuptools3

BBCLASSEXTEND = "native nativesdk"
