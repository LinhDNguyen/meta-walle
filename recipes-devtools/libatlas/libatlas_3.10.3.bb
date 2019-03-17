SUMMARY = "Library of functions for 2D graphics"
SECTION = "x11/gnome"
LICENSE = "CLOSE"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r2"

# can't use gnome.oeclass due to _ in filename
#SRC_URI = "https://sourceforge.net/projects/math-atlas/files/Stable/${PV}/atlas${PV}.tar.bz2/download "

SRC_URI = "${SOURCEFORGE_MIRROR}/math-atlas/atlas${PV}.tar.bz2 \
"

SRC_URI[md5sum] = "d6ce4f16c2ad301837cfb3dade2f7cef"

inherit autotools pkgconfig

DEPENDS = ""

FILES_${PN} = "${libdir}/*.so.*"

S = "${WORKDIR}/ATLAS"

EXTRA_OECONF = " -D c -DATL_ARM_HARDFP=1 -Si archdef 0 -Fa alg -mfloat-abi=hard"
