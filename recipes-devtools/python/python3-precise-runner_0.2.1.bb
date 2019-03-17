SUMMARY = "A lightweight, simple-to-use, RNN wake word listener."
HOMEPAGE = "https://github.com/MycroftAI/mycroft-precise"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI[sha256sum] = "85d809cd443667686fea07e0a185ec3c4f03c47132eb59d6315333e651ebeb8f"

inherit pypi setuptools3

RDEPENDS_${PN} += " \
    ${PYTHON_PN}-pyaudio \
    ${PYTHON_PN}-astor \
    ${PYTHON_PN}-absl-py \
    ${PYTHON_PN}-attrs \
    ${PYTHON_PN}-bbopt \
    ${PYTHON_PN}-decorator \
    ${PYTHON_PN}-fitipy \
    ${PYTHON_PN}-future \
    ${PYTHON_PN}-gast \
    ${PYTHON_PN}-grpcio \
    ${PYTHON_PN}-h5py \
    ${PYTHON_PN}-grpcio \
    ${PYTHON_PN}-grpcio \
    ${PYTHON_PN}-grpcio \
    ${PYTHON_PN}-grpcio \
"

#h5py==2.9.0
#hyperopt==0.1.1
#Keras==2.2.4
#Keras-Applications==1.0.6
#Keras-Preprocessing==1.0.5
#Markdown==3.0.1
#-e git+https://github.com/mycroftai/mycroft-precise@530f76bffb1339fd8c5988e04f3cc34095ad8b53#egg=mycroft_precise
#networkx==1.11
#numpy==1.16.0
#pocketsphinx==0.1.15
#portalocker==1.3.0
#-e git+https://github.com/mycroftai/mycroft-precise@530f76bffb1339fd8c5988e04f3cc34095ad8b53#egg=precise_runner&subdirectory=runner
#prettyparse==0.1.4
#protobuf==3.6.1
#PyAudio==0.2.11
#pymongo==3.7.2
#PyYAML==4.2b4
#scikit-learn==0.20.2
#scikit-optimize==0.5.2
#scipy==1.2.0
#six==1.12.0
#sonopy==0.1.2
#speechpy-fast==2.4
#tensorboard==1.11.0
#tensorflow==1.11.0
#termcolor==1.1.0
#typing==3.6.6
#wavio==0.0.4
#Werkzeug==0.14.1
#'''