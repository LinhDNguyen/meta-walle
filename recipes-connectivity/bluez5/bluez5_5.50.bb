require recipes-connectivity/bluez5/bluez5.inc

REQUIRED_DISTRO_FEATURES = "bluez5"

SRC_URI[md5sum] = "8e35c67c81a55d3ad4c9f22280dae178"
SRC_URI[sha256sum] = "5ffcaae18bbb6155f1591be8c24898dc12f062075a40b538b745bfd477481911"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += " \
    file://local_node.json \
    file://prov_db.json \
    file://hciattach.service \
    "

DEPENDS += " ell"
RDEPENDS_${PN} += " ell"

PACKAGECONFIG[btpclient] = "--enable-btpclient,--disable-btpclient, ell"

PACKAGECONFIG = "obex-profiles \
    readline \
    ${@bb.utils.filter('DISTRO_FEATURES', 'systemd', d)} \
    a2dp-profiles \
    avrcp-profiles \
    network-profiles \
    hid-profiles \
    hog-profiles \
    tools \
    deprecated \
    mesh \
    systemd \
    readline \
"

EXTRA_OECONF += "\
    "

# noinst programs in Makefile.tools that are conditional on READLINE
# support
NOINST_TOOLS_READLINE ?= " \
    ${@bb.utils.contains('PACKAGECONFIG', 'deprecated', 'attrib/gatttool', '', d)} \
    tools/obex-client-tool \
    tools/obex-server-tool \
    tools/bluetooth-player \
    tools/obexctl \
    tools/btmgmt \
"

# noinst programs in Makefile.tools that are conditional on TESTING
# support
NOINST_TOOLS_TESTING ?= " \
    emulator/btvirt \
    emulator/b1ee \
    emulator/hfp \
    peripheral/btsensor \
    tools/3dsp \
    tools/mgmt-tester \
    tools/gap-tester \
    tools/l2cap-tester \
    tools/sco-tester \
    tools/smp-tester \
    tools/hci-tester \
    tools/rfcomm-tester \
    tools/bnep-tester \
    tools/userchan-tester \
"

# noinst programs in Makefile.tools that are conditional on TOOLS
# support
NOINST_TOOLS_BT ?= " \
    tools/bdaddr \
    tools/avinfo \
    tools/avtest \
    tools/scotest \
    tools/amptest \
    tools/hwdb \
    tools/hcieventmask \
    tools/hcisecfilter \
    tools/btinfo \
    tools/btsnoop \
    tools/btproxy \
    tools/btiotest \
    tools/bneptest \
    tools/mcaptest \
    tools/cltest \
    tools/oobtest \
    tools/advtest \
    tools/seq2bseq \
    tools/nokfw \
    tools/create-image \
    tools/eddystone \
    tools/ibeacon \
    tools/btgatt-client \
    tools/btgatt-server \
    tools/test-runner \
    tools/check-selftest \
    tools/gatt-service \
    profiles/iap/iapd \
    ${@bb.utils.contains('PACKAGECONFIG', 'btpclient', 'tools/btpclient', '', d)} \
"

do_install_append() {
    echo "Mesh config file at: ${D}/usr/share/bluez5"
    install -d ${D}/usr/share/bluez5
    install -m 0644 ${WORKDIR}/prov_db.json ${D}/usr/share/bluez5
    install -m 0644 ${WORKDIR}/local_node.json ${D}/usr/share/bluez5

    echo "hciattach.service install"
    install -d ${D}${systemd_unitdir}
    install -m 0664 ${WORKDIR}/hciattach.service ${D}${systemd_unitdir}/system/hciattach.service
}

SYSTEMD_SERVICE_${PN} += " hciattach.service"