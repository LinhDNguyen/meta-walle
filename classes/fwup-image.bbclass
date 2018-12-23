inherit image_types

# Set kernel and boot loader
IMAGE_TYPEDEP_fwup = "ext4"

do_image_fwup[depends] = " \
    parted-native:do_populate_sysroot \
    mtools-native:do_populate_sysroot \
    dosfstools-native:do_populate_sysroot \
    fwup-native:do_populate_sysroot \
    virtual/kernel:do_deploy \
    ${IMAGE_BOOTLOADER}:do_deploy \
    fwup:do_deploy \
    ${IMAGE_BASENAME}:do_image_ext4 \
"

do_image_fwup[recrdeps] = "do_build"

IMAGE_CMD_fwup () {
    echo "OKDA_FW_PLATFORM: ${OKDA_FW_PLATFORM}"
    echo "OKDA_FW_VERSION: ${OKDA_FW_VERSION}"
    echo "OKDA_FW_BOOT_FROM: ${OKDA_FW_BOOT_FROM}"
    # Prepare fwup.conf file
    cp -f ${DEPLOY_DIR_IMAGE}/fwup.conf.orig ${IMGDEPLOYDIR}/fwup.conf
    sed -i -e 's/___FW_BOOT_BIN_NAME___/BOOT-svk_okda_stereo_xu1.bin/g' ${IMGDEPLOYDIR}/fwup.conf
    if [ "${OKDA_FW_BOOT_FROM}" = "emmc" ]; then
        sed -i -e 's/___FW_UBOOT_SCR_NAME___/uboot-emmc.scr/g' ${IMGDEPLOYDIR}/fwup.conf
        echo "Use boot script uboot-emmc.scr"
    else
        sed -i -e 's/___FW_UBOOT_SCR_NAME___/uboot-mmc.scr/g' ${IMGDEPLOYDIR}/fwup.conf
        echo "Use boot script uboot-mmc.scr"
    fi
    sed -i -e 's/___FW_DEVICE_TREE_NAME___/svk_okda_stereo_xu1-system.dtb/g' ${IMGDEPLOYDIR}/fwup.conf
    sed -i -e 's/___FW_ROOTFS_NAME___/stereo-camera-image-svk_okda_stereo_xu1.ext4/g' ${IMGDEPLOYDIR}/fwup.conf
    sed -i "s|___IMAGE_DIR___|${DEPLOY_DIR_IMAGE}|g" ${IMGDEPLOYDIR}/fwup.conf
    sed -i "s|___CUR_IMAGE_DIR___|${IMGDEPLOYDIR}|g" ${IMGDEPLOYDIR}/fwup.conf
    sed -i "s|___FW_VERSION___|${OKDA_FW_VERSION}|g" ${IMGDEPLOYDIR}/fwup.conf
    sed -i "s|___FW_PLATFORM___|${OKDA_FW_PLATFORM}|g" ${IMGDEPLOYDIR}/fwup.conf

    # Create dummy file
    dd if=/dev/zero of=${IMGDEPLOYDIR}/dummy.img iflag=fullblock bs=1M count=1

    # Create fwup image
    fwup -c -f ${IMGDEPLOYDIR}/fwup.conf -o ${IMGDEPLOYDIR}/${IMAGE_NAME}.fwup

    # Create link
    rm -f ${IMGDEPLOYDIR}/${IMAGE_BASENAME}-${MACHINE}.fwup
    ln -s ${IMAGE_NAME}.fwup ${IMGDEPLOYDIR}/${IMAGE_BASENAME}-${MACHINE}.fwup

    # Done
    rm -f ${IMGDEPLOYDIR}/dummy.img
}