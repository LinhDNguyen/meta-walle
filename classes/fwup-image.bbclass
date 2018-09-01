S = "${WORKDIR}/${PN}"

IMGDEPLOYDIR = "${WORKDIR}/deploy-${PN}-fwup"

do_fwupimage[dirs] = "${TOPDIR}"
do_fwupimage[cleandirs] += "${S} ${IMGDEPLOYDIR}"
do_fwupimage[umask] = "022"
SSTATETASKS += "do_fwupimage"
SSTATE_SKIP_CREATION_task-fwupimage = '1'
do_fwupimage[sstate-inputdirs] = "${IMGDEPLOYDIR}"
do_fwupimage[sstate-outputdirs] = "${DEPLOY_DIR_IMAGE}"
do_fwupimage[stamp-extra-info] = "${MACHINE}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
deltask do_populate_sysroot
do_package[noexec] = "1"
deltask do_package_qa
do_packagedata[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"

def find_all(name, path):
    result = []
    for root, dirs, files in os.walk(path):
        if name in files:
            result.append(os.path.join(root, name))
    return result

python do_fwupimage () {
    import shutil
    import os

    # Find the fwup.conf
    s = d.getVar('WORKDIR', True)
    configPath = os.path.abspath(os.path.join(s, "fwup.conf"))
    revertConfigPath = os.path.abspath(os.path.join(s, "fwup-revert.conf"))
    print("config: %s" % configPath)
    if not os.path.exists(configPath):
        print("config file not exist")

    ret = os.system("which fwup")
    out = os.popen('which fwup').read()
    print("ret: %d, out: %s" % (ret, out))

    imageDir = d.getVar('DEPLOY_DIR_IMAGE', True)
    print("Image dir: %s" % (imageDir))

    machine = d.getVar('MACHINE', True)
    image = (d.getVar('FWUP_RPI_IMAGE', True) or "")

    rootfsFile = os.path.join(imageDir, '%s-%s.ext3' % (image, machine))

    topDir = d.getVar('TOPDIR', True)
    print("TOPDIR: %s" % topDir)
    bootFilesDir = os.path.join(topDir, 'tmp', 'work', '%s-poky-linux-gnueabi' % machine.replace('-', '_'), 'bcm2835-bootfiles')
    files = find_all('bootcode.bin', bootFilesDir)
    print("%s bootcode.bin: %s" % (bootFilesDir, str(files)))
    bootcodeBinFile = files[0]
    for f in files:
        if 'deploy-bcm2835-bootfiles' in f:
            bootcodeBinFile = f
            break;
    print("bootcode.bin: %s" % bootcodeBinFile)
    bootfilesDir = os.path.dirname(bootcodeBinFile)

    buildMachineDir = os.path.join(topDir, 'tmp', 'work', '%s-poky-linux-gnueabi' % machine.replace('-', '_'))
    files = find_all('config.txt', buildMachineDir)
    configTxtFile = ''
    for f in files:
        if 'bcm2835-bootfiles' in f:
            configTxtFile = f
            break
    cmdlineTxtFile = ''
    files = find_all('cmdline.txt', buildMachineDir)
    for f in files:
        if 'bcm2835-bootfiles' in f:
            cmdlineTxtFile = f
            break

    # Update the fwup.conf
    for f in (configPath, revertConfigPath):
        config = ''
        with open(f, "r") as fp:
            config=fp.read()

            config = config.replace('___IMAGE_DIR___', imageDir)

            # rootfs ext3
            config = config.replace('___ROOTFS_DIR___', rootfsFile)

            # bootcode.bin
            config = config.replace('___BOOTCODE_BIN___', bootcodeBinFile)

            # fixup.dat
            config = config.replace('___FIXUP_DAT___', os.path.join(bootfilesDir, 'fixup.dat'))

            # start.elf
            config = config.replace('___START_ELF___', os.path.join(bootfilesDir, 'start.elf'))

            # config.txt
            config = config.replace('___CONFIG_TXT___', configTxtFile)

            # cmdline.txt
            config = config.replace('___CMDLINE_TXT___', cmdlineTxtFile)

        # Write back
        with open(f, "w") as fp:
            fp.write(config)

    # Now create firmware
    outputName = "%s-%s.fw" % (image, machine)
    outputPath = os.path.join(imageDir, outputName)
    ret = os.system("fwup -c -f %s -o %s" % (configPath, outputPath))
    print("create firmware result: %d" % (ret))

    # Create revert firmware
    outputName = "%s-%s_revert.fw" % (image, machine)
    outputPath = os.path.join(imageDir, outputName)
    ret = os.system("fwup -c -f %s -o %s" % (revertConfigPath, outputPath))
    print("create revert firmware result: %d" % (ret))
}

COMPRESSIONTYPES = ""
PACKAGE_ARCH = "${MACHINE_ARCH}"

INHIBIT_DEFAULT_DEPS = "1"
EXCLUDE_FROM_WORLD = "1"

addtask do_fwupimage after do_unpack after do_prepare_recipe_sysroot before do_build
