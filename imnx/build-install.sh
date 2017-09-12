#!/usr/bin/sudo /bin/bash
read -p "What is your ROOTFS block device: " rootBLKDEV
read -p "What is your ROOTFS block device: " bootBLKDEV
mkdir -p ${KERNEL_SRC_PATH}/imnx/mnt0/
mount ${rootBLKDEV} ${KERNEL_SRC_PATH}/imnx/mnt0/
mkdir -p ${KERNEL_SRC_PATH}/imnx/mnt0/boot/
mount ${bootBLKDEV} ${KERNEL_SRC_PATH}/imnx/mnt0/boot/

mkdir -p ${KERNEL_SRC_PATH}/imnx/mnt0/boot/overlays/
mkdir -p ${KERNEL_SRC_PATH}/imnx/mnt0/lib/modules/ ${KERNEL_SRC_PATH}/imnx/mnt0/lib/firmware/

# KERNEL="kernel8.img"
KERNEL_SRC_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#mkdir -p ${KERNEL_SRC_PATH}/kernel-out/

cd ${KERNEL_SRC_PATH}
ARCH="arm64" CROSS_COMPILE="aarch64-linux-gnu-" make -j4 distclean
ARCH="arm64" CROSS_COMPILE="aarch64-linux-gnu-" make -j4 clean && make -j4 mrproper
cp ${KERNEL_SRC_PATH}/imnx/kernel_config ${KERNEL_SRC_PATH}/.config
ARCH="arm64" CROSS_COMPILE="aarch64-linux-gnu-" make -j4 menuconfig
cp ${KERNEL_SRC_PATH}/.config ${KERNEL_SRC_PATH}/imnx/kernel_config
INSTALL_MOD_PATH=${KERNEL_SRC_PATH}/imnx/mnt0/
INSTALL_FW_PATH=${KERNEL_SRC_PATH}/imnx/mnt0/
export INSTALL_MOD_PATH INSTALL_FW_PATH
ARCH="arm64" CROSS_COMPILE="aarch64-linux-gnu-" make -j4
ARCH="arm64" CROSS_COMPILE="aarch64-linux-gnu-" make -j4 modules_install firmware_install
cp ${KERNEL_SRC_PATH}/arch/arm64/boot/Image ${KERNEL_SRC_PATH}/imnx/mnt0/boot/kernel-v8-imnx-aarch64.img
cp ${KERNEL_SRC_PATH}/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb ${KERNEL_SRC_PATH}/imnx/mnt0/boot/
cp -r ${KERNEL_SRC_PATH}/arch/arm64/boot/dts/overlays/ ${KERNEL_SRC_PATH}/imnx/mnt0/boot/

echo "arm_control=0x200
kernel=kernel-v8-imnx-aarch64.img
arm_freq=1350
core_freq=570
over_voltage=4
temp_limit=75
sdram_freq=570
#disable_splash=1
gpu_mem=128
framebuffer_ignore_alpha=1
framebuffer_swap=1
disable_overscan=1
init_uart_clock=16000000
hdmi_group=2
hdmi_mode=1
hdmi_mode=87
hdmi_cvt 800 480 60 6 0 0 0
dtparam=spi=on
dtoverlay=ads7846,penirq=25,speed=10000,penirq_pull=2,xohms=150" > ${KERNEL_SRC_PATH}/imnx/mnt0/boot/config.txt
echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty0 elevator=deadline root=/dev/mmcblk0p2 net.ifnames=0 rootfstype=ext4 fsck.repair=yes rootwait" > ${KERNEL_SRC_PATH}/imnx/mnt0/boot/cmdline.txt

