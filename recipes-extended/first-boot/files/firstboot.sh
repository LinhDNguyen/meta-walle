#!/bin/bash
# resize the rootfs ext filesystem size to its full partition size
# usually used on first boot in a postinstall script
# or set in an autostart file from a postinstall script
LOG=/home/root/resize.log
echo `date` > ${LOG}

# Size in sector number, each sector has 512bytes
# BOOT has size 128MB
EXPECTED_BOOTFS_SIZE=262144
# ROOTFS has size 2GB
EXPECTED_ROOTFS_SIZE=4194304
# CONFIG has size 512MB
EXPECTED_CONFIGFS_SIZE=1048576
# DATA is scalable size
EXPECTED_DATAFS_SIZE=0
DEFAULT_DATAFS_SIZE=1048576

PART=`cat /proc/cmdline | perl -lne 'print $1 if /root=\/dev\/(mmcblk\dp\d+)/'`
DISK=`echo $PART | perl -lne 'print $1 if /(mmcblk\d)p\d+/'`
logger "Boot on disk ${DISK} and rootfs is ${PART}"
echo "Boot on disk ${DISK} and rootfs is ${PART}" >> ${LOG}

ROOTFS_PART=${DISK}p2
DATA_PART=${DISK}p3

### Resize rootfs
logger "resizing ROOTFS ${ROOTFS_PART} to fill its full partition size"
echo "resizing ROOTFS ${ROOTFS_PART} to fill its full partition size" >> ${LOG}
resize2fs /dev/${ROOTFS_PART}

### Check if DATA & CONFIG is already configured or not
IS_CONFIGURED=1
IS_DATA_OK=1
IS_REBOOT_REQUIRED=0
tmp=`blkid /dev/${DATA_PART}`
if [ "$tmp" == "" ]; then
	# Empty, means not configured
	IS_CONFIGURED=0
	IS_DATA_OK=0
	logger "Data $DATA_PART is not configured"
	echo "Data $DATA_PART is not configured" >> ${LOG}
fi
tmp=`cat /sys/block/${DISK}/${DATA_PART}/size`
if [[ $tmp -eq $DEFAULT_DATAFS_SIZE ]]; then
	IS_CONFIGURED=0
	IS_DATA_OK=0
	logger "Data size ${tmp} $CONFIG_PART is not configured"
	echo "Data size ${tmp} $CONFIG_PART is not configured" >> ${LOG}
fi

if [[ $IS_CONFIGURED -eq 0 ]]; then
	### Change partition to grow DATA partition fitting storage memory
	DATA_PART_START=`cat /sys/block/${DISK}/${DATA_PART}/start`
	logger "DATA_PART_START ${DATA_PART_START}"
	echo "DATA_PART_START ${DATA_PART_START}" >> ${LOG}
	if [[ $IS_DATA_OK -eq 0 ]]; then
		fdisk /dev/${DISK} <<EOF
d
3
n
p
3
${DATA_PART_START}

p
w
EOF
	fi

	### Probe new parition table
	partprobe;
	sleep 1;

	### Format CONFIG & DATA
	logger "Format data partition (${DATA_PART}) as ext4"
	echo "Format data partition (${DATA_PART}) as ext4" >> ${LOG}
	if [[ $IS_DATA_OK -eq 0 ]]; then
		tmp=`blkid /dev/${DATA_PART}`
		if [ "$tmp" == "" ]; then
			mkfs.ext4 -F /dev/${DATA_PART}
			echo "Format data ${DATA_PART}" >> ${LOG}
			IS_REBOOT_REQUIRED=1
		else
			echo "Just resize data ${DATA_PART}" >> ${LOG}
			resize2fs /dev/${DATA_PART}
		fi
	fi
fi

### Add them into fstab
mkdir /data
tmp=`grep "/data" /etc/fstab`
if [ "$tmp" = "" ]; then
	echo "/dev/${DATA_PART} /data auto defaults,sync,auto 0 0" >> /etc/fstab
fi
mount -a

### TODO: workaround. the wpa_supplicant@wlan0 service isn't installed correctly.
rm -f /etc/systemd/system/multi-user.target.wants/wpa_supplicant*.service
systemctl enable wpa_supplicant@wlan0.service
systemctl start wpa_supplicant@wlan0.service
echo "Workaround for wpa_supplicant@wlan0.service done" >> ${LOG}

### TODO: workaround. enable bluetooth service
ln -s /lib/firmware /etc/firmware
systemctl enable hciattach
systemctl enable bluetooth
systemctl start hciattach
systemctl start bluetooth
echo "Workaround for bluetooth service done" >> ${LOG}

#job done, remove it from systemd services
systemctl disable firstboot.service

logger "firstboot service finished"
echo "firstboot service finished" >> ${LOG}

if [[ $IS_REBOOT_REQUIRED -eq 1 ]]; then
	logger "Now restart..."
	echo "Now restart..." `date` >> ${LOG}
	reboot
fi
exit 0