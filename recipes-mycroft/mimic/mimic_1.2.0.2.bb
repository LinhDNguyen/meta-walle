SUMMARY = "Mimic - The Mycroft TTS Engine"
DESCRIPTION = ""
HOMEPAGE = "https://github.com/MycroftAI/mimic"
SECTION = "devel"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://COPYING;md5=416ef1ca5167707fe381d7be33664a33"

DEPENDS += " icu"
#RDEPENDS_fwup = "bash"

SRC_URI = " \
    git://github.com/MycroftAI/mimic.git;protocol=https; \
    "

SRCREV = "67e43bf0fa56008276b878ec3790aa5f32eb2a16"

S = "${WORKDIR}/git"

inherit autotools pkgconfig deploy
BBCLASSEXTEND = "native nativesdk"

do_deploy() {
  # just a test
  echo "Just a test"
}

addtask deploy after do_install