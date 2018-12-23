inherit image_types

#
# Create an image that can be written onto a SD card using dd.
#
# The disk layout used is:
#
#    0                      -> IMAGE_ROOTFS_ALIGNMENT         - reserved for other data
#    IMAGE_ROOTFS_ALIGNMENT -> BOOT_SPACE                     - bootloader and kernel
#    BOOT_SPACE             -> FWUP_SIZE                     - rootfs
#

#                                                     Default Free space = 1.3x
#                                                     Use IMAGE_OVERHEAD_FACTOR to add more space
#                                                     <--------->
#            4MiB              40MiB           FWUP_ROOTFS
# <-----------------------> <----------> <---------------------->
#  ------------------------ ------------ ------------------------
# | IMAGE_ROOTFS_ALIGNMENT | BOOT_SPACE | ROOTFS_SIZE            |
#  ------------------------ ------------ ------------------------
# ^                        ^            ^                        ^
# |                        |            |                        |
# 0                      4MiB     4MiB + 40MiB       4MiB + 40Mib + FWUP_ROOTFS

# This image depends on the rootfs image
IMAGE_TYPEDEP_rpi-fwup0 = "${FWUP_ROOTFS_TYPE}"

# Set kernel and boot loader
IMAGE_BOOTLOADER ?= "bcm2835-bootfiles"

# Set initramfs extension
KERNEL_INITRAMFS ?= ""

# Kernel image name
FWUP_KERNELIMAGE_raspberrypi  ?= "kernel.img"
FWUP_KERNELIMAGE_raspberrypi2 ?= "kernel7.img"
FWUP_KERNELIMAGE_raspberrypi3-64 ?= "kernel8.img"

# Boot partition volume id
BOOTDD_VOLUME_ID ?= "${MACHINE}"

# Boot partition size [in KiB] (will be rounded up to IMAGE_ROOTFS_ALIGNMENT)
BOOT_SPACE ?= "40960"

# Set alignment to 4MB [in KiB]
IMAGE_ROOTFS_ALIGNMENT = "4096"

# Use an uncompressed ext3 by default as rootfs
FWUP_ROOTFS_TYPE ?= "ext3"
FWUP_ROOTFS = "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.${FWUP_ROOTFS_TYPE}"

do_image_rpi_fwup[depends] = " \
			parted-native:do_populate_sysroot \
			mtools-native:do_populate_sysroot \
			dosfstools-native:do_populate_sysroot \
			virtual/kernel:do_deploy \
			${IMAGE_BOOTLOADER}:do_deploy \
			${@bb.utils.contains('RPI_USE_U_BOOT', '1', 'u-boot:do_deploy', '',d)} \
			"

do_image_rpi_fwup[recrdeps] = "do_build"

# SD card image name
FWUP = "${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.rpi-fwup0"

# Compression method to apply to FWUP after it has been created. Supported
# compression formats are "gzip", "bzip2" or "xz". The original .rpi-fwup0 file
# is kept and a new compressed file is created if one of these compression
# formats is chosen. If FWUP_COMPRESSION is set to any other value it is
# silently ignored.
#FWUP_COMPRESSION ?= ""

# Additional files and/or directories to be copied into the vfat partition from the IMAGE_ROOTFS.
FATPAYLOAD ?= ""

# SD card vfat partition image name
FWUP_VFAT = "${IMAGE_NAME}.vfat"
FWUP_LINK_VFAT = "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.vfat"

def split_overlays(d, out, ver=None):
    dts = d.getVar("KERNEL_DEVICETREE")
    if out:
        overlays = oe.utils.str_filter_out('\S+\-overlay\.dtb$', dts, d)
        overlays = oe.utils.str_filter_out('\S+\.dtbo$', overlays, d)
    else:
        overlays = oe.utils.str_filter('\S+\-overlay\.dtb$', dts, d) + \
                   " " + oe.utils.str_filter('\S+\.dtbo$', dts, d)

    return overlays

