SUMMARY = "A basic Qt5 qwidgets dev image"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

require walle-console-image.bb

inherit populate_sdk_qt5

QT_DEV_TOOLS = " \
    qtbase-dev \
    qtbase-mkspecs \
    qtbase-plugins \
    qtbase-tools \
    qtserialport-dev \
    qtserialport-mkspecs \
"

QT_TOOLS = " \
    qtbase \
    qt5-env \
    qtserialport \
    qtdeclarative \
"
#qtquick1 qtmqtt qtmultimedia qtsystems  qqtest

FONTS = " \
    fontconfig \
    fontconfig-utils \
    ttf-bitstream-vera \
"

TSLIB = " \
    tslib \
    tslib-conf \
    tslib-calibrate \
    tslib-tests \
"

TOOLS = " \
    usbutils \
    vc-graphics \
    userland \
"

PULSE_SOUND = " \
    pulseaudio \
    pulseaudio-bash-completion \
    pulseaudio-lib-alsa-util \
    pulseaudio-lib-cli \
    pulseaudio-lib-oss-util \
    pulseaudio-lib-protocol-cli \
    pulseaudio-lib-protocol-esound \
    pulseaudio-lib-protocol-http \
    pulseaudio-lib-protocol-native \
    pulseaudio-lib-protocol-simple \
    pulseaudio-lib-rtp \
    pulseaudio-misc \
    pulseaudio-module-allow-passthrough \
    pulseaudio-module-alsa-card \
    pulseaudio-module-alsa-sink \
    pulseaudio-module-alsa-source \
    pulseaudio-module-always-sink \
    pulseaudio-module-augment-properties \
    pulseaudio-module-card-restore \
    pulseaudio-module-cli \
    pulseaudio-module-cli-protocol-tcp \
    pulseaudio-module-cli-protocol-unix \
    pulseaudio-module-combine \
    pulseaudio-module-combine-sink \
    pulseaudio-module-console-kit \
    pulseaudio-module-dbus-protocol \
    pulseaudio-module-default-device-restore \
    pulseaudio-module-detect \
    pulseaudio-module-device-manager \
    pulseaudio-module-device-restore \
    pulseaudio-module-echo-cancel \
    pulseaudio-module-esound-compat-spawnfd \
    pulseaudio-module-esound-compat-spawnpid \
    pulseaudio-module-esound-protocol-tcp \
    pulseaudio-module-esound-protocol-unix \
    pulseaudio-module-esound-sink \
    pulseaudio-module-filter-apply \
    pulseaudio-module-filter-heuristics \
    pulseaudio-module-gconf \
    pulseaudio-module-http-protocol-tcp \
    pulseaudio-module-http-protocol-unix \
    pulseaudio-module-intended-roles \
    pulseaudio-module-ladspa-sink \
    pulseaudio-module-loopback \
    pulseaudio-module-match \
    pulseaudio-module-mmkbd-evdev \
    pulseaudio-module-native-protocol-fd \
    pulseaudio-module-native-protocol-tcp \
    pulseaudio-module-native-protocol-unix \
    pulseaudio-module-null-sink \
    pulseaudio-module-null-source \
    pulseaudio-module-oss \
    pulseaudio-module-pipe-sink \
    pulseaudio-module-pipe-source \
    pulseaudio-module-position-event-sounds \
    pulseaudio-module-remap-sink \
    pulseaudio-module-remap-source \
    pulseaudio-module-rescue-streams \
    pulseaudio-module-role-cork \
    pulseaudio-module-role-ducking \
    pulseaudio-module-rtp-recv \
    pulseaudio-module-rtp-send \
    pulseaudio-module-rygel-media-server \
    pulseaudio-module-simple-protocol-tcp \
    pulseaudio-module-simple-protocol-unix \
    pulseaudio-module-sine \
    pulseaudio-module-sine-source \
    pulseaudio-module-stream-restore \
    pulseaudio-module-suspend-on-idle \
    pulseaudio-module-switch-on-connect \
    pulseaudio-module-switch-on-port-available \
    pulseaudio-module-systemd-login \
    pulseaudio-module-tunnel-sink \
    pulseaudio-module-tunnel-sink-new \
    pulseaudio-module-tunnel-source \
    pulseaudio-module-tunnel-source-new \
    pulseaudio-module-udev-detect \
    pulseaudio-module-virtual-sink \
    pulseaudio-module-virtual-source \
    pulseaudio-module-virtual-surround-sink \
    pulseaudio-module-volume-restore \
    pulseaudio-server \
"

MYCROFT_AI = " \
    libffi \
    portaudio-v19 \
    screen \
    curl \
    icu \
    jq \
    glib-2.0 \
    pamixer \
    ${PULSE_SOUND} \
    espeak \
    sox \
    mimic \
    mycroft-core \
"

VIET_BOT = " \
    libsdl-dev \
    pkgconfig \
    sudo \
    lsof \
    python3-cffi \
    gcc \
    g++ \
    binutils \
    libsdl-mixer \
    python3-numpy \
    libsdl-image \
    libsdl-ttf \
    python3-google-cloud-speech \
"

WALLE_TOOLS = " \
    walle-screen-utils \
    walle-greeting \
    walle-sound \
    walle-gui \
"

IMAGE_INSTALL += " \
    ${FONTS} \
    ${QT_TOOLS} \
    qcolorcheck \
    ${TSLIB} \
    tspress \
    u-boot-fw-utils \
    vim \
    freetype \
    dnsmasq \
    ${QT_DEV_TOOLS} \
    mpg123 \
    alsa-utils alsa-tools alsa-plugins alsa-lib alsa-oss \
    ${MYCROFT_AI} \
    ${WALLE_TOOLS} \
    ${VIET_BOT} \
"

DISTRO_FEATURES += "wifi wayland"

IMAGE_FEATURES += "splash hwcodecs"
inherit core-image distro_features_check

REQUIRED_DISTRO_FEATURES = "wayland"

export IMAGE_BASENAME = "walle-qt5-image"
