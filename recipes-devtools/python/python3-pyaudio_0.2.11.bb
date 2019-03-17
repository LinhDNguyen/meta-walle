SUMMARY = "Bindings for PortAudio v19, the cross-platform audio input/output stream library."
HOMEPAGE = "https://people.csail.mit.edu/hubert/pyaudio/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI[sha256sum] = "93bfde30e0b64e63a46f2fd77e85c41fd51182a4a3413d9edfaf9ffaa26efb74"

DEPENDS += " portaudio-v19"

PYPI_PACKAGE = "PyAudio"

inherit pypi setuptools3