IMAGE_CMD_rpi-fwup0 () {

	# Align partitions
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
	FWUP_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + $ROOTFS_SIZE)

	echo "Creating filesystem with Boot partition ${BOOT_SPACE_ALIGNED} KiB and RootFS $ROOTFS_SIZE KiB"

	# Check if we are building with device tree support
	DTS="${KERNEL_DEVICETREE}"

	# Initialize sdcard image file
	dd if=/dev/zero of=${FWUP} bs=1024 count=0 seek=${FWUP_SIZE}

	# Create partition table
	parted -s ${FWUP} mklabel msdos
	# Create boot partition and mark it as bootable
	parted -s ${FWUP} unit KiB mkpart primary fat32 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT})
	parted -s ${FWUP} set 1 boot on
	# Create rootfs partition to the end of disk
	parted -s ${FWUP} -- unit KiB mkpart primary ext2 $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT}) -1s
	parted ${FWUP} print

	# Create a vfat image with boot files
	BOOT_BLOCKS=$(LC_ALL=C parted -s ${FWUP} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 512 /2 }')
	rm -f ${WORKDIR}/boot.img
	mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/bcm2835-bootfiles/* ::/
	if test -n "${DTS}"; then
		# Device Tree Overlays are assumed to be suffixed by '-overlay.dtb' (4.1.x) or by '.dtbo' (4.4.9+) string and will be put in a dedicated folder
		DT_OVERLAYS="${@split_overlays(d, 0)}"
		DT_ROOT="${@split_overlays(d, 1)}"

		# Copy board device trees to root folder
		for DTB in $DT_ROOT; do
			DTB_BASE_NAME=`basename ${DTB} .dtb`

			mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${DTB_BASE_NAME}.dtb ::${DTB_BASE_NAME}.dtb
		done

		# Copy device tree overlays to dedicated folder
		mmd -i ${WORKDIR}/boot.img overlays
		for DTB in $DT_OVERLAYS; do
				DTB_EXT=${DTB##*.}
				DTB_BASE_NAME=`basename ${DTB} ."${DTB_EXT}"`

			mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${DTB_BASE_NAME}.${DTB_EXT} ::overlays/${DTB_BASE_NAME}.${DTB_EXT}
		done
	fi
		if [ "${RPI_USE_U_BOOT}" = "1" ]; then
		mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/u-boot.bin ::${FWUP_KERNELIMAGE}
		mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin ::${KERNEL_IMAGETYPE}
		mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/boot.scr ::boot.scr
	else
		mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}${KERNEL_INITRAMFS}-${MACHINE}.bin ::${FWUP_KERNELIMAGE}
	fi

	if [ -n ${FATPAYLOAD} ] ; then
		echo "Copying payload into VFAT"
		for entry in ${FATPAYLOAD} ; do
				# add the || true to stop aborting on vfat issues like not supporting .~lock files
				mcopy -i ${WORKDIR}/boot.img -s -v ${IMAGE_ROOTFS}$entry :: || true
		done
	fi

	# Add stamp file
	echo "${IMAGE_NAME}" > ${WORKDIR}/image-version-info
	mcopy -i ${WORKDIR}/boot.img -v ${WORKDIR}/image-version-info ::

	# Deploy vfat partition (for u-boot case only)
	if [ "${RPI_USE_U_BOOT}" = "1" ]; then
		cp ${WORKDIR}/boot.img ${IMGDEPLOYDIR}/${FWUP_VFAT}
		ln -sf ${FWUP_VFAT} ${FWUP_LINK_VFAT}
	fi

	# Burn Partitions
	dd if=${WORKDIR}/boot.img of=${FWUP} conv=notrunc seek=1 bs=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)
	# If FWUP_ROOTFS_TYPE is a .xz file use xzcat
	if echo "${FWUP_ROOTFS_TYPE}" | egrep -q "*\.xz"
	then
		xzcat ${FWUP_ROOTFS} | dd of=${FWUP} conv=notrunc seek=1 bs=$(expr 1024 \* ${BOOT_SPACE_ALIGNED} + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)
	else
		dd if=${FWUP_ROOTFS} of=${FWUP} conv=notrunc seek=1 bs=$(expr 1024 \* ${BOOT_SPACE_ALIGNED} + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)
	fi

	# Optionally apply compression
	case "${FWUP_COMPRESSION}" in
	"gzip")
		gzip -k9 "${FWUP}"
		;;
	"bzip2")
		bzip2 -k9 "${FWUP}"
		;;
	"xz")
		xz -k "${FWUP}"
		;;
	esac
}

ROOTFS_POSTPROCESS_COMMAND += " rpi_generate_sysctl_config ; "

rpi_generate_sysctl_config() {
	# systemd sysctl config
	test -d ${IMAGE_ROOTFS}${sysconfdir}/sysctl.d && \
		echo "vm.min_free_kbytes = 8192" > ${IMAGE_ROOTFS}${sysconfdir}/sysctl.d/rpi-vm.conf

	# sysv sysctl config
	IMAGE_SYSCTL_CONF="${IMAGE_ROOTFS}${sysconfdir}/sysctl.conf"
	test -e ${IMAGE_ROOTFS}${sysconfdir}/sysctl.conf && \
		sed -e "/vm.min_free_kbytes/d" -i ${IMAGE_SYSCTL_CONF}
	echo "" >> ${IMAGE_SYSCTL_CONF} && echo "vm.min_free_kbytes = 8192" >> ${IMAGE_SYSCTL_CONF}
}
