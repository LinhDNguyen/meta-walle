inherit image_types

WALLE_FW_PLATFORM ?= "walle"
WALLE_FW_VERSION ?= "0.0.1"
# Network type: dhcp/static/off
WALLE_FW_ETH0_TYPE ?= "dhcp"
WALLE_FW_ETH0_IP ?= "192.168.1.104"
WALLE_FW_ETH0_GW ?= "192.168.1.1"
WALLE_FW_ETH0_DNS ?= "192.168.1.2"

# Set kernel and boot loader
IMAGE_TYPEDEP_fwup-img = "ext4"

do_image_fwup_img[depends] = " \
    parted-native:do_populate_sysroot \
    mtools-native:do_populate_sysroot \
    dosfstools-native:do_populate_sysroot \
    fwup-native:do_populate_sysroot \
    virtual/kernel:do_deploy \
    ${IMAGE_BOOTLOADER}:do_deploy \
    fwup:do_deploy \
    ${IMAGE_BASENAME}:do_image_ext4 \
"

do_image_fwup_img[recrdeps] = "do_build"

IMAGE_CMD_fwup-img () {
    echo "WALLE_FW_PLATFORM: ${WALLE_FW_PLATFORM}"
    echo "WALLE_FW_VERSION: ${WALLE_FW_VERSION}"
    echo "WALLE_FW_BOOT_FROM: ${WALLE_FW_BOOT_FROM}"
    # Prepare fwup.conf file
    for f in fwup.conf fwup_revert.conf; do
        echo "process file: ${f}"
        cp -f ${DEPLOY_DIR_IMAGE}/${f}.orig ${IMGDEPLOYDIR}/${f}

        # replace var in file
        tmp="${IMAGE_BASENAME}-${MACHINE}.ext4"
        sed -i "s|___IMAGE_DIR___|${DEPLOY_DIR_IMAGE}|g"            ${IMGDEPLOYDIR}/${f}
        sed -i "s|___ROOTFS_DIR___|${tmp}|g"                        ${IMGDEPLOYDIR}/${f}
        BOOT_DIR="${DEPLOY_DIR_IMAGE}/bcm2835-bootfiles"
        sed -i "s|___BOOTCODE_BIN___|${BOOT_DIR}/bootcode.bin|g"    ${IMGDEPLOYDIR}/${f}
        sed -i "s|___FIXUP_DAT___|${BOOT_DIR}/fixup.dat|g"          ${IMGDEPLOYDIR}/${f}
        sed -i "s|___START_ELF___|${BOOT_DIR}/start.elf|g"          ${IMGDEPLOYDIR}/${f}
        sed -i "s|___CONFIG_TXT___|${BOOT_DIR}/config.txt|g"        ${IMGDEPLOYDIR}/${f}
        sed -i "s|___CMDLINE_TXT___|${BOOT_DIR}/cmdline.txt|g"      ${IMGDEPLOYDIR}/${f}
        sed -i "s|___DUMMY_IMG___|${IMGDEPLOYDIR}/dummy.img|g"      ${IMGDEPLOYDIR}/${f}
    done

    # Create dummy file
    dd if=/dev/zero of=${IMGDEPLOYDIR}/dummy.img iflag=fullblock bs=1M count=1

    # Create fwup image
    fwup -c -f ${IMGDEPLOYDIR}/fwup.conf -o ${IMGDEPLOYDIR}/${IMAGE_NAME}.fwup

    fwup -c -f ${IMGDEPLOYDIR}/fwup_revert.conf -o ${IMGDEPLOYDIR}/${IMAGE_NAME}_revert.fwup

    # Create link
    rm -f ${IMGDEPLOYDIR}/${IMAGE_BASENAME}-${MACHINE}.fwup
    rm -f ${IMGDEPLOYDIR}/${IMAGE_BASENAME}-${MACHINE}_revert.fwup
    ln -s ${IMAGE_NAME}.fwup ${IMGDEPLOYDIR}/${IMAGE_BASENAME}-${MACHINE}.fwup
    ln -s ${IMAGE_NAME}_revert.fwup ${IMGDEPLOYDIR}/${IMAGE_BASENAME}-${MACHINE}_revert.fwup

    # Done
    rm -f ${IMGDEPLOYDIR}/dummy.img
}

IMAGE_TYPES += " fwup-img"