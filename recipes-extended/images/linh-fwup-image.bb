DESCRIPTION = "Example image demonstrating how to build SWUpdate compound image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "fwup-native"

inherit fwup-image

SRC_URI = "\
    file://fwup.conf \
    file://fwup-revert.conf \
"

# images to build before building fwup-image image
IMAGE_DEPENDS = "linh-qt5-image"

# image is used for create fwup file
FWUP_RPI_IMAGE = "linh-qt5-image"

FWUP_IMAGES_FSTYPES[linh-qt5-image] = ".ext3"
