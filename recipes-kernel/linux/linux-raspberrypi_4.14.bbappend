KBUILD_DEFCONFIG = "bcm2709_defconfig"

KBUILD_DEFCONFIG_raspberrypi3 = "bcm2709_defconfig"
KBUILD_DEFCONFIG_walle-pi3-64 = "bcmrpi3_defconfig"
KBUILD_DEFCONFIG_walle-pi3 = "bcm2709_defconfig"

WALLE_KERNEL_DEVICETREE_OVERLAYS ?= " \
    overlays/dwc2.dtbo \
    overlays/hifiberry-amp.dtbo \
    overlays/hifiberry-dac.dtbo \
    overlays/hifiberry-dacplus.dtbo \
    overlays/hifiberry-digi.dtbo \
    overlays/i2c-rtc.dtbo \
    overlays/iqaudio-dac.dtbo \
    overlays/iqaudio-dacplus.dtbo \
    overlays/lirc-rpi.dtbo \
    overlays/pitft22.dtbo \
    overlays/pitft28-resistive.dtbo \
    overlays/pitft35-resistive.dtbo \
    overlays/pps-gpio.dtbo \
    overlays/rpi-ft5406.dtbo \
    overlays/rpi-poe.dtbo \
    overlays/w1-gpio.dtbo \
    overlays/w1-gpio-pullup.dtbo \
    overlays/pi3-disable-bt.dtbo \
    overlays/pi3-miniuart-bt.dtbo \
    overlays/vc4-kms-v3d.dtbo \
    overlays/at86rf233.dtbo \
    "

WALLE_KERNEL_DEVICETREE_walle-pi3-64 = " \
    broadcom/bcm2710-rpi-3-b.dtb \
    broadcom/bcm2710-rpi-cm3.dtb \
    broadcom/bcm2837-rpi-3-b.dtb \
    "

WALLE_KERNEL_DEVICETREE_walle-pi3 = " \
    bcm2710-rpi-3-b.dtb \
    bcm2710-rpi-cm3.dtb \
    bcm2837-rpi-3-b.dtb \
    "

KERNEL_DEVICETREE = " \
    ${WALLE_KERNEL_DEVICETREE} \
    ${WALLE_KERNEL_DEVICETREE_OVERLAYS} \
    "